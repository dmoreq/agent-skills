---
name: design-system
description: >-
  Build and maintain a 3-tier W3C DTCG design token system, dual light/dark themes,
  component specifications, and responsive layout rules. Use when bootstrapping a
  visual identity, creating or updating a design system, or handing design to code.
  Not for UX research, accessibility audits, or feature specs.
risk: safe
source: local
date_added: "2026-10-28"
---

# Design System Skill

Own the visual contract between product intent and implementation: tokens, components, states, responsive rules, and the handoff to code.

## When to Use
- Bootstrapping a visual identity for a new product or surface.
- Creating or updating a token system, theme, or component library.
- Retheming an application for light and dark modes.
- Writing component specs before implementation.
- Auditing hardcoded colors, spacing, or one-off variants.

## When Not to Use
- UX research, information architecture, or the 8-state product contract (`ux-product-shaper`).
- WCAG conformance audit and keyboard testing (`ui-accessibility`).
- Writing production UI code (`html-report`, `plotly-dash`, `python-pro`).
- Adversarial critique of a rendered screen (`ux-critic`).
- Feature scoping without a visual system (`spec-driven-design`).

## Artifact Paths
- Design system spec: `docs/designs/YYYY-MM-DD_design-system_<topic>.md`.
- Token export: `docs/designs/YYYY-MM-DD_tokens_<topic>.css` and `.json`.
- Session fallback: the host artifact directory with the same ISO date prefix.
- Never write an undated file at the repository root.

## Workflow

### Step 1: Set the Aesthetic Direction
1. Read the product brief from `ux-product-shaper`: Surface Mode, audience, and constraints.
2. Choose a defensible direction. Do not default to unmotivated purple-to-blue gradients, neon cyberpunk glows on B2B surfaces, or pure untinted `#000000` and `#808080` neutrals.
3. Tint neutrals slightly toward the brand hue with `oklch()` or `hsl()`.
4. Pair one expressive display face with a legible UI body face and a monospace face for code and metrics.
5. Enforce a modular type scale (1.200 or 1.250), a 60ch-75ch prose measure, and `font-variant-numeric: tabular-nums` on numeric data.

### Step 2: Build the Three-Tier Token System
The full token and component templates are in `references/token-and-component-specs.md`.

| Tier | Contains | Rule |
| :--- | :--- | :--- |
| Primitive | Raw color ramps, 4px spacing scale, radii, durations | Never consumed directly by components |
| Semantic | Surface, text, intent, border, focus roles | The only tier components may reference |
| Component | Explicit bindings for hover, active, focus-visible, disabled | Scoped to one component family |

Required semantic roles:
- Surfaces: `--bg-canvas`, `--bg-surface`, `--bg-elevated`, `--bg-overlay`.
- Text: `--text-primary`, `--text-secondary`, `--text-muted`, `--text-on-accent`.
- Intent: `--intent-primary`, `--intent-danger`, `--intent-warning`, `--intent-success`.
- Borders and focus: `--border-subtle`, `--border-strong`, `--focus-ring`.
- Destructive actions must use `--intent-danger`, never the primary accent.

### Step 3: Verify Theme Parity
- Body text contrast is at least 4.5:1 in both light and dark themes.
- Large text and active UI boundaries are at least 3.0:1.
- Hover, focus-visible, active, and disabled states keep readable contrast.
- The same semantic role resolves to the same meaning in both themes.
- Export `tokens.css` and `tokens.json` with identical role names.

### Step 4: Write Component Specifications
Every component spec contains:
- Anatomy: named parts and their nesting.
- Variants: semantic names, not boolean explosions. Prefer `variant="danger"` over `isDestructive`, `isCompact`, `hasFooter`.
- Props and slots: required, optional, and forbidden combinations.
- States: default, hover, active, focus-visible, disabled, loading, error, empty where applicable.
- Usage rules: when to use, when not to use, and the nearest alternative.
- Do and do not examples.
- Acceptance criteria: visual, behavioral, and accessibility checks.

Avoid nested card slop. Do not place bordered cards inside bordered cards; use whitespace, `--bg-subtle`, or hairline dividers.

### Step 5: Define Responsive Layout Rules
- Use CSS Grid with `auto-fit` and `minmax()` for macro layout; Flexbox for local alignment.
- Use container queries for reusable components; page-level media queries alone break narrow sidebars.
- Support 320px to 1440px and 200% browser zoom without horizontal page scroll.
- Keep touch targets at least 24x24px, preferably 44x44px on mobile.
- Use `text-wrap: balance` on headings and `text-wrap: pretty` on body text.
- Wrap motion in `@media (prefers-reduced-motion: no-preference)`.

### Step 6: Hand Off to Implementation
- Hand tokens and specs to `html-report` for a single-file HTML report, `plotly-dash` for a Dash application, or `python-pro` for a Python-served UI.
- Give the implementer the token files, component acceptance criteria, and the state matrix from `ux-product-shaper`.
- Hand the result to `ui-accessibility` for the WCAG audit and to `ux-critic` for heuristic critique.
- When retiring an old token or component, use `deprecation-migration` to keep consumers working during the transition.

## Rules
- No hardcoded hex, rgb, or arbitrary pixel values outside the token files.
- No component consumes a primitive token directly.
- No boolean-prop explosion: more than three boolean mode props is a design smell.
- No theme parity claim without measured contrast.
- No token rename without a migration path and a consumer audit.
- No production UI code in this skill; hand off to the implementation skill.

## Verification Checklist
- [ ] Aesthetic direction is recorded and justified.
- [ ] Three token tiers exist with semantic roles.
- [ ] Light and dark parity is measured, not assumed.
- [ ] Every component spec has anatomy, variants, states, and acceptance criteria.
- [ ] Responsive rules cover 320px, 1440px, and 200% zoom.
- [ ] Token export uses ISO-dated files under `docs/designs/`.
- [ ] Handoff names the implementation skill and the audit skills.

## Related Skills
- Use **ux-product-shaper** for the product brief, Surface Mode, and 8-state contract before tokens.
- Use **ui-accessibility** to audit contrast, focus, target size, and reduced motion.
- Use **html-report** to implement the system in a single-file HTML deliverable.
- Use **plotly-dash** to implement the system in a server-backed Dash application.
- Use **deprecation-migration** when retiring tokens or components with active consumers.
