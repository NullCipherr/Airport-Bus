# Observability

## Current observability model

Airport Bus currently relies on:

- Phoenix application logs;
- persisted `event_logs` in PostgreSQL;
- realtime events on `ops:lobby`.

## Practical monitoring guidance

- inspect `event_logs` when reconstructing incidents;
- monitor delayed flights and open alerts from dashboard data;
- validate UI latency between simulation trigger and frontend update.

## Practical benchmark approach

Stress actions currently available:

- `POST /api/operations/massive-seed`
- `POST /api/operations/realtime-storm/start`

Suggested execution:

1. run massive seed with incremental load levels;
2. observe API and frontend behavior in parallel;
3. register findings in a technical capacity report.

## Suggested improvements

- structured telemetry instrumentation with exporter;
- historical metrics panel (event rate/min, p95 latency on critical endpoints);
- alerts for realtime throughput degradation.
