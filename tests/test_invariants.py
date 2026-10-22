"""Tests for repository invariants, cross-skill references, and progressive disclosure links."""
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
    """Verify that any references/*.md or scripts/*.py path mentioned in SKILL.md exists."""
    rel_path_pattern = re.compile(r"\b(?:references/[a-z0-9-]+\.md|scripts/[a-z0-9_]+\.py)\b")
    for skill_dir in SKILLS_DIR.iterdir():
        if not skill_dir.is_dir():
            continue
        assert not (skill_dir / "resources").exists(), (
            f"Legacy 'resources/' folder found in {skill_dir.name}; use 'references/' instead."
        )
        skill_file = skill_dir / "SKILL.md"
        content = skill_file.read_text(encoding="utf-8")
        for rel_match in set(rel_path_pattern.findall(content)):
            target_path = skill_dir / rel_match
            assert target_path.exists(), (
                f"Missing referenced file '{rel_match}' in {skill_file} (expected {target_path})"
            )
