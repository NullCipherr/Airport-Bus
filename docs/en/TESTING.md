# Testing

## Current scope

Automated coverage includes:

- authentication in `AeroSyncOps.Accounts`;
- HTTP login (`POST /api/auth/login`);
- protected route and health endpoint (`GET /api/health`).

Main test files:

- `backend/test/aero_sync_ops/accounts_test.exs`
- `backend/test/aero_sync_ops_web/controllers/auth_controller_test.exs`
- `backend/test/aero_sync_ops_web/controllers/health_controller_test.exs`

## Test infrastructure

- `backend/test/test_helper.exs`: ExUnit bootstrap.
- `backend/test/support/data_case.ex`: DB sandbox and helpers.
- `backend/test/support/conn_case.ex`: HTTP test helpers with `Phoenix.ConnTest`.
- `backend/test/support/fixtures.ex`: test user fixture.

## Running tests

Backend only:

```bash
cd backend
mix test
```

Integrated validation (backend + build checks + report):

```bash
./scripts/run_tests.sh
```

Backend-only integrated mode:

```bash
SKIP_FRONTEND=1 ./scripts/run_tests.sh
```

## Merge minimum criteria

- backend tests green;
- production backend compile green;
- frontend build green when not skipped;
- updated report in `docs/reports/latest_test_report.md`.
