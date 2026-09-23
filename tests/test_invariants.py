"""Tests for repository invariants and cross-skill references."""
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
    """Ensure kernel invariants (sparklines, character bars) do not leak into skills."""
    forbidden_snippets = [
        "Unicode sparklines",
        "character bars",
    ]
    for skill_dir in SKILLS_DIR.iterdir():
        if not skill_dir.is_dir():
            continue
        skill_file = skill_dir / "SKILL.md"
        content = skill_file.read_text(encoding="utf-8")
        for snippet in forbidden_snippets:
            assert snippet not in content, (
                f"Forbidden global rule snippet '{snippet}' found in {skill_file}. "
                "Global rules must live solely in rules/AGENTS.md."
            )


def test_cross_skill_references_exist():
    """Verify that skills referenced in 'Related Skills' match actual skills."""
    all_skill_names = {d.name for d in SKILLS_DIR.iterdir() if d.is_dir()}

    # Regex for bolded skill names like **python-testing** or **code-review**
    ref_pattern = re.compile(r"\*\*([a-z0-9-]+)\*\*")

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
            # Check if this matches a known skill or acceptable target
            if target in ("python-testing", "code-simplification", "code-review",
                          "code-minimalism", "verify-and-stop", "deprecation-migration",
                          "tech-research", "doubt-driven-development", "data-visualization",
                          "data-science", "data-storytelling", "plotly-dash",
                          "python-pro", "python-patterns", "python-concurrency",
                          "python-performance", "rust-pro", "rust-async-patterns",
                          "pyo3-maturin", "context7-mcp", "technical-reporting",
                          "algorithm-optimization"):
                assert target in all_skill_names, (
                    f"Referenced skill '{target}' in {skill_file} does not exist in skills/"
                )
