#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_file="${1:-${project_dir}/databricks.env}"

if [[ ! -f "${config_file}" ]]; then
  echo "Configuration file not found: ${config_file}" >&2
  echo "Copy databricks.env.example to databricks.env and fill it in." >&2
  exit 1
fi

# This file is a local, user-maintained shell-style key/value file.
set -a
# shellcheck source=/dev/null
source "${config_file}"
set +a

: "${DATABRICKS_HOST:?Set DATABRICKS_HOST in ${config_file}}"
: "${DATABRICKS_HTTP_PATH:?Set DATABRICKS_HTTP_PATH in ${config_file}}"
: "${DATABRICKS_AZURE_CLIENT_ID:?Set DATABRICKS_AZURE_CLIENT_ID in ${config_file}}"
: "${DATABRICKS_AZURE_CLIENT_SECRET:?Set DATABRICKS_AZURE_CLIENT_SECRET in ${config_file}}"
: "${DATABRICKS_CATALOG:?Set DATABRICKS_CATALOG in ${config_file}}"

repo="egullbring/testdbt"
for secret_name in \
  DATABRICKS_HOST \
  DATABRICKS_HTTP_PATH \
  DATABRICKS_AZURE_CLIENT_ID \
  DATABRICKS_AZURE_CLIENT_SECRET; do
  printf '%s' "${!secret_name}" | gh secret set "${secret_name}" --repo "${repo}"
done

gh variable set DATABRICKS_CATALOG --body "${DATABRICKS_CATALOG}" --repo "${repo}"
echo "Databricks GitHub Actions settings updated for ${repo}."
