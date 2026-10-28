# Token and Component Specifications

Reference for `design-system`. It defines the 3-tier token model, Zen Minimalism art style, naming rules, theme parity, component spec format, responsive rules, and the implementation handoff.

## 1. Three-Tier Token Model

| Tier | Purpose | Example names | Consumer |
| :--- | :--- | :--- | :--- |
| Primitive | Raw scale values | `--stone-50` to `--stone-950`, `--space-1` to `--space-12`, `--radius-sm`, `--duration-fast` | Never used directly by components |
| Semantic | Role-based meaning | `--bg-canvas`, `--bg-surface`, `--bg-subtle`, `--text-primary`, `--intent-danger`, `--border-subtle`, `--focus-ring` | Components and layouts |
| Component | Component-scoped bindings | `--button-bg-hover`, `--button-border-focus`, `--input-border-error` | One component family |

Rules:
- A component references semantic or component tokens only.
- A semantic token maps to a primitive token, never to a raw value in two places.
- A theme changes semantic mappings, not component names.
- Token names use lowercase kebab-case with a role prefix.

## 2. Zen Minimalism Art Style (Kanso, Ma, Shibumi)

- **Monochrome + 1 Accent (Warm Organic Surfaces)**: at least 90% of the viewport uses a warm neutral surface ramp tinted toward natural paper or stone (such as Shibumi parchment `#F7F4EE`, Karesansui gravel `#F4F1EA`, or Kinfolk warm paper `#FBF9F5` in light mode; Kyoto espresso `#141210` in dark mode). Reserve one earthy accent (`#9E583B` muted clay, `#4A6B53` Kyoto moss, or `#A65638` terracotta) for the primary CTA, numbered chapter index, and active focus ring. Reserve status colors for live system feedback, never decorative badges.
- **Ma (Whitespace over boxes)**: treat emptiness as an active design material. Use 3.5-5.25rem macro spacing between sections and 0.5-1rem micro spacing inside groups. Prefer a 1px hairline over a nested bordered card. Never place a bordered or shadowed card inside another.
- **Shibumi (Understated Typography & Prose Rhythm)**: use at most 2 primary font families (an editorial serif plus a UI sans) and one monospace data face. Use at most 5 size tokens for product UI or the 9 editorial roles below for reports. Hero KPI metrics may reach 2.5x-3x body; a page-title display may reach 3x+. Use display weights 300/350/400, body 400, UI 500, and emphasis 600; never 700. Keep left-aligned axes, 60ch-70ch measure, and `tabular-nums` on numeric data. Cap prose paragraphs at 2-3 sentences (`<= 60 words`) so copy reads with calm authority.
- **Kanso (Typography as the primary graphic)**: do not add decorative illustrations, gradient blobs, floating 3D shapes, glassmorphism, or icon tiles above headings.
- No unmotivated purple-to-blue gradient: avoid `#8b5cf6` to `#3b82f6` as a default hero.
- No neon cyberpunk glow on B2B, admin, or data surfaces.
- No pure `#000000` or `#808080` neutrals. Tint toward warm charcoal (`#22201E`) and stone (`#878079`).
- No emoji as a functional icon. Use an SVG icon with an accessible name.
- No centered body text in an operational screen (reserve centered chapter headers strictly for contemplative single-column views like `zen-garden`).
- No decorative animation without a reduced-motion guard.

## 3. Typography, Spacing, Radius, and Motion Scales

### Type scale

| Token | Size | Use |
| :--- | :--- | :--- |
| `--text-xs` | 0.75rem | Labels, captions, uppercase monospace eyebrows |
| `--text-sm` | 0.875rem | Secondary body, table cells |
| `--text-base` | 1rem | Body |
| `--text-lg` | 1.25rem | Section heading, lead paragraph |
| `--text-display` | 2.25rem+ | Page title, hero metric, chapter index |

Use at most 2 primary font families (an editorial serif plus a UI sans) and one monospace data face. Do not add a third display face. Use a consistent ratio per scale; reports may use optical sizing and clamps. Keep prose at 60ch-70ch, target 66ch. Apply `font-variant-numeric: tabular-nums` to metrics, prices, dates, and table numbers.

### Editorial report extension (9 roles)

Reports use these nine roles instead of the five product tokens. Component aliases may select a per-preset value.

| Role | Size | Use |
| :--- | :--- | :--- |
| `--text-xs` | 0.75rem | Eyebrows, labels, table headers, nav numbers |
| `--text-sm` | 0.875rem | Secondary body, table cells, section leads, code |
| `--text-base` | 0.95rem | Body prose |
| `--text-md` | 1.25rem | Summary/details, lead |
| `--text-lg` | 1.65rem | Section headings, thesis |
| `--text-xl` | 2rem | Zen/Chronicle section headings |
| `--text-2xl` | 2.5rem | KPI figures |
| `--text-3xl` | 2.85rem | Chapter indices |
| `--text-display` | `clamp(2.35rem, 4.2vw, 3.6rem)` | Page title; Zen/Chronicle override to `clamp(2.65rem, 4.8vw, 4.1rem)` |

Minimums: body prose `>= 0.9375rem`, labels `>= 0.75rem`, code and body monospace `>= 0.82rem`.

### Spacing scale

Use a 4px base: `0.25rem`, `0.5rem`, `0.75rem`, `1rem`, `1.5rem`, `2rem`, `3rem`, `4rem`, `5.25rem`. Macro whitespace must exceed micro whitespace.

### Radius and motion

| Token | Value | Use |
| :--- | :--- | :--- |
| `--radius-xs` | 0.375rem | `chronicle` cards |
| `--radius-sm` | 0.25rem | Inputs, chips, `zen-garden` cards |
| `--radius-md` | 0.5rem | `dossier` cards, buttons |
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

## 9. YAGNI Token and Prop Diet

- Emit at most 20-25 semantic tokens for a standalone app.
- No unused tokens or 10-step color ramps with no callers.
- Add component tokens only when a state transition cannot be expressed with semantic tokens.
- Native primitives first: `dialog`, `details`/`summary`, `input type="date"`, native `select` for 7 or fewer options, CSS Grid/Flex, and `@container` before custom JS or a UI library.
- Rule of Three: keep markup inline until the same visual and behavioral pattern repeats at least 3 times.
- Compound components over boolean props. More than three boolean mode props is a smell.

| Rationalization | Reality |
| :--- | :--- |
| Add a search bar, filter pills, and notification icon so the page looks complete. | Unrequested chrome is visual noise and maintenance debt. Do not render it. |
| Wrap each metric in a shadowed card with an icon badge. | Nested cards and decorative icons reduce the data-ink ratio. Use whitespace and type hierarchy. |
| Build a reusable component with 10 configuration props for future flexibility. | Premature abstraction violates the Rule of Three. Write concrete inline code until the pattern repeats. |
| Skip empty, error, and focus states to keep the code minimal. | Minimalism removes decoration, never usability scaffolding, state honesty, or accessibility. |

## 10. Static Minimalism Gate

- [ ] Every declared token has an active caller.
- [ ] No raw hex, rgb, or arbitrary pixel value outside the token files.
- [ ] No bordered or shadowed card inside another.
- [ ] No wrapper chain longer than three layout-neutral divs.
- [ ] Destructive actions use `--intent-danger`.
- [ ] At most one primary-filled CTA per view.
- [ ] At most three boolean mode props per component.
- [ ] At most 2 primary font families plus one monospace data face; 5 product sizes or 9 editorial report roles.
