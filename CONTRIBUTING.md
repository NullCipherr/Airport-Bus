# Contributing Guide

## Scope

This is a private project. Contributions are allowed only for authorized collaborators.

## Recommended workflow

1. Create a branch from `main` with a context prefix (`feat/`, `fix/`, `docs/`, `refactor/`).
2. Keep commits small, cohesive, and descriptive.
3. Update documentation whenever API, architecture, or operations change.
4. Run `./scripts/run_tests.sh` before opening a PR.
5. Open a PR with a clear summary of problem, solution, and impact.

## Minimum PR checklist

- [ ] Change validated locally.
- [ ] No hardcoded secrets in code or configuration.
- [ ] Documentation updated when applicable.
- [ ] Test report updated in `docs/reports/latest_test_report.md`.

## Technical standards

- Keep domain rules in the `AeroSyncOps.Ops` context.
- Avoid business logic in controllers or purely visual components.
- Preserve existing API contracts, or document breaking changes.

## Review

Every contribution must be reviewed by at least one maintainer before merge.
