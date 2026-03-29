# Observabilidade e Benchmark

## Observabilidade atual

A observabilidade do projeto está baseada em:

- logs de aplicação Phoenix;
- `event_logs` persistidos no banco;
- eventos em tempo real no channel `ops:lobby`.

## Boas práticas de leitura operacional

- acompanhar `event_logs` para análise de sequência de incidentes;
- monitorar métricas de volume de voos atrasados e alertas abertos no dashboard;
- validar latência de tela observando tempo entre trigger de simulação e atualização no frontend.

## Benchmark prático

O sistema possui ações para estresse funcional:

- `POST /api/operations/massive-seed` para popular massa alta;
- `POST /api/operations/realtime-storm/start` para tempestade de eventos.

Recomendação:

1. executar massive seed com volume progressivo;
2. acompanhar comportamento da API e frontend em paralelo;
3. registrar resultado em relatório técnico de capacidade.

## Próximos incrementos sugeridos

- instrumentação estruturada com Telemetry + exporter;
- painel com métricas históricas (taxa de eventos/min, p95 de endpoints críticos);
- alertas automáticos para queda de throughput realtime.
