# Token and Component Specifications

Reference for `design-system`. It defines the 3-tier token model, naming rules, theme parity, component spec format, responsive rules, and the implementation handoff.

## 1. Three-Tier Token Model

| Tier | Purpose | Example names | Consumer |
| :--- | :--- | :--- | :--- |
| Primitive | Raw scale values | `--slate-50` to `--slate-950`, `--space-1` to `--space-12`, `--radius-sm`, `--duration-fast` | Never used directly by components |
| Semantic | Role-based meaning | `--bg-canvas`, `--bg-surface`, `--text-primary`, `--intent-danger`, `--border-subtle`, `--focus-ring` | Components and layouts |
| Component | Component-scoped bindings | `--button-bg-hover`, `--button-border-focus`, `--input-border-error` | One component family |

Rules:
- A component references semantic or component tokens only.
- A semantic token maps to a primitive token, never to a raw value in two places.
- A theme changes semantic mappings, not component names.
- Token names use lowercase kebab-case with a role prefix.

## 2. Aesthetic Direction and Anti-Slop

- No unmotivated purple-to-blue gradient: avoid `#8b5cf6` to `#3b82f6` as a default hero.
- No neon cyberpunk glow on B2B, admin, or data surfaces.
- No pure `#000000` or `#808080` neutrals. Tint toward the brand hue.
- No Inter or Roboto as an unconsidered default. Choose a face that matches the Surface Mode.
- No nested bordered cards. Use whitespace, `--bg-subtle`, or a hairline divider.
- No emoji as a functional icon. Use an SVG icon with an accessible name.
- No centered body text in an operational screen.
- No decorative animation without a reduced-motion guard.

## 3. Typography, Spacing, Radius, and Motion Scales

### Type scale

| Token | Size | Use |
| :--- | :--- | :--- |
| `--text-xs` | 0.75rem | Labels, captions |
| `--text-sm` | 0.875rem | Secondary body, table cells |
| `--text-base` | 1rem | Body |
| `--text-lg` | 1.125rem | Lead paragraph |
| `--text-xl` | 1.25rem | Section heading |
| `--text-2xl` | 1.5rem | Page heading |
| `--text-3xl` | 1.875rem | Hero metric |
| `--text-display` | 2.5rem+ | Persuade surface only |

Use a modular ratio of 1.200 or 1.250. Keep prose at 60ch-75ch. Apply `font-variant-numeric: tabular-nums` to metrics, prices, dates, and table numbers.

### Spacing scale

Use a 4px base: `0.25rem`, `0.5rem`, `0.75rem`, `1rem`, `1.5rem`, `2rem`, `3rem`, `4rem`, `6rem`. Macro whitespace must exceed micro whitespace.

### Radius and motion

| Token | Value | Use |
| :--- | :--- | :--- |
| `--radius-sm` | 0.25rem | Inputs, chips |
| `--radius-md` | 0.5rem | Cards, buttons |
| `--radius-lg` | 0.75rem | Modals, large panels |
| `--duration-fast` | 100ms | Hover, focus |
| `--duration-base` | 180ms | Expand, collapse |
| `--duration-slow` | 260ms | Route or modal transition |

Wrap non-essential motion in `@media (prefers-reduced-motion: no-preference)`.

## 4. Theme Parity

| Check | Light target | Dark target |
| :--- | :--- | :--- |
| Body text on canvas | >= 4.5:1 | >= 4.5:1 |
| Secondary text on surface | >= 4.5:1 | >= 4.5:1 |
| Large text | >= 3.0:1 | >= 3.0:1 |
| Active UI boundary | >= 3.0:1 | >= 3.0:1 |
| Focus ring against adjacent surface | >= 3.0:1 | >= 3.0:1 |
| Disabled text | Still readable, clearly inactive | Still readable, clearly inactive |

Record the measured ratio next to each semantic pair. Do not claim parity without a measurement.

## 5. Component Specification Template

```markdown
# Component: <Name>

## Anatomy
- Root:
- Parts:
- Slots:

## Variants
| Variant | Use | Forbidden combination |
| :--- | :--- | :--- |
| primary | Main action | Never more than one per screen |
| secondary | Supporting action | Not for destructive work |
| danger | Destructive action | Requires confirmation |

## Props and Slots
| Name | Type | Required | Notes |
| :--- | :--- | :--- | :--- |

## States
| State | Visual | Behavior | Acceptance |
| :--- | :--- | :--- | :--- |
| default | | | |
| hover | | | |
| active | | | |
| focus-visible | | | |
| disabled | | | |
| loading | | | |
| error | | | |
| empty | | | |

## Usage
- Use when:
- Do not use when:
- Nearest alternative:

## Do / Do Not
- Do:
- Do not:

## Acceptance Criteria
- Visual:
- Behavioral:
- Accessibility:
```

Rules:
- Prefer semantic variants over boolean props. More than three boolean mode props is a smell.
- Each interactive component defines focus-visible, disabled, and loading where applicable.
- Each component states its accessible name and keyboard behavior.
- Each component references tokens, not raw values.

## 6. Responsive Layout Rules

| Concern | Rule |
| :--- | :--- |
| Macro layout | CSS Grid with `auto-fit` and `minmax()` |
| Local alignment | Flexbox |
| Reusable component | Container query with `container-type: inline-size` |
| Minimum width | 320px without horizontal page scroll |
| Maximum width | 1440px and above with a readable measure |
| Zoom | 200% without loss of content or function |
| Touch target | >= 24x24px, preferably 44x44px on mobile |
| Long text | `text-wrap: pretty`; headings use `text-wrap: balance` |
| Chip overflow | `+n` disclosure, not a clipped row |
| Tables | Horizontal scroll container, never page-level overflow |

## 7. Implementation Handoff

| Artifact | Destination |
| :--- | :--- |
| `tokens.css` / `tokens.json` | `html-report`, `plotly-dash`, `python-pro` |
| Component spec | The implementation skill and `code-review` |
| 8-state matrix | The implementation skill and `ui-accessibility` |
| Design system decisions | `docs/designs/YYYY-MM-DD_design-system_<topic>.md` |
| Legacy token retirement | `deprecation-migration` |

Handoff checklist:
- [ ] Token roles and values are final.
- [ ] Light and dark parity is measured.
- [ ] Component anatomy, variants, and states are complete.
- [ ] Responsive rules and touch targets are stated.
- [ ] The implementation skill is named.
- [ ] `ui-accessibility` and `ux-critic` are named as post-implementation gates.

## 8. Anti-Patterns

- Hardcoded hex or arbitrary pixel values in a component.
- A component consuming `--slate-700` instead of `--text-secondary`.
- Boolean prop explosion for visual modes.
- Nested cards with competing borders.
- A second token system created beside the first.
- Theme parity asserted from a screenshot without a ratio.
- A token rename with no migration path.
- A component spec without states or acceptance criteria.
