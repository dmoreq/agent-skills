"""Tests for skills schema validation and frontmatter integrity."""
from pathlib import Path
import re
import yaml

REPO_DIR = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO_DIR / "skills"


def get_all_skills():
    """Retrieve all directories in skills/."""
    return sorted([d for d in SKILLS_DIR.iterdir() if d.is_dir()])


def parse_frontmatter(file_path: Path):
    """Parse YAML frontmatter from a markdown file."""
    content = file_path.read_text(encoding="utf-8")
    if not content.startswith("---"):
        return None, content
    parts = content.split("---", 2)
    if len(parts) < 3:
        return None, content
    frontmatter_raw = parts[1]
    body = parts[2]
    data = yaml.safe_load(frontmatter_raw)
    return data, body


def test_every_skill_has_skill_md():
    """Verify that every subdirectory in skills/ has a SKILL.md file."""
    skills = get_all_skills()
    assert len(skills) >= 20, f"Expected at least 20 skills, found {len(skills)}"
    for skill_dir in skills:
        skill_file = skill_dir / "SKILL.md"
        assert skill_file.exists(), f"Missing SKILL.md in {skill_dir.name}"


def test_skills_frontmatter_validity():
    """Verify that every SKILL.md has valid YAML frontmatter with required keys."""
    for skill_dir in get_all_skills():
        skill_file = skill_dir / "SKILL.md"
        fm, body = parse_frontmatter(skill_file)
        assert fm is not None, f"Failed to parse YAML frontmatter in {skill_file}"
        assert "name" in fm, f"Missing 'name' in frontmatter of {skill_file}"
        assert "description" in fm, f"Missing 'description' in frontmatter of {skill_file}"
        assert fm["name"] == skill_dir.name, (
            f"Skill name '{fm['name']}' does not match directory '{skill_dir.name}'"
        )
        desc = fm["description"].strip()
        assert len(desc) > 20, f"Description too short in {skill_file}"
        assert len(desc) <= 500, f"Description too verbose (>500 chars) in {skill_file}"
