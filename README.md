# Grafana for Railway

One-click Grafana deploy. Prometheus auto wired via env var. No config files. No GitHub forks.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/prometheus-grafana)

Full stack template: [Prometheus + Grafana](https://railway.com/deploy/prometheus-grafana)

---

## What this does

Runs `grafana/grafana` and automatically provisions Prometheus as the default datasource when `PROMETHEUS_URL` is set. Works standalone too. You can add datasources manually after deploy.

---

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `3000` | Keep this set to `3000` for stable public and private networking |
| `PROMETHEUS_URL` | _(empty)_ | Auto wires Prometheus as the default datasource on boot |
| `GF_SECURITY_ADMIN_USER` | `admin` | Grafana admin username |
| `GF_SECURITY_ADMIN_PASSWORD` | `admin` | Change this. Prefer a Railway generated secret |

Recommended `PROMETHEUS_URL` when both services are in the same project:

```
http://${{prometheus-railway.RAILWAY_PRIVATE_DOMAIN}}:${{prometheus-railway.PORT}}
```

That resolves to:

```
http://prometheus-railway.railway.internal:9090
```

---

## Quick start with Prometheus

1. Deploy the combined [Prometheus + Grafana](https://railway.com/deploy/prometheus-grafana) template, or add a Prometheus service beside this one in the same project
2. Keep Prometheus `PORT=9090` and Grafana `PORT=3000`
3. Set Grafana `PROMETHEUS_URL` with the reference variable above
4. Open Grafana, go to Explore, select Prometheus, run `up`

---

## Volumes

Grafana data (dashboards, users, SQLite DB) lives at `/var/lib/grafana`. Attach a Railway volume at that path. Do not use a Dockerfile `VOLUME` instruction. Railway rejects those.

---

## Health check

Railway health check path: `/api/health`

---

## Pairing both services

1. Prometheus service name should match what you reference (`prometheus-railway` by default)
2. Pin `PORT=9090` on Prometheus
3. Pin `PORT=3000` on Grafana
4. Set `PROMETHEUS_URL=http://${{prometheus-railway.RAILWAY_PRIVATE_DOMAIN}}:${{prometheus-railway.PORT}}`

Open Grafana → Explore → Prometheus → query `up`. You should see the Prometheus instance healthy.
