# Roadmap

## Short term

- increase CRUD controller coverage (flights, teams, schedules);
- add automated tests for critical orchestrator rules;
- add payload contract tests for most-used endpoints.

## Mid term

- introduce Telemetry instrumentation with exportable metrics;
- evolve authentication strategy for token expiration/refresh if needed;
- implement a consistent pagination strategy for listing endpoints.

## Long term

- design realtime scaling path with topic segmentation by domain;
- harden for high-volume scenarios (massive seed + realtime storm together);
- add CI pipeline to run `scripts/run_tests.sh` and publish test artifacts.
