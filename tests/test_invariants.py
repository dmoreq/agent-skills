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


