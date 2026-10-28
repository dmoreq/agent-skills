"""Tests for repository invariants, cross-skill references, and progressive disclosure links."""
import ast
from pathlib import Path
import re

REPO_DIR = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO_DIR / "skills"
RULES_FILE = REPO_DIR / "rules" / "AGENTS.md"


def test_rules_file_exists():
    """Verify AGENTS.md exists and is non-empty."""
    assert RULES_FILE.exists()
    assert RULES_FILE.stat().st_size > 1000


def test_no_forbidden_rule_duplicates_in_skills():
    """Ensure kernel invariants (sparklines, character bars, emojis, broken HTML) do not leak into skills."""
    forbidden_snippets = [
        "Unicode sparklines",
        "character bars",
        "❌",
        "✅",
        "⚠️",
        "🚀",
        "</code>",
    ]
    for skill_file in SKILLS_DIR.rglob("*.md"):
        content = skill_file.read_text(encoding="utf-8")
        for snippet in forbidden_snippets:
            assert snippet not in content, (
                f"Forbidden snippet '{snippet}' found in {skill_file}. "
                "Global rules and markdown hygiene must be respected."
            )


def test_cross_skill_references_exist():
    """Verify that every bolded kebab-case skill name in 'Related Skills' exists in skills/."""
    all_skill_names = {d.name for d in SKILLS_DIR.iterdir() if d.is_dir()}
    ref_pattern = re.compile(r"\*\*([a-z0-9]+-[a-z0-9-]+)\*\*")

    for skill_dir in SKILLS_DIR.iterdir():
        if not skill_dir.is_dir():
            continue
        skill_file = skill_dir / "SKILL.md"
        content = skill_file.read_text(encoding="utf-8")
        if "## Related Skills" not in content:
            continue

        related_section = content.split("## Related Skills", 1)[1].split("##", 1)[0]
        matches = ref_pattern.findall(related_section)
        for target in matches:
            assert target in all_skill_names, (
                f"Referenced skill '{target}' in {skill_file} does not exist in skills/"
            )


def test_skill_internal_file_references_exist():
    """Verify that any references/*.md or scripts/*.py path mentioned in skills exists."""
    ref_pattern = re.compile(r"\breferences/[a-z0-9-]+\.md\b")
    script_pattern = re.compile(r"\bscripts/[a-z0-9_]+\.py\b")

    for skill_dir in SKILLS_DIR.iterdir():
        if not skill_dir.is_dir():
            continue
        assert not (skill_dir / "resources").exists(), (
            f"Legacy 'resources/' folder found in {skill_dir.name}; use 'references/' instead."
        )

        skill_file = skill_dir / "SKILL.md"
        content = skill_file.read_text(encoding="utf-8")
        for match in set(ref_pattern.findall(content) + script_pattern.findall(content)):
            target_path = skill_dir / match
            assert target_path.exists(), (
                f"Missing referenced file '{match}' in {skill_file} (expected {target_path})"
            )

        for ref_file in (skill_dir / "references").glob("*.md"):
            ref_content = ref_file.read_text(encoding="utf-8")
            for match in set(ref_pattern.findall(ref_content)):
                target_path = skill_dir / match
                assert target_path.exists(), (
                    f"Missing referenced file '{match}' in {ref_file} (expected {target_path})"
                )


def test_python_scripts_complexity_and_safety():
    """Assert all executable Python scripts in skills adhere to indentation and structural budgets."""
    def get_max_depth(node: ast.AST, current: int = 0) -> int:
        depths = [current]
        for child in ast.iter_child_nodes(node):
            if isinstance(child, (ast.If, ast.For, ast.While, ast.With, ast.Try)):
                depths.append(get_max_depth(child, current + 1))
            else:
                depths.append(get_max_depth(child, current))
        return max(depths)

    script_files = list(SKILLS_DIR.glob("*/scripts/*.py"))
    assert len(script_files) > 0, "Expected at least one skill python script"
    for script_file in script_files:
        tree = ast.parse(script_file.read_text(encoding="utf-8"), filename=str(script_file))
        for node in ast.walk(tree):
            if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                depth = get_max_depth(node)
                assert depth <= 3, (
                    f"Function '{node.name}' in {script_file} has indentation depth {depth} > 3 "
                    f"(violates rules/AGENTS.md structural complexity threshold)"
                )


def test_progress_visibility_rule_invariants():
    """Verify AGENTS.md and python-pro enforce progress visibility for long tasks."""
    rules_text = RULES_FILE.read_text(encoding="utf-8")
    assert "Progress Visibility for Long Tasks" in rules_text
    assert "tqdm" in rules_text

    python_pro_skill = SKILLS_DIR / "python-pro" / "SKILL.md"
    assert python_pro_skill.exists()
    skill_text = python_pro_skill.read_text(encoding="utf-8")
    assert "Progress Visibility" in skill_text
    assert "tqdm" in skill_text


def test_related_skills_graph_degrees():
    """Verify every skill has at least two outgoing and two incoming handoffs."""
    all_skills = {d.name for d in SKILLS_DIR.iterdir() if d.is_dir()}
    ref_pattern = re.compile(r"\*\*([a-z0-9]+-[a-z0-9-]+)\*\*")
    outgoing: dict[str, set[str]] = {}

    for name in all_skills:
        content = (SKILLS_DIR / name / "SKILL.md").read_text(encoding="utf-8")
        assert "## Related Skills" in content, f"{name} has no '## Related Skills' section"
        section = content.split("## Related Skills", 1)[1].split("\n## ", 1)[0]
        outgoing[name] = set(ref_pattern.findall(section))

    incoming: dict[str, set[str]] = {name: set() for name in all_skills}
    for source, targets in outgoing.items():
        for target in targets:
            assert target in all_skills, f"{source} links to unknown skill '{target}'"
            assert target != source, f"{source} links to itself"
            incoming[target].add(source)

    for name in sorted(all_skills):
        assert len(outgoing[name]) >= 2, (
            f"{name} has out_degree {len(outgoing[name])} (<2); add '## Related Skills' handoffs."
        )
        assert len(incoming[name]) >= 2, (
            f"{name} has in_degree {len(incoming[name])} (<2); another skill must hand off to it."
        )


def test_readme_covers_every_skill():
    """Verify the README catalog matches the skill directories exactly."""
    readme = (REPO_DIR / "README.md").read_text(encoding="utf-8")
    skill_names = {d.name for d in SKILLS_DIR.iterdir() if d.is_dir()}
    catalog = readme.split("## Skills Catalog", 1)[1].split("\n## ", 1)[0]
    catalog_names = set(re.findall(r"\|\s*\*\*`([a-z0-9-]+)`\*\*\s*\|", catalog))
    assert catalog_names == skill_names, (
        f"README catalog mismatch. Missing: {sorted(skill_names - catalog_names)}; "
        f"extra: {sorted(catalog_names - skill_names)}"
    )


def test_artifact_paths_use_iso_dates():
    """Verify design, contract, and review artifacts enforce ISO-dated paths."""
    for skill_name in ("spec-driven-design", "codebase-contracts", "doubt-driven-development", "technical-reporting", "html-report"):
        content = (SKILLS_DIR / skill_name / "SKILL.md").read_text(encoding="utf-8")
        assert "YYYY-MM-DD_" in content, f"{skill_name} does not mandate ISO-dated artifact paths"

    spec = (SKILLS_DIR / "spec-driven-design" / "SKILL.md").read_text(encoding="utf-8")
    assert "docs/designs/YYYY-MM-DD_" in spec, "spec-driven-design must write under docs/designs/"
    contracts = (SKILLS_DIR / "codebase-contracts" / "SKILL.md").read_text(encoding="utf-8")
    assert "docs/reports/YYYY-MM-DD_drift-report_" in contracts
    review = (SKILLS_DIR / "doubt-driven-development" / "SKILL.md").read_text(encoding="utf-8")
    assert "docs/reports/YYYY-MM-DD_goldfish-review_" in review
    html_report = (SKILLS_DIR / "html-report" / "SKILL.md").read_text(encoding="utf-8")
    assert "docs/reports/YYYY-MM-DD_" in html_report
    assert ".html" in html_report


def test_no_claude_or_plugin_escape_hatches():
    """Verify the consolidated suite has no Claude-specific or legacy plugin escape hatches."""
    forbidden = ["CLAUDE_PLUGIN_ROOT", "~/.claude", "$HOME/.claude", "Claude Code", "claude.md"]
    targets = list(SKILLS_DIR.rglob("*.md")) + [
        RULES_FILE,
        REPO_DIR / "README.md",
    ]
    for path in targets:
        content = path.read_text(encoding="utf-8")
        for snippet in forbidden:
            assert snippet not in content, f"Legacy host escape hatch '{snippet}' found in {path}"


def test_no_hermes_host_support():
    """Verify Hermes host support and its multi-profile bot specs are fully removed."""
    forbidden = ("hermes", "seven-bots", "seven_bots")
    targets = [RULES_FILE, REPO_DIR / "README.md", REPO_DIR / "setup.sh", *SKILLS_DIR.rglob("*.md")]
    for path in targets:
        content = path.read_text(encoding="utf-8").lower()
        for snippet in forbidden:
            assert snippet not in content, f"Removed Hermes reference '{snippet}' found in {path}"


def test_code_review_goldfish_lenses_integrity():
    """Verify the code-review Goldfish reference defines all five personas and is wired in."""
    reference = SKILLS_DIR / "code-review" / "references" / "goldfish-code-review-lenses.md"
    assert reference.exists(), "Missing code-review Goldfish lens reference"
    content = reference.read_text(encoding="utf-8")

    personas = [
        "cr-correctness-invariants",
        "cr-mechanism-generalization",
        "cr-codebase-reuse-and-contracts",
        "cr-concurrency-memory-perf",
        "cr-security-trust-boundary",
    ]
    for persona in personas:
        assert persona in content, f"Missing persona '{persona}' in {reference}"

    for required in ("git grep", "PROPOSE FIX", "CONTEST", "ESCALATE", "DECLINE"):
        assert required in content, f"Missing '{required}' in {reference}"

    for emoji in ("❌", "✅", "⚠️", "🚀"):
        assert emoji not in content, f"Forbidden emoji '{emoji}' in {reference}"

    skill_text = (SKILLS_DIR / "code-review" / "SKILL.md").read_text(encoding="utf-8")
    assert "references/goldfish-code-review-lenses.md" in skill_text
    assert "cr-mechanism-generalization" in skill_text
    assert "cr-codebase-reuse-and-contracts" in skill_text


def test_html_report_skill_integrity():
    """Verify the html-report skill and its offline/print scaffold are wired in."""
    skill_file = SKILLS_DIR / "html-report" / "SKILL.md"
    reference = SKILLS_DIR / "html-report" / "references" / "html-report-scaffold.md"
    assert skill_file.exists(), "Missing html-report SKILL.md"
    assert reference.exists(), "Missing html-report scaffold reference"

    skill_text = skill_file.read_text(encoding="utf-8")
    scaffold = reference.read_text(encoding="utf-8")

    assert "references/html-report-scaffold.md" in skill_text
    assert "**technical-reporting**" in skill_text
    assert "**data-visualization**" in skill_text

    for marker in ("<!DOCTYPE html>", "prefers-color-scheme", "@media print", "tabular-nums", "Copy Summary"):
        assert marker in scaffold, f"Missing scaffold marker '{marker}'"

    for approval_rule in ("explicitly approves", "offline warning", "SRI hash"):
        assert approval_rule in skill_text, f"Missing controlled CDN rule '{approval_rule}'"

    for emoji in ("❌", "✅", "⚠️", "🚀"):
        assert emoji not in skill_text, f"Forbidden emoji '{emoji}' in {skill_file}"
        assert emoji not in scaffold, f"Forbidden emoji '{emoji}' in {reference}"


