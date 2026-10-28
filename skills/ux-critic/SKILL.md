---
name: ux-critic
description: >-
  Red-team rendered UI with heuristic critique, squint tests, and targeted design
  steering. Use after accessibility gates pass or when asked to critique, review,
  or elevate an existing interface. Not for implementation, token generation, or
  code review.
risk: safe
source: local
date_added: "2026-10-28"
---

# UX Critic Skill

Review the rendered interface as a hostile design director. Find what is weak, missing, or dishonest before a user does. Do not edit code.

## When to Use
- After `ui-accessibility` passes and the screen is ready for a design review.
- When asked to critique, review, or elevate an existing interface.
- When a screen feels cluttered, flat, confusing, or off-brand.
- Before a stakeholder demo or a release candidate review.
- An executive or decision report rendered as a single-file HTML page.

## When Not to Use
- Implementation or code changes (`html-report`, `plotly-dash`, `python-pro`).
- Token, typography, or component generation (`design-system`).
- WCAG conformance audit (`ui-accessibility`).
- Decision or spec review before UI exists (`doubt-driven-development`).
- Code correctness, security, or performance (`code-review`).

## Artifact Path
- Critique report: `docs/reports/YYYY-MM-DD_ux-critique_<topic>.md`.
- Screenshots live beside the report or in the host artifact directory.
- Never write an undated file at the repository root.

## Workflow

### Step 1: Collect Evidence
1. Capture desktop and mobile screenshots at shipping viewports.
2. Read the product brief and the design system spec.
3. Confirm the accessibility gate has passed or record that it has not.
4. If screenshots are unavailable, stop and request them. Do not critique from source code alone.

### Step 2: Run the Six-Dimension Audit
The full dimension table, heuristic mapping, and steering commands are in `references/heuristic-critique.md`.

| Dimension | Question | Failure signal |
| :--- | :--- | :--- |
| Focal point and squint test | Is the primary metric or action unmistakable within two seconds? | Four equal-weight cards compete; the eye lands on decoration |
| Spatial rhythm and alignment | Is macro whitespace larger than micro whitespace? Are alignment axes unified? | Inverted rhythm; mixed left edges; cramped groups |
| State honesty | Does empty guide, loading preserve geometry, and error explain recovery? | Loading looks disabled; empty state has no next step |
| Microcopy and clarity | Are labels declarative, human, and specific? | "Submit", "Something went wrong", vague helper text |
| Mode fit | Does the visual ambition match the Surface Mode? | A brand hero inside an operations console; a flat admin table on a launch page |
| YAGNI and signifier honesty | Did an unrequested widget, decorative icon, or vanity metric appear? Are controls recognizable without hover? | Hallucinated chrome; ghost buttons; false minimalism |

### Step 3: Apply Dieter Rams and Nielsen
Before Nielsen, score the screen against five Rams principles:
- **#4 Good design is understandable**: the primary action is obvious without a manual.
- **#5 Unobtrusive**: decoration does not compete with the task.
- **#6 Honest**: states and affordances do not overpromise.
- **#8 Thorough down to the last detail**: alignment, states, and edge cases are complete.
- **#10 Less, but better**: remove before you add.

Then apply Nielsen's Ten Heuristics:
Evaluate each heuristic against the screenshots and record evidence:
1. Visibility of system status.
2. Match between system and the real world.
3. User control and freedom.
4. Consistency and standards.
5. Error prevention.
6. Recognition rather than recall.
7. Flexibility and efficiency of use.
8. Aesthetic and minimalist design.
9. Help users recognize, diagnose, and recover from errors.
10. Help and documentation.

A heuristic that does not apply is marked `Not applicable`, not `Pass`.

### Step 4: Run the Mandatory Subtraction Pass
Run subtraction before any polish:
1. `distill`: remove badges, decorative icons, redundant subtitles, and outer borders until removing one more item would break task comprehension.
2. `quieter`: reduce chroma and contrast on secondary metadata, gridlines, and auxiliary controls.
3. `clarify`: replace vague labels with verb-noun microcopy.
4. `polish`: align baselines, optical padding, and 100-180ms ease-out transitions.

Use `bolder` or `harden` only after subtraction, when hierarchy or resilience still needs work.

Then use the deterministic steering vocabulary. Replace vague feedback with one or more commands. Each command names a concrete change.

| Command | Intent | Example action |
| :--- | :--- | :--- |
| `distill` | Remove noise | Drop redundant badges, decorative borders, duplicate labels |
| `bolder` | Strengthen hierarchy | Increase the hero metric to 3x body size; sharpen the focal contrast |
| `quieter` | Reduce aggression | Soften saturated surfaces; restore breathing room in dense screens |
| `clarify` | Improve meaning | Rename "Submit" to "Create workspace"; rewrite the error recovery step |
| `polish` | Align craft | Harmonize radii, baselines, spacing, and transition timing |
| `harden` | Improve resilience | Cover overflow, long strings, slow loading, and partial data |

### Step 5: Write the Critique
The report contains:
- Scope, revision, viewports, and evidence paths.
- A two-sentence verdict.
- `Keep`: 1-2 elements that already exemplify "less, but better".
- Findings ordered by severity, each with the dimension, heuristic, evidence, and the steering command.
- `**THE ONE DELETION**`: the single highest-leverage element, wrapper, or control to remove completely.
- A prioritized fix list. Do not edit the code.
- A final ship recommendation: `Ship`, `Ship with fixes`, or `Do not ship`.

## Rules
- Critique the rendered result, not the author.
- Do not invent metrics or screenshots. If evidence is missing, request it.
- Do not propose a redesign when a targeted steering command fixes the issue.
- Do not polish before the subtraction pass.
- Name exactly one `**THE ONE DELETION**` in every critique.
- Do not contradict the product brief's Surface Mode.
- Do not override an accessibility failure with a visual preference.
- Do not accept false minimalism: missing signifiers, focus, labels, or states.
- Use `Critical`, `Important`, `Suggestion`, and `Nit`; no emoji.

## Verification Checklist
- [ ] Desktop and mobile screenshots are available.
- [ ] Product brief and design system are read.
- [ ] All six dimensions are evaluated, including YAGNI and signifier honesty.
- [ ] The five Rams principles are checked.
- [ ] All ten heuristics are marked Pass, Fail, or Not applicable.
- [ ] The subtraction pass ran before polish.
- [ ] Every finding names a steering command.
- [ ] `**THE ONE DELETION**` is named.
- [ ] The report uses an ISO-dated path under `docs/reports/`.
- [ ] The ship recommendation is explicit.

## Related Skills
- Use **html-report** when the critique targets a single-file report; review desktop, mobile, and print screenshots.
- Use **ux-product-shaper** for the Surface Mode and 8-state contract the critique must respect.
- Use **design-system** for token, component, and responsive rules behind the findings.
- Use **ui-accessibility** before this critique; accessibility failures block visual polish.
- Use **doubt-driven-development** when a finding challenges a product or architecture decision.
- Use **verify-and-stop** for the decisive final check and stop.
