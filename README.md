<div align="center">
  <img src="docs/assets/airport-bus-logo.svg" alt="Logo do Airport Bus" width="260" />
  <h1>Airport Bus</h1>
  <p><i>Plataforma operacional aeroportuária em tempo real com API Phoenix, eventos via Channels e console Vue 3</i></p>

  <p>
    <img src="https://img.shields.io/badge/Elixir-1.16+-4B275F?style=for-the-badge&logo=elixir&logoColor=white" alt="Elixir" />
    <img src="https://img.shields.io/badge/Phoenix-1.7-FF6F00?style=for-the-badge&logo=phoenixframework&logoColor=white" alt="Phoenix" />
    <img src="https://img.shields.io/badge/PostgreSQL-14+-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
    <img src="https://img.shields.io/badge/Vue-3-42B883?style=for-the-badge&logo=vue.js&logoColor=white" alt="Vue 3" />
    <img src="https://img.shields.io/badge/Vite-7-646CFF?style=for-the-badge&logo=vite&logoColor=white" alt="Vite" />
  </p>
</div>

---

## Documentação Modular

A documentação foi organizada por domínio para facilitar onboarding e manutenção:

- [docs/README.md](docs/README.md)
- [docs/ARQUITETURA.md](docs/ARQUITETURA.md)
- [docs/API.md](docs/API.md)
- [docs/OPERACAO_DEPLOY_MANUTENCAO.md](docs/OPERACAO_DEPLOY_MANUTENCAO.md)
- [docs/OBSERVABILIDADE_E_BENCHMARK.md](docs/OBSERVABILIDADE_E_BENCHMARK.md)
- [docs/TESTES_AUTOMATIZADOS.md](docs/TESTES_AUTOMATIZADOS.md)
- [docs/METRICAS_AUTOMACAO_SHELL.md](docs/METRICAS_AUTOMACAO_SHELL.md)
- [docs/ROADMAP_TECNICO.md](docs/ROADMAP_TECNICO.md)

---

## Visão Geral

O **Airport Bus** centraliza operação aeroportuária com foco em atualização contínua e tomada de decisão rápida.

Principais objetivos:

- consolidar voos, equipes, recursos de gate/esteira e escalas em uma única plataforma;
- automatizar regras operacionais críticas (atraso, remanejamento, alertas);
- entregar monitoramento em tempo real para supervisão operacional.

---

## Principais Recursos

- **Autenticação de operadores** com token assinado (`POST /api/auth/login`).
- **Painel operacional** com visão agregada (`GET /api/dashboard/overview`).
- **CRUD operacional** para voos, equipes, funcionários, gates, esteiras e escalas.
- **Simulação de atraso e remanejamento** com propagação em tempo real.
- **Eventos operacionais** via Phoenix Channels (`ops:lobby`).
- **Carga massiva de dados** e tempestade de eventos para testes de estresse.

---

## Arquitetura

Fluxo principal:

1. Frontend Vue autentica via `POST /api/auth/login`.
2. Backend Phoenix valida usuário e emite token assinado.
3. Requisições autenticadas acessam APIs de operação.
4. Regras de domínio em `AeroSyncOps.Ops` geram alterações e eventos.
5. `AeroSyncOps.Ops.EventDispatcher` publica updates em `ops:lobby`.
6. Frontend recebe eventos e atualiza telas sem refresh.

---

## Resultado Oficial de Testes Automatizados

Resultado de referência da automação local antes de publicação:

- Data: `2026-03-29` (America/Sao_Paulo)
- Execução: `2026-03-29T00:58:30-03:00`
- Script: `./scripts/run_tests.sh`
- Artefatos:
  - `docs/reports/latest_test_report.md`
  - `docs/reports/latest_test_report.raw.log`

| Etapa | Status | Duração |
| --- | --- | ---: |
| Testes backend (`mix test`) | ok | 2731 ms |
| Build backend produção (`MIX_ENV=prod mix compile`) | ok | 28125 ms |
| Build frontend (`npm run build`) | ok | 2545 ms |

---

## Stack Tecnológica

- **Backend**: Elixir + Phoenix + Ecto
- **Banco**: PostgreSQL
- **Tempo real**: Phoenix Channels
- **Frontend**: Vue 3 + Pinia + Vue Router + Vite
- **Automação de validação**: shell script (`scripts/run_tests.sh`)

---

## Estrutura do Projeto

```text
.
├── docs/
│   ├── assets/
│   │   └── airport-bus-logo.svg
│   ├── reports/
│   │   ├── latest_test_report.md
│   │   └── latest_test_report.raw.log
│   ├── API.md
│   ├── ARQUITETURA.md
│   ├── METRICAS_AUTOMACAO_SHELL.md
│   ├── OBSERVABILIDADE_E_BENCHMARK.md
│   ├── OPERACAO_DEPLOY_MANUTENCAO.md
│   ├── README.md
│   ├── ROADMAP_TECNICO.md
│   └── TESTES_AUTOMATIZADOS.md
├── scripts/
│   └── run_tests.sh
├── backend/
│   ├── config/
│   ├── lib/
│   ├── priv/repo/
│   └── test/
├── frontend/
│   ├── src/
│   └── package.json
├── docker-compose.yml
└── README.md
```

---

## Como Rodar Localmente

### Pré-requisitos

- Elixir `>= 1.16`
- Erlang/OTP `>= 26`
- PostgreSQL `>= 14`
- Node `>= 20`

### Backend

```bash
cd backend
mix deps.get
mix ecto.setup
mix phx.server
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

---

## Deploy Local com Docker

### Build e subida

```bash
docker compose up --build
```

### Operação

```bash
docker compose logs -f
docker compose down
```

### Acesso

- API: `http://localhost:4000`
- Frontend: `http://localhost:5173`
- Health (autenticado): `GET /api/health`

---

## Scripts Principais

- `./scripts/run_tests.sh`: valida backend + build checks e gera relatório em `docs/reports`.
- `SKIP_FRONTEND=1 ./scripts/run_tests.sh`: validação backend-only.
- `cd backend && mix test`: executa suíte de testes backend.
- `cd backend && MIX_ENV=prod mix compile`: valida build de produção backend.
- `cd frontend && npm run build`: valida build do frontend.
- `docker compose up --build`: sobe stack local containerizada.

---

## Licença

Projeto open source sob licença **MIT**.

Consulte `LICENSE` quando o arquivo for incluído no repositório.
