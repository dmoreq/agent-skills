# Product and State Contracts

Reference for `ux-product-shaper`. It defines the Surface Mode decision, information architecture rules, the 8-state matrix, and the product brief template.

## 1. Surface Mode

| Dimension | Persuade & Experience | Operate & Read |
| :--- | :--- | :--- |
| Primary goal | Convince, delight, create desire | Complete a task with low cognitive load |
| Examples | Landing page, portfolio, launch, campaign | Admin console, settings, checkout, data table |
| Typography | Expressive display face, large scale contrast | Legible UI face, compact scale, tabular numbers |
| Layout | Asymmetry, editorial rhythm, one strong focal point | Predictable grid, dense but aligned, one primary action |
| Motion | Orchestrated entry, deliberate reveal | Functional feedback only, under 200ms |
| Density | Low, generous whitespace | High, progressive disclosure |
| Navigation | Story anchors and a single CTA | Persistent navigation, breadcrumbs, filters |
| Failure mode | Style hides the action or slows reading | A brand hero competes with the task |

If a screen needs both, split it. A marketing hero above a dense dashboard is two surfaces, not one.

## 2. Information Architecture Rules

1. **One primary decision per screen.** Name it in one sentence. If two decisions compete, split the screen.
2. **One focal point.** The most important metric or action must be unmistakable within two seconds.
3. **Three to five chunks.** Limit the first view to 3-5 progressive disclosure groups. More groups raise scanning cost.
4. **Hick's Law.** Each additional equal-weight choice increases decision time. Group or hide secondary choices.
5. **Jakob's Law.** Users expect familiar placement. Do not relocate navigation, search, or primary actions without a strong reason.
6. **Progressive disclosure.** Show the decision first, details on demand. Use explicit expand controls, not hidden hover-only content.
7. **Recovery path.** Every primary flow needs a cancel, back, undo, or retry path.
8. **Scope boundary.** Record what the screen intentionally does not do. Unowned edge cases become future defects.

## 3. The 8-State Matrix

Define every state before implementation. Each state needs realistic example data and an acceptance check.

| State | Purpose | Required UI behavior | Anti-pattern |
| :--- | :--- | :--- | :--- |
| Ideal | Prove the normal case | Complete layout with real domain data | Lorem Ipsum, John Doe, fake numbers |
| Empty | Explain absence and offer the next step | One sentence of cause plus a primary action | Blank panel, disabled everything, no guidance |
| Loading | Preserve trust during a wait | Skeleton that matches final geometry, or inline spinner; announce with `aria-live` | Whole-screen dim that looks disabled; layout jump |
| Partial | Show value before everything arrives | Render available rows or modules, label the pending part | Hide all data until the slowest request finishes |
| Error / Validation | Explain cause and recovery | Inline field message, specific cause, exact fix, preserved input | Red border alone, generic toast, cleared form |
| Disabled / Read-Only | Explain why unavailable | Visible control with helper text or tooltip describing the condition to enable it | Silent grey control, no reason, no path forward |
| Text Overflow / i18n | Survive longer content | Wrap, truncate with disclosure, `+n` chips, long URL handling | Clip, overlap, horizontal page scroll |
| Keyboard / Screen Reader | Equal access without a mouse | Logical tab order, visible focus, Escape closes, focus returns to the trigger, `aria-live` for async updates | Mouse-only controls, focus lost after modal close, unlabeled inputs |

## 4. Product Brief Template

Save as `docs/designs/YYYY-MM-DD_product-brief_<topic>.md`.

```markdown
# Product Brief: <Surface Name>

- Date: YYYY-MM-DD
- Owner: <name>
- Status: Draft | Approved
- Source spec: <path or link>

## Audience and Job

- Primary user:
- Job to be done:
- Current workaround:

## Surface Mode

- Mode: Persuade & Experience | Operate & Read
- Reason:
- Split surfaces, if any:

## Primary Flow

1. Entry:
2. Primary action:
3. Completion signal:
4. Recovery path:

## Information Architecture

- Focal point:
- First-view chunks (3-5):
- Out of scope:

## 8-State Contract

| State | Example data | UI behavior | Acceptance check |
| :--- | :--- | :--- | :--- |
| Ideal | | | |
| Empty | | | |
| Loading | | | |
| Partial | | | |
| Error / Validation | | | |
| Disabled / Read-Only | | | |
| Text Overflow / i18n | | | |
| Keyboard / Screen Reader | | | |

## Success Metrics

- Metric:
- Event or signal:
- Target:
```

## 5. Anti-Patterns

- Coding before the Surface Mode is fixed.
- Treating the happy path as the whole screen.
- Using placeholder names or numbers in a brief that reviewers will treat as real.
- Loading states that remove layout geometry or look disabled.
- Error states that say "Something went wrong" without a cause or fix.
- Disabled controls with no explanation.
- Hover-only disclosure that keyboard users cannot reach.
- Mixing a persuasive hero with an operational task on one screen.

## 6. Gate Checklist

- [ ] Surface Mode recorded with a reason.
- [ ] One focal point per screen.
- [ ] Primary flow includes completion and recovery.
- [ ] All eight states have example data and acceptance checks.
- [ ] Out-of-scope items are explicit.
- [ ] Success metrics name an event or signal.
- [ ] The brief path uses `docs/designs/YYYY-MM-DD_product-brief_<topic>.md`.
