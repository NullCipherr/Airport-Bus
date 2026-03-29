# API

## Base URL

- Desenvolvimento local: `http://localhost:4000/api`
- Docker Compose: `http://localhost:4000/api`

## Autenticação

### `POST /auth/login`

Realiza autenticação e retorna token JWT-like (Phoenix signed token).

Request:

```json
{
  "email": "supervisor@aerosync.local",
  "password": "AeroSync123!"
}
```

Response `200`:

```json
{
  "token": "<token>",
  "user": {
    "id": "uuid",
    "name": "Mariana Souza",
    "role": "supervisor",
    "email": "supervisor@aerosync.local"
  }
}
```

## Endpoints autenticados

Enviar header:

```text
Authorization: Bearer <token>
```

### Saúde e dashboard

- `GET /health`
- `GET /dashboard/overview`
- `GET /dashboard/events`

### Operação de voos

- `GET /flights`
- `GET /flights/:id`
- `POST /flights`
- `PUT /flights/:id`
- `DELETE /flights/:id`
- `POST /flights/:id/simulate-delay`

### Recursos operacionais

- `GET/POST/PUT/DELETE /employees`
- `GET/POST/PUT/DELETE /teams`
- `GET/POST/PUT/DELETE /gates`
- `GET/POST/PUT/DELETE /belts`
- `GET/POST/PUT/DELETE /schedules`
- `GET /alerts`

### Operações de carga e realtime

- `POST /operations/simulate-reallocation`
- `POST /operations/massive-seed`
- `GET /operations/massive-seed/status`
- `POST /operations/realtime-storm/start`
- `POST /operations/realtime-storm/stop`
- `GET /operations/realtime-storm/status`

## Códigos de resposta comuns

- `200`: operação concluída.
- `201`: recurso criado.
- `204`: recurso removido.
- `400`: payload inválido.
- `401`: não autorizado.
- `422`: erro de validação de dados.
