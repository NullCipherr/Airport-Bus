# Testes Automatizados

## Escopo atual

A suíte automatizada cobre:

- autenticação em `AeroSyncOps.Accounts`;
- login HTTP (`POST /api/auth/login`);
- proteção de rota autenticada e health check (`GET /api/health`).

Arquivos de teste:

- `backend/test/aero_sync_ops/accounts_test.exs`
- `backend/test/aero_sync_ops_web/controllers/auth_controller_test.exs`
- `backend/test/aero_sync_ops_web/controllers/health_controller_test.exs`

## Infra de teste

- `backend/test/test_helper.exs`: inicialização do ExUnit.
- `backend/test/support/data_case.ex`: sandbox de banco e helpers.
- `backend/test/support/conn_case.ex`: helpers de teste HTTP com `Phoenix.ConnTest`.
- `backend/test/support/fixtures.ex`: criação de usuário para cenários de teste.

## Execução

No backend:

```bash
cd backend
mix test
```

Execução integrada (backend + build checks + relatório):

```bash
./scripts/run_tests.sh
```

Para cenário backend-only:

```bash
SKIP_FRONTEND=1 ./scripts/run_tests.sh
```

## Critérios mínimos para merge

- suíte backend sem falhas;
- build de produção do backend concluído;
- build do frontend concluído (quando não pulado);
- relatório atualizado em `docs/reports/latest_test_report.md`.
