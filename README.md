<div align="center">
  <img src="docs/assets/airport-bus-logo.svg" alt="Logo do Airport Bus" width="240" />
  <h1>Airport Bus</h1>
  <p><i>Plataforma de operação aeroportuária em tempo real com API Phoenix, eventos via Channels e console web em Vue 3</i></p>

  <p>
    <img src="https://img.shields.io/badge/Elixir-1.16+-4B275F?style=flat-square&logo=elixir&logoColor=white" alt="Elixir" />
    <img src="https://img.shields.io/badge/Phoenix-1.7-FF6F00?style=flat-square&logo=phoenixframework&logoColor=white" alt="Phoenix" />
    <img src="https://img.shields.io/badge/PostgreSQL-14+-336791?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL" />
    <img src="https://img.shields.io/badge/Vue-3-42B883?style=flat-square&logo=vue.js&logoColor=white" alt="Vue 3" />
    <img src="https://img.shields.io/badge/Vite-7-646CFF?style=flat-square&logo=vite&logoColor=white" alt="Vite" />
  </p>
</div>

---

## Documentação

A documentação técnica foi organizada em módulos para facilitar onboarding, operação e manutenção.
Inglês é a referência principal; traduções em português estão em `docs/pt-br/`.

- [Índice da documentação](docs/README.md)
- [Architecture](docs/en/ARCHITECTURE.md)
- [API](docs/en/API.md)
- [Operations](docs/en/OPERATIONS.md)
- [Observability](docs/en/OBSERVABILITY.md)
- [Testing](docs/en/TESTING.md)
- [Metrics Automation](docs/en/METRICS_AUTOMATION.md)
- [Roadmap](docs/en/ROADMAP.md)

---

## Preview

Interface web servida pelo frontend:

- Frontend local: `http://localhost:5173`
- API local: `http://localhost:4000/api`

---

## Overview

O **Airport Bus** é uma plataforma para centralizar operações aeroportuárias críticas com foco em tempo real.

O projeto prioriza:

- API stateless com autenticação por token assinado;
- regras de domínio centralizadas em contexto de negócio (`Ops`);
- atualização de telas por eventos em tempo real via Phoenix Channels;
- stack simples para rodar localmente, em Docker e evoluir com segurança.

---

## Features

- **Autenticação de operadores** via `POST /api/auth/login`.
- **Painel consolidado** com visão operacional (`GET /api/dashboard/overview`).
- **CRUD completo** para voos, equipes, colaboradores, gates, esteiras e escalas.
- **Eventos em tempo real** no tópico `ops:lobby` para atualização sem refresh.
- **Simulações operacionais** de atraso e realocação.
- **Carga massiva e tempestade de eventos** para testes de estresse funcional.
- **Automação de validação** com geração de relatório em `docs/reports/`.

---

## Arquitetura

Fluxo principal de requisição:

1. Frontend autentica em `POST /api/auth/login`.
2. Backend valida credenciais e emite token assinado (`Phoenix.Token`).
3. Rotas privadas passam pelo plug `RequireAuth`.
4. Controllers delegam regras para `AeroSyncOps.Ops`.
5. `AeroSyncOps.Ops.EventDispatcher` publica eventos no `ops:lobby`.
6. Frontend inscrito no channel recebe updates e sincroniza a interface.

---

## Resultado Oficial de Testes Automatizados

Referência local antes de publicação:

- Data: `2026-03-29` (America/Sao_Paulo)
- Execução: `2026-03-29T00:58:30-03:00`
- Script: `scripts/run_tests.sh`
- Artefatos:
  - `docs/reports/latest_test_report.md`
  - `docs/reports/latest_test_report.raw.log`

| Etapa | Status | Duração |
| --- | --- | ---: |
| Testes backend (`mix test`) | ok | 2731 ms |
| Build backend produção (`MIX_ENV=prod mix compile`) | ok | 28125 ms |
| Build frontend (`npm run build`) | ok | 2545 ms |

---

## Decisões Técnicas

- **Contexto de domínio único (`Ops`)**: reduz regra duplicada em controllers.
- **Phoenix Channels para realtime**: baixa complexidade inicial com bom ganho operacional.
- **Validação automatizada por shell**: execução simples, replicável e rastreável por relatório.
- **Separação backend/frontend**: deploy e manutenção desacoplados.

---

## Roadmap

Próximos passos recomendados para maturidade:

- aumentar cobertura de testes para CRUD e regras críticas;
- instrumentar Telemetry com exportador de métricas;
- evoluir observabilidade com histórico de throughput e latência;
- reforçar estratégia de escala para cenários de eventos simultâneos;
- formalizar pipeline CI com publicação de artefatos de teste.

---

## Stack Tecnológica

- **Backend**: Elixir `1.16+` + Phoenix `1.7+` + Ecto
- **Banco de dados**: PostgreSQL `14+`
- **Tempo real**: Phoenix Channels
- **Frontend**: Vue 3 + Pinia + Vue Router + Vite
- **Automação**: Shell script (`scripts/run_tests.sh`)
- **Containerização**: Docker + Docker Compose

---

## Estrutura do Projeto

```text
.
├── backend/
│   ├── config/
│   ├── lib/
│   ├── priv/repo/
│   └── test/
├── frontend/
│   ├── src/
│   ├── index.html
│   └── package.json
├── scripts/
│   └── run_tests.sh
├── docs/
│   ├── assets/
│   │   └── airport-bus-logo.svg
│   ├── en/
│   │   ├── API.md
│   │   ├── ARCHITECTURE.md
│   │   ├── METRICS_AUTOMATION.md
│   │   ├── OBSERVABILITY.md
│   │   ├── OPERATIONS.md
│   │   ├── ROADMAP.md
│   │   └── TESTING.md
│   ├── pt-br/
│   │   ├── API.md
│   │   ├── ARQUITETURA.md
│   │   ├── METRICAS_AUTOMACAO_SHELL.md
│   │   ├── OBSERVABILIDADE_E_BENCHMARK.md
│   │   ├── OPERACAO_DEPLOY_MANUTENCAO.md
│   │   ├── ROADMAP_TECNICO.md
│   │   └── TESTES_AUTOMATIZADOS.md
│   ├── reports/
│   │   ├── latest_test_report.md
│   │   └── latest_test_report.raw.log
│   └── README.md
├── docker-compose.yml
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── SECURITY.md
└── README.md
```

---

## Getting Started

### Pré-requisitos

- Elixir `>= 1.16`
- Erlang/OTP `>= 26`
- PostgreSQL `>= 14`
- Node `>= 20`
- Docker 24+ e Docker Compose v2 (opcional)

### Rodando manualmente

Backend:

```bash
cd backend
mix deps.get
mix ecto.setup
mix phx.server
```

Frontend:

```bash
cd frontend
npm install
npm run dev
```

### Endpoints principais

- `POST /api/auth/login`
- `GET /api/health` (autenticado)
- `GET /api/dashboard/overview`
- `GET /api/dashboard/events`
- `POST /api/flights/:id/simulate-delay`
- `POST /api/operations/simulate-reallocation`

---

## Docker Deployment

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

- Frontend: `http://localhost:5173`
- API: `http://localhost:4000/api`
- Postgres: `localhost:5432`

---

## Scripts Principais

- `./scripts/run_tests.sh`: roda validações e atualiza relatório técnico em `docs/reports/`.
- `SKIP_FRONTEND=1 ./scripts/run_tests.sh`: validação backend-only.
- `cd backend && mix test`: suíte de testes backend.
- `cd backend && MIX_ENV=prod mix compile`: valida build de produção backend.
- `cd frontend && npm run build`: valida build do frontend.
- `docker compose up --build`: sobe stack containerizada.

---

## Licença

Copyright (c) 2026 **Andrei Costa**.
Todos os direitos reservados.

Este projeto é **proprietário e confidencial**.
Não é permitida cópia, distribuição, modificação ou uso sem autorização prévia por escrito.

Veja o arquivo [LICENSE](LICENSE).

---

## Contribuição

Contribuições internas são bem-vindas seguindo o fluxo definido em [CONTRIBUTING.md](CONTRIBUTING.md).

Antes de contribuir, leia também:

- [Código de Conduta](CODE_OF_CONDUCT.md)
- [Política de Segurança](SECURITY.md)

<div align="center">
  Feito para operação em tempo real com foco em clareza técnica, confiabilidade e evolução incremental.
</div>
