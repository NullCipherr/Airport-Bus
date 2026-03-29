#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${ROOT_DIR}/docs/reports"
REPORT_FILE="${REPORT_DIR}/latest_test_report.md"
RAW_LOG_FILE="${REPORT_DIR}/latest_test_report.raw.log"

mkdir -p "${REPORT_DIR}"
: > "${RAW_LOG_FILE}"

TIMEZONE="${TZ:-America/Sao_Paulo}"
RUN_AT="$(TZ="${TIMEZONE}" date --iso-8601=seconds)"
RUN_DATE="$(TZ="${TIMEZONE}" date +%F)"

HAS_FAILURE=0
ROWS=()

wait_for_postgres() {
  if ! command -v pg_isready >/dev/null 2>&1; then
    return 0
  fi

  local attempts=15

  while [ "${attempts}" -gt 0 ]; do
    if pg_isready -h localhost -p 5432 -U postgres >/dev/null 2>&1; then
      return 0
    fi
    attempts="$((attempts - 1))"
    sleep 1
  done

  return 1
}

run_step() {
  local label="$1"
  local cmd="$2"

  local start end duration status
  start="$(date +%s%3N)"

  {
    echo "============================================================"
    echo "[${label}]"
    echo "CMD: ${cmd}"
    echo "START: $(date --iso-8601=seconds)"
  } >> "${RAW_LOG_FILE}"

  if bash -lc "${cmd}" >> "${RAW_LOG_FILE}" 2>&1; then
    status="ok"
  else
    status="fail"
    HAS_FAILURE=1
  fi

  end="$(date +%s%3N)"
  duration="$((end - start))"

  {
    echo "END: $(date --iso-8601=seconds)"
    echo "STATUS: ${status}"
    echo
  } >> "${RAW_LOG_FILE}"

  ROWS+=("| ${label} | ${status} | ${duration} ms |")
}

if ! wait_for_postgres; then
  ROWS+=("| Testes backend (mix test) | fail | 0 ms |")
  HAS_FAILURE=1
  {
    echo "============================================================"
    echo "[Testes backend (mix test)]"
    echo "STATUS: fail"
    echo "ERRO: PostgreSQL indisponível em localhost:5432."
    echo
  } >> "${RAW_LOG_FILE}"
else
  run_step "Testes backend (mix test)" "cd '${ROOT_DIR}/backend' && mix deps.get && MIX_ENV=test mix test"
fi

run_step "Build backend produção (mix compile)" "cd '${ROOT_DIR}/backend' && SECRET_KEY_BASE=local_dev_secret DATABASE_URL=ecto://postgres:postgres@localhost/aerosync_ops_dev MIX_ENV=prod mix compile"

if [ "${SKIP_FRONTEND:-0}" = "1" ]; then
  ROWS+=("| Build frontend (npm run build) | skipped | 0 ms |")
else
  run_step "Build frontend (npm run build)" "cd '${ROOT_DIR}/frontend' && npm ci && npm run build"
fi

{
  echo "# Resultado de Testes Automatizados"
  echo
  echo "- Data: \`${RUN_DATE}\` (${TIMEZONE})"
  echo "- Execução: \`${RUN_AT}\`"
  echo "- Script: \`./scripts/run_tests.sh\`"
  echo "- Log bruto: \`docs/reports/latest_test_report.raw.log\`"
  echo
  echo "| Etapa | Status | Duração |"
  echo "| --- | --- | ---: |"
  for row in "${ROWS[@]}"; do
    echo "${row}"
  done
  echo

  if [ "${HAS_FAILURE}" -eq 0 ]; then
    echo "Resultado final: **sucesso**."
  else
    echo "Resultado final: **falha** (consulte o log bruto)."
  fi
} > "${REPORT_FILE}"

cat "${REPORT_FILE}"

exit "${HAS_FAILURE}"
