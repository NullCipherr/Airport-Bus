# Métricas da Automação Shell

## Script oficial

- Arquivo: `scripts/run_tests.sh`
- Relatório: `docs/reports/latest_test_report.md`
- Log bruto: `docs/reports/latest_test_report.raw.log`

## Etapas medidas

- `mix test` (backend)
- `MIX_ENV=prod mix compile` (backend)
- `npm run build` (frontend)

## Como ler o relatório

A tabela apresenta:

- nome da etapa;
- status (`ok`, `fail` ou `skipped`);
- duração em milissegundos.

## Boas práticas

- manter `SKIP_FRONTEND=1` apenas para ciclos backend-only;
- anexar o relatório em PRs com mudança de domínio/API;
- investigar regressão de tempo quando etapa crescer de forma consistente em execuções consecutivas.
