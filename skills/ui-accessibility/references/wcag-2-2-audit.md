# WCAG 2.2 AA Audit

Reference for `ui-accessibility`. It defines the audit criteria, keyboard and focus model, ARIA failure patterns, optional runtime commands, and the report template.

## 1. Conformance Target

Target WCAG 2.2 Level AA for product UI. Level AAA is optional and must be named explicitly. Record the tested revision, routes, themes, and viewports.

A conformance claim is valid only for the scope actually tested. State untested routes and states.

## 2. Checklist

### Perceivable

| Criterion | Check | Pass condition |
| :--- | :--- | :--- |
| 1.1.1 Non-text content | Images, icons, charts | Meaningful alt text or empty alt for decoration; complex charts have a text alternative |
| 1.3.1 Info and relationships | Headings, lists, tables, forms | Structure is programmatic, not only visual |
| 1.4.1 Use of color | Status, errors, required fields | Color is not the only signal |
| 1.4.3 Contrast (minimum) | Text | 4.5:1 normal, 3.0:1 large |
| 1.4.11 Non-text contrast | Borders, focus, controls | 3.0:1 against adjacent colors |
| 1.4.4 Resize text | 200% zoom | No loss of content or function |
| 1.4.10 Reflow | 320px width | No horizontal page scroll |

### Operable

| Criterion | Check | Pass condition |
| :--- | :--- | :--- |
| 2.1.1 Keyboard | All functionality | Reachable and operable without a mouse |
| 2.1.2 No keyboard trap | Dialogs, widgets | Focus can leave every component |
| 2.4.3 Focus order | Tab sequence | Logical and matches visual order |
| 2.4.7 Focus visible | All controls | Visible focus indicator |
| 2.4.11 Focus not obscured | Sticky headers, overlays | Focused control is not hidden |
| 2.5.8 Target size | Touch and pointer targets | At least 24x24px |
| 2.2.1 Timing | Timeouts | Adjustable or extendable where required |

### Understandable

| Criterion | Check | Pass condition |
| :--- | :--- | :--- |
| 3.1.1 Language | Page language | `lang` attribute is correct |
| 3.2.1 On focus | Focus changes | Focus does not trigger unexpected context change |
| 3.2.2 On input | Input changes | Input does not unexpectedly submit or navigate |
| 3.3.1 Error identification | Forms | Error is identified in text and associated with the field |
| 3.3.2 Labels or instructions | Forms | Every input has a label and required instructions |
| 3.3.3 Error suggestion | Forms | The fix is stated when known |

### Robust

| Criterion | Check | Pass condition |
| :--- | :--- | :--- |
| 4.1.2 Name, role, value | Custom widgets | Accessible name, role, state, and value are exposed |
| 4.1.3 Status messages | Async updates | Announced via `aria-live` or `role="status"` without moving focus |

## 3. Keyboard and Focus Model

1. Tab moves forward; Shift+Tab moves backward.
2. Focus order follows the visual reading order.
3. Every focusable element has a visible `:focus-visible` style.
4. The first focusable element in a dialog receives focus when it opens.
5. Escape closes a dialog or menu and returns focus to the trigger.
6. A dialog traps focus while open and releases it on close.
7. Disabled controls are not focusable unless they explain why they are disabled.
8. Custom widgets implement the expected arrow-key behavior for their role.
9. Skip links are available for long navigation.
10. Focus is never moved on page load without a user action.

## 4. ARIA Patterns and Common Failures

### Use native elements first

| Need | Native solution | Avoid |
| :--- | :--- | :--- |
| Action | `button` | `div` with `role="button"` |
| Navigation | `a href` | `span` with a click handler |
| Text input | `input` with `label` | `div contenteditable` without a role |
| Dialog | `dialog` element | Custom div with incomplete focus handling |
| Disclosure | `details` and `summary` | Div with `aria-expanded` and no keyboard support |

### Common failures

- `role="button"` without `tabindex`, Enter, and Space handling.
- `aria-label` on a non-interactive element.
- `aria-hidden="true"` on a focusable element.
- Missing `aria-expanded` state on a disclosure.
- A modal without focus trap or focus return.
- An error toast with no `aria-live` and no field association.
- An icon-only button with no accessible name.
- A custom select that ignores arrow keys.
- `aria-labelledby` pointing to a missing or duplicate ID.
- Positive `tabindex` values that break natural order.

## 5. Optional Runtime Commands

Use only if the project already has the tools. Do not install dependencies without approval.

```bash
# Playwright end-to-end checks, if configured
npx playwright test

# axe-core scan, if available
npx axe <url>

# Static HTML checks with axe CLI, if installed
npx @axe-core/cli <url>
```

In the browser console, for reflow:

```js
document.documentElement.scrollWidth > window.innerWidth
```

If the tools are absent, state that the runtime check was not executed. Do not imply a browser audit occurred.

## 6. Severity

| Severity | Definition | Release effect |
| :--- | :--- | :--- |
| Critical | A core task is impossible for keyboard or screen-reader users, or content is unreadable | Block release |
| Important | A significant barrier or a WCAG AA failure with a workaround | Fix before release or record an accepted risk |
| Suggestion | Better semantics or usability with no conformance failure | Schedule |
| Nit | Minor polish | Optional |

## 7. Audit Report Template

Save as `docs/reports/YYYY-MM-DD_a11y-audit_<topic>.md`.

```markdown
# Accessibility Audit: <Topic>

- Date: YYYY-MM-DD
- Revision: <commit>
- Scope: <routes, components, themes>
- Target: WCAG 2.2 AA
- Tools: <static only | Playwright | axe-core | manual>

## Summary

- Verdict: Pass | Fail
- Critical: <n>
- Important: <n>
- Suggestion: <n>
- Untested: <areas>

## Checklist

| Criterion | Result | Evidence |
| :--- | :--- | :--- |
| 1.4.3 Contrast | Pass / Fail / Not tested | <ratio or method> |
| 2.1.1 Keyboard | | |
| 2.4.7 Focus visible | | |
| 2.5.8 Target size | | |
| 3.3.1 Error identification | | |
| 4.1.3 Status messages | | |

## Findings

### <Issue Title>

- Severity: Critical | Important | Suggestion | Nit
- Location: `path#Lstart-Lend`
- User impact:
- Evidence:
- Smallest fix:
- Regression check:

## Accepted Risks

- <risk, owner, reason, expiry>

## Gate

- Verdict: Pass | Fail
- Blocking findings:
```

## 8. Gate Rules

- `Pass` requires zero Critical and zero Important findings, or an explicit accepted risk with an owner and expiry.
- `Fail` blocks delivery. The report must list the blocking findings.
- A `Not tested` criterion is not a pass. State it in the summary.
- Re-run the affected checks after a fix and record the new revision.
