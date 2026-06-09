#!/bin/bash
set -e

# ─────────────────────────────────────────────
# ENV VAR DEFAULTS
# ─────────────────────────────────────────────

# Grafana admin credentials
GF_SECURITY_ADMIN_USER="${GF_SECURITY_ADMIN_USER:-admin}"
GF_SECURITY_ADMIN_PASSWORD="${GF_SECURITY_ADMIN_PASSWORD:-admin}"

# Prometheus URL — set this to your Prometheus service
# On Railway private network: http://prometheus.railway.internal:9090
# Or a public URL works too
PROMETHEUS_URL="${PROMETHEUS_URL:-}"

PROVISIONING_DIR="/etc/grafana/provisioning"
DATASOURCES_DIR="${PROVISIONING_DIR}/datasources"

# ─────────────────────────────────────────────
# AUTO-PROVISION PROMETHEUS DATASOURCE
# ─────────────────────────────────────────────
mkdir -p "$DATASOURCES_DIR"

if [ -n "$PROMETHEUS_URL" ]; then
  cat > "${DATASOURCES_DIR}/prometheus.yml" <<EOF
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: ${PROMETHEUS_URL}
    isDefault: true
    editable: true
    jsonData:
      httpMethod: POST
      timeInterval: 15s
EOF
  echo "✓ Prometheus datasource provisioned → ${PROMETHEUS_URL}"
else
  echo "ℹ  PROMETHEUS_URL not set — add it in Railway Variables to auto-wire Prometheus"
  echo "   Example: PROMETHEUS_URL=http://prometheus.railway.internal:9090"
fi

echo "──────────────────────────────────────"
echo " Grafana starting"
echo " Admin user : ${GF_SECURITY_ADMIN_USER}"
echo " Port       : ${PORT:-3000}"
echo "──────────────────────────────────────"

# ─────────────────────────────────────────────
# EXPORT GRAFANA CONFIG ENV VARS
# ─────────────────────────────────────────────
export GF_SECURITY_ADMIN_USER
export GF_SECURITY_ADMIN_PASSWORD
export GF_SERVER_HTTP_PORT="${PORT:-3000}"
# Disable analytics/telemetry noise
export GF_ANALYTICS_REPORTING_ENABLED=false
export GF_ANALYTICS_CHECK_FOR_UPDATES=false

# ─────────────────────────────────────────────
# START GRAFANA
# ─────────────────────────────────────────────
exec /run.sh
