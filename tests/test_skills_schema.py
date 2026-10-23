"""Tests for skills schema validation, frontmatter integrity, and progressive disclosure budgets."""
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None

REPO_DIR = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO_DIR / "skills"


def get_all_skills():
    """Retrieve all directories in skills/."""
    return sorted([d for d in SKILLS_DIR.iterdir() if d.is_dir()])


def _parse_simple_yaml(raw: str) -> dict[str, str]:
    """Stdlib fallback parser for simple YAML frontmatter (key: value and >- blocks)."""
    result: dict[str, str] = {}
    current_key: str | None = None
    multiline_buf: list[str] = []
    for line in raw.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if current_key and (line.startswith("  ") or line.startswith("\t")):
            multiline_buf.append(line.strip())
            result[current_key] = " ".join(multiline_buf)
            continue
        current_key = None
        multiline_buf = []
        if ":" in line:
            key, val = line.split(":", 1)
            key = key.strip()
            val = val.strip().strip('"').strip("'")
            if val in (">-", ">", "|", "|-"):
                current_key = key
                result[key] = ""
            else:
                result[key] = val
    return result


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
    data = yaml.safe_load(frontmatter_raw) if yaml is not None else _parse_simple_yaml(frontmatter_raw)
    return data, body


def test_every_skill_has_skill_md():
    """Verify that every subdirectory in skills/ has a SKILL.md file."""
    skills = get_all_skills()
    assert len(skills) == 23, f"Expected 23 skills in optimal suite, found {len(skills)}"
    for skill_dir in skills:
        skill_file = skill_dir / "SKILL.md"
        assert skill_file.exists(), f"Missing SKILL.md in {skill_dir.name}"


def test_skills_frontmatter_and_progressive_disclosure():
    """Verify YAML frontmatter schema and progressive disclosure line/byte budgets."""
    for skill_dir in get_all_skills():
        skill_file = skill_dir / "SKILL.md"
        content = skill_file.read_text(encoding="utf-8")
        lines = content.splitlines()
        assert len(lines) <= 250, (
            f"{skill_file.name} in {skill_dir.name} has {len(lines)} lines (>250); "
            "offload details to references/ for progressive disclosure."
        )
        assert len(content.encode("utf-8")) <= 12000, (
            f"{skill_file.name} in {skill_dir.name} exceeds 12 KB progressive disclosure budget."
        )

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
