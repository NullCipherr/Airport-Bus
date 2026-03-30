# Guia de Contribuição

## Escopo

Este projeto é privado. Contribuições são permitidas apenas para colaboradores autorizados.

## Fluxo recomendado

1. Crie branch a partir de `main` com prefixo de contexto (`feat/`, `fix/`, `docs/`, `refactor/`).
2. Mantenha commits pequenos, coesos e descritivos.
3. Atualize documentação sempre que houver mudança de API, arquitetura ou operação.
4. Execute `./scripts/run_tests.sh` antes de abrir PR.
5. Abra PR com descrição objetiva do problema, solução e impacto.

## Checklist mínimo para PR

- [ ] Mudança validada localmente.
- [ ] Sem segredos hardcoded em código ou configuração.
- [ ] Documentação atualizada quando aplicável.
- [ ] Relatório de testes atualizado em `docs/reports/latest_test_report.md`.

## Padrões técnicos

- Manter regras de domínio no contexto `AeroSyncOps.Ops`.
- Evitar lógica de negócio em controllers ou componentes visuais.
- Preservar contratos existentes de API, ou documentar quebra de compatibilidade.

## Revisão

Toda contribuição deve ser revisada por pelo menos 1 mantenedor antes de merge.
