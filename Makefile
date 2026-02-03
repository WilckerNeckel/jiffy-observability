# ======================================
# Observability Stack - Makefile
# ======================================

COMPOSE = docker compose --project-directory .
BASE    = -f compose/base.yml

# ---------- Scenarios ----------

.PHONY: backend observability full down ps logs

## Backend server (agent-only)
## Alloy + cAdvisor + Node Exporter
backend:
	$(COMPOSE) $(BASE) \
		-f compose/alloy-agent.yml \
		-f compose/cadvisor.yml \
		up -d

## Observability central server
## Prometheus + Loki + Grafana
observability:
	$(COMPOSE) $(BASE) \
		-f compose/prometheus.yml \
		-f compose/loki.yml \
		-f compose/otel-collector.yml \
		-f compose/grafana.yml \
		up -d

## Full stack (lab / debug only)
full:
	$(COMPOSE) $(BASE) \
		-f compose/alloy-agent.yml \
		-f compose/cadvisor.yml \
		-f compose/prometheus.yml \
		-f compose/loki.yml \
		-f compose/grafana.yml \
		up -d

# ---------- Utilities ----------

## Stop all services defined by the selected composes
down:
	$(COMPOSE) $(BASE) down

## Show running containers
ps:
	$(COMPOSE) $(BASE) ps

## Tail logs (usage: make logs SERVICE=grafana)
logs:
	$(COMPOSE) $(BASE) logs -f $(SERVICE)