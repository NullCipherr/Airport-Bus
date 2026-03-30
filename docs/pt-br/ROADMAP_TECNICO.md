# Roadmap Técnico

## Curto prazo

- ampliar testes de controllers CRUD (flights, teams, schedules);
- adicionar testes de regras críticas do orquestrador;
- criar suíte de contratos de payload para endpoints mais usados.

## Médio prazo

- introduzir instrumentação de Telemetry com métricas exportáveis;
- separar autenticação para estratégia com expiração/refresh quando necessário;
- criar estratégia de paginação padronizada em endpoints de listagem.

## Longo prazo

- trilha de escalabilidade para múltiplos tópicos de channel por domínio;
- hardening para cenários de grande volume (massive seed + tempestade realtime simultânea);
- pipeline CI com execução automática de `scripts/run_tests.sh` e publicação de artefatos.
