---
name: ui-accessibility
description: >-
  Audit and specify WCAG 2.2 AA accessibility for product UI: semantic HTML,
  keyboard and focus models, ARIA, contrast, target size, and reduced motion.
  Use before shipping UI or when reviewing an interface. Not for visual styling
  or UX research.
risk: safe
source: local
date_added: "2026-10-28"
---

# UI Accessibility Skill

Verify that an interface works for keyboard, screen-reader, low-vision, and reduced-motion users. Report evidence and fixes; do not restyle the product.

## When to Use
- Before shipping a new screen, component, form, or interactive flow.
- When a review requests WCAG 2.2 AA conformance.
- When a design system changes contrast, focus, or motion tokens.
- When a bug report mentions keyboard traps, missing labels, or unreadable text.
- A shared, interactive, or print-ready HTML report.

## When Not to Use
- Visual hierarchy, typography, or token generation (`design-system`).
- Product flow, information architecture, or the 8-state contract (`ux-product-shaper`).
- Heuristic critique of a rendered screen (`ux-critic`).
- General code review without a UI surface (`code-review`).
- Chart form or palette selection (`data-visualization`); this skill audits the chart's accessible alternative and contrast.

## Artifact Path
- Audit report: `docs/reports/YYYY-MM-DD_a11y-audit_<topic>.md`.
- Session fallback: the host artifact directory with the same ISO date prefix.
- Never write an undated file at the repository root.

## Workflow

### Step 1: Static Audit
Inspect the source or rendered DOM without running a browser:
- Semantic elements: `button`, `a href`, `input`, `label`, `dialog`, `nav`, `main`.
- Every input has a programmatic label.
- Heading order does not skip levels.
- Images have an alt decision: meaningful alt or empty alt for decoration.
- Icon-only controls have an accessible name.
- Error text is associated with the field, not only a toast.
- Focus styles exist and are visible.
- Motion is guarded by `prefers-reduced-motion`.
- Touch targets are at least 24x24px.
- No color-only meaning for status, error, or required fields.

### Step 2: Optional Runtime Audit
Use these commands only when the project already has the tools. Do not install dependencies without approval.

```bash
# Optional: Playwright and axe-core, if present in the project
npx playwright test
npx axe <url>
```

Record:
- Contrast in default, hover, focus-visible, and active states.
- Keyboard order and focus visibility.
- Reflow at 320px width and 200% zoom.
- Horizontal overflow: `document.documentElement.scrollWidth > window.innerWidth`.
- Target size from `getBoundingClientRect()`.

If the tools are absent, state that the runtime check was not executed and rely on the manual checks below.

### Step 3: Manual Keyboard and Screen-Reader Checks
1. Tab forward and backward through every control. Focus must be visible and in a logical order.
2. Enter and Space activate buttons; Enter follows links.
3. Escape closes dialogs and menus; focus returns to the trigger.
4. A modal traps focus while open and releases it on close.
5. Async updates use `aria-live="polite"` or `role="status"`.
6. Form errors are announced and focus moves to the first invalid field.
7. Zoom to 200% and confirm no content is clipped or hidden.
8. Use a screen reader or the accessibility tree to confirm names, roles, and values.
9. Click or activate every rendered control. Fail any dead or hallucinated control that performs no authorized action.
10. Confirm reflow at 320px and 200% zoom with no horizontal page scroll.

### Step 4: Report Findings
Write the audit report with:
- Scope and revision.
- Checklist result per criterion.
- Findings ordered by severity.
- For each finding: `file:line`, user impact, evidence, smallest fix, and regression check.
- A final gate verdict: `Pass` or `Fail`.
- Any criterion not tested, with the reason.

### Step 5: Gate and Handoff
- A `Fail` verdict blocks UI delivery until the Critical and Important findings are fixed or explicitly accepted.
- Hand implementation fixes to the owning implementation skill or `python-pro`.
- Hand the merge gate to `code-review`.
- Use `verify-and-stop` for the decisive final check.

## WCAG 2.2 AA Checklist

| Area | Requirement | Evidence |
| :--- | :--- | :--- |
| Contrast | 4.5:1 body text; 3.0:1 large text and UI boundaries; all states | Measured ratios |
| Target size | At least 24x24px | Bounding boxes |
| Keyboard | All functionality reachable; no trap | Tab order and Escape test |
| Focus | Visible focus; focus not obscured | Focus screenshots |
| Forms | Labels, instructions, error identification, suggestions | DOM and screen-reader output |
| Use of color | Color is not the only signal | Text, icon, or pattern also present |
| Reflow | 320px and 200% zoom without loss | Viewport test |
| Motion | Reduced-motion preference respected | Media query and manual test |
| Names and roles | Accessible name for every control | Accessibility tree |
| Status messages | Announced without stealing focus | `aria-live` test |
| Charts | Table is the text alternative; marks are focusable with `aria-label`; data labels are `aria-hidden` | Accessibility tree and keyboard test |

The full audit procedure and report template are in `references/wcag-2-2-audit.md`.

## False Minimalism and YAGNI Boundary

Minimalism removes decoration, never access. Fail the audit when any of these are removed to make the interface look simpler:
- Clickability signifiers: fill contrast, border definition, cursor pointer, hover/active feedback.
- A visible `:focus-visible` ring in every theme.
- Labels, helper text, and error association.
- Empty, loading, error, disabled, and overflow states.
- A 24x24px minimum target.
- 4.5:1 body text and 3.0:1 UI boundary contrast in every state.

**Lazy, Not Negligent**: YAGNI never cuts WCAG 2.2 AA, the 8 states, validation, or target size.

## Rules
- Do not claim conformance from source inspection alone when behavior is interactive; state what was tested.
- Do not use an LLM guess for contrast. Compute or measure it.
- Do not accept ARIA attributes as proof of behavior. Test the keyboard path.
- Do not fix by adding `role` or `aria-label` when a native element already solves it.
- Do not change visual design without handing the change to `design-system`.
- Do not accept a minimal design that removes signifiers, labels, focus, or states.
- Do not treat `Not tested` as pass.
- No emoji severity markers. Use `Critical`, `Important`, `Suggestion`, `Nit`.

## Verification Checklist
- [ ] Every interactive control is keyboard reachable.
- [ ] Focus is visible and returns after dialogs.
- [ ] All text and UI boundaries meet the contrast targets in every state.
- [ ] Every input has a label and an associated error message.
- [ ] Target size is at least 24x24px.
- [ ] Reduced-motion preference is respected.
- [ ] Reflow works at 320px and 200% zoom.
- [ ] Clickability signifiers are visible without hover discovery.
- [ ] Focus ring is visible in both themes.
- [ ] No state is signaled by color alone.
- [ ] Chart marks are keyboard reachable, carry an `aria-label`, and the table provides the text alternative.
- [ ] Dead controls: 0; focus loop works.
- [ ] The minimalism change did not remove any accessibility invariant.
- [ ] The report names tested and untested criteria.
- [ ] The gate verdict is explicit.

## Related Skills
- Use **html-report** when the audited artifact is a single-file report; check contrast, keyboard path, `<details>` disclosure, table headers, and print layout.
- Use **design-system** for token changes that affect contrast, focus, or motion.
- Use **ux-critic** for heuristic and visual critique after accessibility passes.
- Use **data-visualization** for chart form and palette; audit the accessible alternative here.
- Use **code-review** for the merge gate and regression review.
- Use **verify-and-stop** for the decisive final check.
