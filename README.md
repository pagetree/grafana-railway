# Grafana for Railway

One-click Grafana deploy. **Prometheus auto-wired via env var.** No config files. No GitHub forks.

[![Deploy on Railway]([![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/prometheus-grafana))

---

## What this does

Runs `grafana/grafana` with Prometheus **automatically provisioned as the default datasource** if you set `PROMETHEUS_URL`. Works standalone too — just add data sources manually after deploy.

---

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PROMETHEUS_URL` | _(empty)_ | Auto-wires Prometheus as default datasource on boot |
| `GF_SECURITY_ADMIN_USER` | `admin` | Grafana admin username |
| `GF_SECURITY_ADMIN_PASSWORD` | `admin` | **Change this!** Grafana admin password |
| `PORT` | `3000` | Port (Railway sets this automatically) |

---

## Quick start with Prometheus

1. Deploy this template
2. Also deploy the companion [Prometheus Railway template](https://github.com/YOUR_ORG/prometheus-railway)
3. Set `PROMETHEUS_URL` to:
   ```
   http://prometheus.railway.internal:9090
   ```
4. Redeploy — Prometheus appears as the default data source, ready to query

---

## Volumes

Grafana data (dashboards, users, SQLite DB) is stored at `/var/lib/grafana`. Mount a Railway volume there to persist everything across deploys.

---

## Pairing both templates together

Deploy order:
1. **Prometheus** — note its Railway internal hostname
2. **Grafana** — set `PROMETHEUS_URL=http://prometheus.railway.internal:9090`

Open Grafana → Explore → select Prometheus → run `up` — you should immediately see your Prometheus instance healthy.
