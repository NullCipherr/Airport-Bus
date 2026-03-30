# Metrics Automation

## Official script

- File: `scripts/run_tests.sh`
- Report: `docs/reports/latest_test_report.md`
- Raw log: `docs/reports/latest_test_report.raw.log`

## Measured stages

- `mix test` (backend)
- `MIX_ENV=prod mix compile` (backend)
- `npm run build` (frontend)

## Reading the report

The output table includes:

- stage name;
- status (`ok`, `fail`, `skipped`);
- duration in milliseconds.

## Good practices

- use `SKIP_FRONTEND=1` only for backend-only cycles;
- attach report snapshots to PRs with API/domain changes;
- investigate consistent duration growth across runs.
