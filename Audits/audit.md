# Audit: swift-random

## Legacy — Consolidated 2026-04-08

### From: swift-institute/Research/platform-compliance-audit.md (2026-03-19)

**Skill**: platform — [PLAT-ARCH-001-010], [PATTERN-001], [PATTERN-004a], [PATTERN-005]

| # | Severity | Rule | Location | Finding | Status |
|---|----------|------|----------|---------|--------|
| H-40 | HIGH | [PLAT-ARCH-008] | Exports.swift:6-12 | Conditionally re-exports `Darwin_Kernel`, `Linux_Kernel`, `Windows_Kernel` — duplicates the swift-kernel unification pattern. Fix: Replace with `@_exported public import Kernel`. | OPEN — Phase 1 quick win |
