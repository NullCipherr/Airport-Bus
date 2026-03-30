# Architecture

## Macro view

Airport Bus is an operations platform composed of:

- Phoenix API backend + Channels;
- Vue 3 SPA frontend;
- PostgreSQL persistence;
- real-time communication through `ops:lobby`.

## Main backend contexts

- `AeroSyncOps.Accounts`: authentication, users, token validation.
- `AeroSyncOps.Ops`: operational domain (flights, teams, schedules, alerts, simulations).
- `AeroSyncOpsWeb`: HTTP layer, auth plug, controllers, channels.

## Authentication flow

1. Frontend sends credentials to `POST /api/auth/login`.
2. Backend validates user/password in `Accounts.authenticate/2`.
3. API returns a signed token using `Phoenix.Token`.
4. Private requests send `Authorization: Bearer <token>`.
5. `RequireAuth` validates token and injects `current_user` in the connection.

## Real-time flow

1. A domain rule changes state (for example a flight delay simulation).
2. `Ops.EventDispatcher` publishes events to `ops:lobby`.
3. Frontend subscribers receive updates without page reload.

## Directory structure

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

## Architectural decisions

- Stateless API with signed tokens for simpler operations.
- Domain logic centralized in `Ops` to keep controllers thin.
- Single realtime topic (`ops:lobby`) to keep v1 event routing straightforward.
- Backend/frontend split for independent deployment and maintenance.
