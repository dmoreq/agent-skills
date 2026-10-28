# Heuristic Critique

Reference for `ux-critic`. It defines the five critique dimensions, the squint test, Nielsen's ten heuristics, the steering vocabulary, severity, and the report template.

## 1. Five Critique Dimensions

### 1.1 Focal Point and Squint Test

Blur the screenshot or step back until text is unreadable. The primary metric, action, or message must remain the dominant shape.

Pass conditions:
- One element wins the first two seconds.
- The focal element matches the product brief's primary task.
- Secondary cards do not share the same weight, border, and color as the primary one.

Failure signals:
- Four identical KPI cards with no dominant metric.
- A decorative illustration heavier than the primary action.
- The eye lands on a logo or navigation before the task.

### 1.2 Spatial Rhythm and Alignment

Pass conditions:
- Macro whitespace between sections is larger than micro whitespace inside a group.
- Left edges align across headings, cards, and table columns.
- Spacing comes from a 4px or 8px scale, not arbitrary values.

Failure signals:
- Section gaps smaller than card padding.
- Mixed alignment axes across the same column.
- A single card with 17px padding in a 16px system.

### 1.3 State Honesty

Pass conditions:
- Empty states explain why and offer the next action.
- Loading preserves layout geometry and does not look disabled.
- Errors name the cause and the recovery step.
- Disabled controls explain why they are unavailable.
- Partial data is labeled, not hidden.

Failure signals:
- A skeleton with a different height than the final content.
- A greyed-out screen for loading.
- An empty panel with no CTA.
- A success toast while the list is unchanged.

### 1.4 Microcopy and Clarity

Pass conditions:
- Labels are specific verbs: "Create workspace", not "Submit".
- Errors state what happened and what to do next.
- Helper text appears before the mistake, not after.
- The same concept uses one term throughout.

Failure signals:
- "Something went wrong" with no recovery.
- Two names for the same object.
- A destructive action labeled like a safe one.

### 1.5 Mode Fit

Pass conditions:
- Persuade surfaces use expressive hierarchy and narrative.
- Operate surfaces use density, familiarity, and calm hierarchy.
- The visual ambition matches the product brief.

Failure signals:
- A brand hero inside an admin console.
- A flat, low-contrast table on a launch page.
- Decorative motion in a high-frequency workflow.

## 2. Squint Test Procedure

1. View the screenshot at 100% on the shipping viewport.
2. Apply a blur of 6-10px, or step back until text is unreadable.
3. Identify the first three shapes that attract attention.
4. Compare that order with the intended hierarchy in the product brief.
5. Record the mismatch as a finding with the screenshot path.

## 3. Nielsen's Ten Heuristics

| Heuristic | Evidence to collect | Failure example |
| :--- | :--- | :--- |
| 1. Visibility of system status | Loading, saving, success, error states | No feedback after a destructive action |
| 2. Match with the real world | Labels and metaphors | Internal jargon in a user-facing label |
| 3. User control and freedom | Cancel, undo, back, escape | A modal with no close path |
| 4. Consistency and standards | Components, terms, navigation | Two button styles for the same action |
| 5. Error prevention | Confirmation, constraints, defaults | Destructive action without confirmation |
| 6. Recognition rather than recall | Visible options, context | A code the user must remember from another screen |
| 7. Flexibility and efficiency | Shortcuts, bulk actions, presets | Every task requires the full wizard |
| 8. Aesthetic and minimalist design | Signal-to-noise ratio | Decorative badges on every row |
| 9. Error recovery | Cause, fix, preserved input | Cleared form after validation failure |
| 10. Help and documentation | Inline help, empty-state guidance | A blank screen with no explanation |

Mark each heuristic `Pass`, `Fail`, or `Not applicable`. A heuristic without evidence is `Not applicable`, not `Pass`.

## 4. Steering Vocabulary

| Command | Use when | Concrete actions |
| :--- | :--- | :--- |
| `distill` | The screen carries redundant elements | Remove duplicate labels, decorative borders, non-actionable badges; merge repeated metadata |
| `bolder` | The focal point is weak | Increase the primary metric to 3x body size; raise contrast on the primary action; remove competing cards |
| `quieter` | The screen is aggressive or noisy | Reduce saturation; replace filled surfaces with subtle backgrounds; increase whitespace |
| `clarify` | Labels or errors are vague | Rewrite the label as a verb and object; state cause and recovery in the error |
| `polish` | The structure is right but craft is uneven | Align baselines and edges; unify radii; normalize spacing; smooth transitions |
| `harden` | The screen fails under real content | Add overflow handling, long-string wrapping, partial-data states, slow-loading behavior |

Use more than one command only when the finding spans multiple dimensions. Name the command in every finding.

## 5. Severity

| Severity | Definition | Ship effect |
| :--- | :--- | :--- |
| Critical | The primary task is unclear, impossible, or dishonest | Do not ship |
| Important | A significant hierarchy, state, or clarity defect with a workaround | Ship with fixes |
| Suggestion | A clear improvement with no task failure | Schedule |
| Nit | Minor polish | Optional |

## 6. Critique Report Template

Save as `docs/reports/YYYY-MM-DD_ux-critique_<topic>.md`.

```markdown
# UX Critique: <Topic>

- Date: YYYY-MM-DD
- Revision: <commit>
- Viewports: <desktop, mobile>
- Evidence: <screenshot paths>
- Product brief: <path>
- Design system: <path>
- Accessibility gate: Pass | Not run

## Verdict

<Two sentences: the main strength and the main weakness.>

## Findings

### <Issue Title>

- Severity: Critical | Important | Suggestion | Nit
- Dimension: Focal point | Spatial rhythm | State honesty | Microcopy | Mode fit
- Heuristic: <Nielsen number or Not applicable>
- Evidence: <screenshot path and region>
- Finding: <what is wrong>
- Steering: `distill` | `bolder` | `quieter` | `clarify` | `polish` | `harden`
- Fix direction: <concrete change, no code>

## Prioritized Fixes

1. <highest impact fix>
2. <next fix>

## Ship Recommendation

- Verdict: Ship | Ship with fixes | Do not ship
- Blocking findings:
```

## 7. Anti-Patterns

- Critiquing source code instead of a rendered screen.
- Vague feedback such as "make it pop" or "improve the UX".
- Proposing a full redesign for a spacing defect.
- Ignoring the product brief's Surface Mode.
- Treating an accessibility failure as a visual preference.
- Inventing a user metric without evidence.
- Marking an untested heuristic as a pass.
