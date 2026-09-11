---
name: deprecation-migration
description: >-
  Safely sunset or replace legacy APIs/systems (strangler, adapter, feature flags) without breaking consumers.
  Not for local dead-code cleanup or readability-only refactors. Language-agnostic.
risk: safe
source: local
date_added: "2026-08-23"
---

# Deprecation & Migration Skill

Plan and execute safe removal or replacement of systems, APIs, and legacy features.

## When to Use
- Replacing an old API, library, service, or feature
- Consolidating duplicate implementations
- Sunsetting unused or high-maintenance code
- Deciding whether to maintain or remove legacy paths

## When Not to Use
- Simple local dead-code cleanup with no consumers
- Pure readability refactors with no interface change
- No replacement exists and removal is not yet decided

## Decision Checklist
1. Does it still provide unique value?
2. Who depends on it, and how many consumers?
3. Is there a proven replacement?
4. What is migration cost vs ongoing maintenance cost?
5. Is deprecation advisory or compulsory?

## Core Rules
- Do not deprecate without a viable replacement path.
- Prefer advisory deprecation first; use compulsory only when risk/cost justifies it.
- Migrate incrementally; avoid big-bang cutovers when possible.
- Verify zero active usage before final removal.
- Removing code is a success only when consumers are safely moved.

## Migration Patterns
- **Strangler**: Route traffic/usage gradually from old to new.
- **Adapter / Shim**: Keep old interface temporarily, delegating internally to the new implementation.
- **Feature Flag**: Switch consumers selectively with instant rollback capability.

## Migration Process
1. **Build/Confirm Replacement**: Ensure the new path is fully tested, documented, and production-ready.
2. **Deprecation Notice**: Announce status, rationale, timeline, and concrete migration guide.
3. **Incremental Migration**: Move consumers in small, verifiable batches with automated tests.
4. **Monitor & Sunset**: Monitor metrics and logs until usage drops to zero.
5. **Final Cleanup**: Safely delete legacy code, tests, docs, and stale shims.

## Related Skills
- Use **tech-research** when choosing a replacement.
- Use **doubt-driven-development** for high-risk cutover.
- Verify with **python-testing** or crate tests (language-agnostic).

## Final Checklist
- [ ] Replacement covers critical use cases and has passing tests
- [ ] Consumers identified and migration path documented
- [ ] Incremental migration plan exists (strangler, adapter, or feature flag)
- [ ] Usage verified to be zero before final code deletion
- [ ] Old code, shims, tests, and references fully cleaned up
