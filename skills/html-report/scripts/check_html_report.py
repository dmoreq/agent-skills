#!/usr/bin/env python3
"""Validate structural invariants of a single-file HTML report."""
from __future__ import annotations

import argparse
from html.parser import HTMLParser
from pathlib import Path
import re
import sys

MAX_BYTES = 1_000_000
PRESETS = ("dossier", "zen-garden", "chronicle")
CHART_CDN = "cdn.jsdelivr.net/npm/chart.js@"
ASSET_ATTRIBUTES = {
    "script": "src",
    "link": "href",
    "img": "src",
    "iframe": "src",
    "object": "data",
    "embed": "src",
    "source": "src",
}
EVENT_ATTRIBUTES = {
    "onclick",
    "onload",
    "onerror",
    "onchange",
    "onsubmit",
    "onkeydown",
    "onkeyup",
    "onmousedown",
    "onmouseup",
    "onmouseover",
    "onfocus",
    "onblur",
    "oninput",
}
CSS_MARKERS = (
    "prefers-color-scheme",
    "prefers-reduced-motion",
    "@media print",
    "@page",
    "tabular-nums",
    "focus-visible",
)
NETWORK_TERMS = ("fetch(", "xmlhttprequest", "new websocket", "new eventsource")


class ReportParser(HTMLParser):
    """Collect the structural facts the validator needs from one HTML file."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.doctype = False
        self.html_attrs: dict[str, str] = {}
        self.meta_charset = False
        self.meta_viewport = False
        self.preset_buttons: set[str] = set()
        self.has_copy_summary = False
        self.inline_handlers: list[str] = []
        self.external_assets: list[str] = []
        self.inline_network_terms: list[str] = []
        self.ids: list[str] = []
        self.duplicate_ids: set[str] = set()
        self.h1_count = 0
        self.last_heading = 0
        self.heading_jumps: list[str] = []
        self.tables_without_head = 0
        self.th_without_scope = 0
        self.buttons_without_type: list[str] = []
        self.has_details = False
        self._table_stack: list[bool] = []
        self._button_depth = 0
        self._button_text: list[str] = []
        self._in_script = False
        self._script_type = ""
        self._script_text: list[str] = []

    def handle_decl(self, decl: str) -> None:
        if decl.strip().lower() == "doctype html":
            self.doctype = True

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attributes = {name.lower(): (value or "") for name, value in attrs}
        if tag == "html":
            self.html_attrs = attributes
        if tag == "meta":
            self._read_meta(attributes)
        self._read_preset_button(attributes)
        self._read_heading(tag)
        self._read_structure(tag, attributes)
        self._read_asset(tag, attributes)
        self._read_id(attributes)
        self._read_interactions(tag, attributes)

    def handle_endtag(self, tag: str) -> None:
        if tag == "button" and self._button_depth:
            self._close_button()
        if tag == "script" and self._in_script:
            self._close_script()
        if tag == "table" and self._table_stack:
            if not self._table_stack.pop():
                self.tables_without_head += 1

    def handle_data(self, data: str) -> None:
        if self._button_depth:
            self._button_text.append(data)
        if self._in_script:
            self._script_text.append(data)

    def _read_meta(self, attributes: dict[str, str]) -> None:
        if attributes.get("charset", "").lower() == "utf-8":
            self.meta_charset = True
        name = attributes.get("name", "").lower()
        content = attributes.get("content", "").lower()
        if name == "viewport" and "width=device-width" in content:
            self.meta_viewport = True

    def _read_preset_button(self, attributes: dict[str, str]) -> None:
        if "data-preset-val" in attributes:
            self.preset_buttons.add(attributes["data-preset-val"])

    def _read_heading(self, tag: str) -> None:
        if len(tag) != 2 or tag[0] != "h" or tag[1] not in "123456":
            return
        level = int(tag[1])
        if self.last_heading and level > self.last_heading + 1:
            self.heading_jumps.append(f"h{self.last_heading} to h{level}")
        self.last_heading = level

    def _read_structure(self, tag: str, attributes: dict[str, str]) -> None:
        if tag == "h1":
            self.h1_count += 1
        if tag == "table":
            self._table_stack.append(False)
        if tag == "details":
            self.has_details = True
        if tag == "thead" and self._table_stack:
            self._table_stack[-1] = True
        if tag == "th" and "scope" not in attributes and "role" not in attributes:
            self.th_without_scope += 1
        if tag == "button":
            self._open_button(attributes)

    def _read_asset(self, tag: str, attributes: dict[str, str]) -> None:
        attribute = ASSET_ATTRIBUTES.get(tag)
        if not attribute:
            return
        value = attributes.get(attribute, "").strip()
        if not value or value.startswith(("#", "data:")):
            return
        approved = (
            tag == "script"
            and CHART_CDN in value
            and bool(attributes.get("integrity"))
            and bool(attributes.get("crossorigin"))
        )
        if not approved:
            self.external_assets.append(f"<{tag} {attribute}={value[:80]}>")

    def _read_id(self, attributes: dict[str, str]) -> None:
        value = attributes.get("id", "")
        if not value:
            return
        if value in self.ids:
            self.duplicate_ids.add(value)
        self.ids.append(value)

    def _read_interactions(self, tag: str, attributes: dict[str, str]) -> None:
        if tag == "script":
            self._in_script = True
            self._script_type = attributes.get("type", "").lower()
            self._script_text = []
        for name in attributes:
            if name in EVENT_ATTRIBUTES:
                self.inline_handlers.append(name)

    def _open_button(self, attributes: dict[str, str]) -> None:
        if attributes.get("type", "").lower() != "button":
            self.buttons_without_type.append(attributes.get("id") or "unnamed")
        self._button_depth += 1
        self._button_text = []
        if attributes.get("id") == "copy-summary":
            self.has_copy_summary = True
        if "copy summary" in attributes.get("aria-label", "").lower():
            self.has_copy_summary = True

    def _close_button(self) -> None:
        label = " ".join("".join(self._button_text).split()).lower()
        if "copy summary" in label:
            self.has_copy_summary = True
        self._button_depth = max(0, self._button_depth - 1)
        self._button_text = []

    def _close_script(self) -> None:
        text = "".join(self._script_text).lower()
        if self._script_type not in {"application/json", "application/ld+json", "text/template"}:
            for term in NETWORK_TERMS:
                if term in text:
                    self.inline_network_terms.append(term)
        self._in_script = False
        self._script_text = []


def _parser_failures(parser: ReportParser) -> list[str]:
    checks = (
        (parser.doctype, "missing <!DOCTYPE html>"),
        (parser.meta_charset, 'missing <meta charset="utf-8">'),
        (parser.meta_viewport, "missing viewport meta with width=device-width"),
        (bool(parser.html_attrs.get("lang")), "missing <html lang>"),
        (parser.html_attrs.get("data-preset") == "dossier", "default data-preset must be dossier"),
        (bool(parser.html_attrs.get("data-theme")), "missing data-theme on <html>"),
        (parser.has_copy_summary, "missing Copy Summary control"),
        (parser.h1_count == 1, f"expected one <h1>, found {parser.h1_count}"),
        (not parser.heading_jumps, f"heading level jumps: {parser.heading_jumps}"),
        (not parser.duplicate_ids, f"duplicate ids: {sorted(parser.duplicate_ids)}"),
        (not parser.inline_handlers, f"inline event handlers: {sorted(set(parser.inline_handlers))}"),
        (not parser.external_assets, f"external or sidecar assets: {parser.external_assets}"),
        (
            not parser.inline_network_terms,
            f"inline script network calls: {sorted(set(parser.inline_network_terms))}",
        ),
        (parser.tables_without_head == 0, f"{parser.tables_without_head} table(s) without <thead>"),
        (parser.th_without_scope == 0, f"{parser.th_without_scope} <th> without scope or role"),
        (
            not parser.buttons_without_type,
            f"buttons without type=button: {parser.buttons_without_type}",
        ),
        (
            set(PRESETS) <= parser.preset_buttons,
            f"missing preset button: {sorted(set(PRESETS) - parser.preset_buttons)}",
        ),
    )
    return [message for passed, message in checks if not passed]


def _text_failures(text: str) -> list[str]:
    lowered = text.lower()
    failures = [f"missing CSS marker: {marker}" for marker in CSS_MARKERS if marker not in lowered]
    failures += [
        f"missing preset token: {preset}"
        for preset in PRESETS
        if f'data-preset="{preset}"' not in text
    ]
    failures += [
        f"missing theme selector: {theme}"
        for theme in ("light", "dark")
        if f'data-theme="{theme}"' not in text
    ]
    if "cdn.tailwindcss.com" in lowered:
        failures.append("Tailwind CDN is not allowed")
    if "replace_with" in lowered:
        failures.append("unresolved REPLACE_WITH placeholder")
    if re.search(r"url\(\s*['\"]?https?://", text, re.IGNORECASE):
        failures.append("external CSS url() is not allowed")
    if re.search(r"@import\s+(url\()?['\"]?https?://", text, re.IGNORECASE):
        failures.append("external CSS @import is not allowed")
    return failures


def validate(path: Path) -> list[str]:
    try:
        data = path.read_bytes()
    except OSError as error:
        return [f"cannot read file: {error}"]
    if len(data) > MAX_BYTES:
        return [f"file is {len(data)} bytes; limit is {MAX_BYTES}"]
    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError as error:
        return [f"file is not UTF-8: {error}"]
    parser = ReportParser()
    parser.feed(text)
    failures = _parser_failures(parser) + _text_failures(text)
    if parser.has_details and "details:not([open])" not in text.lower():
        failures.append("details present but print CSS does not expand closed details")
    return failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("report", type=Path, help="Path to the generated HTML report")
    args = parser.parse_args()
    failures = validate(args.report)
    if failures:
        print(f"FAIL: {args.report}")
        for failure in failures:
            print(f"  - {failure}")
        return 1
    print(f"PASS: {args.report}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
