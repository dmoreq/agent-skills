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
FONT_HOSTS = ("https://fonts.googleapis.com", "https://fonts.gstatic.com")
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
    "font-optical-sizing",
)
CHART_MARKERS = (
    "chart-tooltip",
    "data-chart-point",
    "data-label",
    'role="status"',
    'aria-hidden="true"',
    'pointer-events="none"',
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
        self.has_theme_toggle = False
        self.has_font_stylesheet = False
        self.has_chart = False
        self.preset_switches: list[str] = []
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
        self._read_preset_switch(attributes)
        self._read_heading(tag)
        self._read_structure(tag, attributes)
        self._read_asset(tag, attributes)
        self._read_id(attributes)
        self._read_interactions(tag, attributes)

    def handle_endtag(self, tag: str) -> None:
        if tag == "script" and self._in_script:
            self._close_script()
        if tag == "table" and self._table_stack:
            if not self._table_stack.pop():
                self.tables_without_head += 1

    def handle_data(self, data: str) -> None:
        if self._in_script:
            self._script_text.append(data)

    def _read_meta(self, attributes: dict[str, str]) -> None:
        if attributes.get("charset", "").lower() == "utf-8":
            self.meta_charset = True
        name = attributes.get("name", "").lower()
        content = attributes.get("content", "").lower()
        if name == "viewport" and "width=device-width" in content:
            self.meta_viewport = True

    def _read_preset_switch(self, attributes: dict[str, str]) -> None:
        classes = attributes.get("class", "").lower()
        is_switch = (
            "data-preset-val" in attributes
            or "preset-btn" in classes
            or "preset-group" in classes
        )
        if is_switch:
            self.preset_switches.append(attributes.get("id") or classes or "preset control")

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
        if tag == "button" and attributes.get("type", "").lower() != "button":
            self.buttons_without_type.append(attributes.get("id") or "unnamed")
        if attributes.get("id") == "theme-toggle":
            self.has_theme_toggle = True
        if "data-chart-point" in attributes or attributes.get("id") == "chart-tooltip":
            self.has_chart = True

    def _read_asset(self, tag: str, attributes: dict[str, str]) -> None:
        attribute = ASSET_ATTRIBUTES.get(tag)
        if not attribute:
            return
        value = attributes.get(attribute, "").strip()
        if not value or value.startswith(("#", "data:")):
            return
        if tag == "link" and "fonts.googleapis.com/css" in value:
            self.has_font_stylesheet = True
        if tag == "link" and value.startswith(FONT_HOSTS):
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

    def _close_script(self) -> None:
        text = "".join(self._script_text).lower()
        if self._script_type not in {"application/json", "application/ld+json", "text/template"}:
            for term in NETWORK_TERMS:
                if term in text:
                    self.inline_network_terms.append(term)
        self._in_script = False
        self._script_text = []


def _parser_failures(parser: ReportParser) -> list[str]:
    preset = parser.html_attrs.get("data-preset", "")
    checks = (
        (parser.doctype, "missing <!DOCTYPE html>"),
        (parser.meta_charset, 'missing <meta charset="utf-8">'),
        (parser.meta_viewport, "missing viewport meta with width=device-width"),
        (bool(parser.html_attrs.get("lang")), "missing <html lang>"),
        (preset in PRESETS, f"data-preset must be one of {PRESETS}, found '{preset}'"),
        (bool(parser.html_attrs.get("data-theme")), "missing data-theme on <html>"),
        (parser.has_theme_toggle, 'missing id="theme-toggle" control'),
        (parser.has_font_stylesheet, "missing Google Fonts stylesheet link"),
        (not parser.preset_switches, f"preset switcher is not allowed: {parser.preset_switches}"),
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
    )
    return [message for passed, message in checks if not passed]


def _preset_values(text: str) -> set[str]:
    return set(re.findall(r'data-preset="([^"]+)"', text))


def _external_css_urls(text: str) -> list[str]:
    pattern = r"(?:url\(|@import\s+(?:url\()?)['\"]?(https?://[^)'\";]+)"
    return [url for url in re.findall(pattern, text, re.IGNORECASE) if not url.startswith(FONT_HOSTS)]


def _text_failures(text: str) -> list[str]:
    lowered = text.lower()
    failures = [f"missing CSS marker: {marker}" for marker in CSS_MARKERS if marker not in lowered]
    presets = _preset_values(text)
    if len(presets) > 1:
        failures.append(f"multiple preset blocks: {sorted(presets)}")
    elif presets - set(PRESETS):
        failures.append(f"unknown preset: {sorted(presets - set(PRESETS))}")
    failures += [
        f"missing theme selector: {theme}"
        for theme in ("light", "dark")
        if f'data-theme="{theme}"' not in text
    ]
    if "fonts.googleapis.com" not in lowered:
        failures.append("missing fonts.googleapis.com link")
    if "display=swap" not in lowered:
        failures.append("missing display=swap on the font stylesheet")
    if "cdn.tailwindcss.com" in lowered:
        failures.append("Tailwind CDN is not allowed")
    if "replace_with" in lowered:
        failures.append("unresolved REPLACE_WITH placeholder")
    failures += [f"external CSS request is not allowed: {url[:80]}" for url in _external_css_urls(text)]
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
    if parser.has_chart:
        failures += [
            f"chart interaction marker missing: {marker}"
            for marker in CHART_MARKERS
            if marker not in text.lower()
        ]
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
