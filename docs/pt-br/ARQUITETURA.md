# Arquitetura

## Visão macro

O Airport Bus é uma plataforma operacional com:

- backend em Phoenix API + Channels;
- frontend SPA em Vue 3;
- persistência em PostgreSQL;
- comunicação em tempo real via `ops:lobby`.

## Contextos principais (backend)

- `AeroSyncOps.Accounts`: autenticação, usuários e validação de token.
- `AeroSyncOps.Ops`: domínio operacional (voos, equipes, escalas, alertas e simulações).
- `AeroSyncOpsWeb`: camada HTTP, plugs de autenticação, controllers e channels.

## Fluxo de autenticação

1. Frontend envia credenciais para `POST /api/auth/login`.
2. Backend valida usuário/senha em `Accounts.authenticate/2`.
3. API devolve token assinado com `Phoenix.Token`.
4. Requisições privadas enviam `Authorization: Bearer <token>`.
5. `RequireAuth` valida token e injeta `current_user` no `conn`.

## Fluxo de eventos em tempo real

1. Regra de negócio gera alteração (ex.: atraso de voo).
2. `Ops.EventDispatcher` publica no tópico `ops:lobby`.
3. Frontend inscrito no channel recebe evento e atualiza tela sem refresh.

## Estrutura de diretórios

```text
Airport-Bus/
├── backend/
│   ├── config/
│   ├── lib/
│   │   ├── aero_sync_ops/
│   │   └── aero_sync_ops_web/
│   ├── priv/repo/
│   └── test/
├── frontend/
│   └── src/
├── scripts/
└── docs/
```

## Decisões arquiteturais

- API stateless com token assinado: simplicidade operacional para ambiente interno.
- Contexto `Ops` centralizado: evita lógica de domínio espalhada por controllers.
- Eventos por channel único (`ops:lobby`): reduz complexidade inicial de roteamento realtime.
- Separação backend/frontend por pasta: deploy desacoplado e evolução independente.
