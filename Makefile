# ======================================
# Observability Stack - Makefile
# ======================================

COMPOSE = docker compose --project-directory .
BASE    = -f compose/base.yml

OBSERVABILITY_FILES = \
	-f compose/base.yml \
	-f compose/alloy-agent.yml \
	-f compose/cadvisor.yml \
	-f compose/otel-collector.yml \
	-f compose/prometheus.yml \
	-f compose/loki.yml \
	-f compose/grafana.yml

LOG_FILES_alloy        = -f compose/alloy-agent.yml
LOG_FILES_cadvisor     = -f compose/cadvisor.yml
LOG_FILES_otel         = -f compose/otel-collector.yml
LOG_FILES_prometheus   = -f compose/prometheus.yml
LOG_FILES_loki         = -f compose/loki.yml
LOG_FILES_grafana      = -f compose/grafana.yml

# ---------- Scenarios ----------

.PHONY: backend observability full down ps logs grafana prometheus loki cadvisor alloy otel down-all up-all log-alloy log-cadvisor log-otel log-prometheus log-loki log-grafana

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
up-all:
	docker compose --project-directory . $(OBSERVABILITY_FILES) up -d

# ---------- Utilities ----------

## Stop all services defined by the selected composes
down-all:
	docker compose --project-directory . $(OBSERVABILITY_FILES) down --remove-orphans

## Show running containers
ps:
	$(COMPOSE) $(OBSERVABILITY_FILES) ps

## Tail logs (usage: make logs SERVICE=grafana)
logs:
	$(COMPOSE) $(BASE) logs -f $(SERVICE)


alloy:
	$(COMPOSE) $(BASE) \
		-f compose/alloy-agent.yml \
		up -d alloy

cadvisor:
	$(COMPOSE) $(BASE) \
		-f compose/cadvisor.yml \
		up -d cadvisor

otel:
	$(COMPOSE) $(BASE) \
		-f compose/otel-collector.yml \
		up -d otel-collector

prometheus:
	$(COMPOSE) $(BASE) \
		-f compose/prometheus.yml \
		up -d prometheus

loki:
	$(COMPOSE) $(BASE) \
		-f compose/loki.yml \
		up -d loki

grafana:
	$(COMPOSE) $(BASE) \
		-f compose/grafana.yml \
		up -d grafana


log-alloy:
	$(COMPOSE) $(BASE) $(LOG_FILES_alloy) logs -f alloy

log-cadvisor:
	$(COMPOSE) $(BASE) $(LOG_FILES_cadvisor) logs -f cadvisor

log-otel:
	$(COMPOSE) $(BASE) $(LOG_FILES_otel) logs -f otel-collector

log-prometheus:
	$(COMPOSE) $(BASE) $(LOG_FILES_prometheus) logs -f prometheus

log-loki:
	$(COMPOSE) $(BASE) $(LOG_FILES_loki) logs -f loki

log-grafana:
	$(COMPOSE) $(BASE) $(LOG_FILES_grafana) logs -f grafan

.PHONY: restart-alloy restart-cadvisor restart-otel restart-prometheus restart-loki restart-grafana

restart-alloy:
	$(COMPOSE) $(BASE) $(LOG_FILES_alloy) restart alloy

restart-cadvisor:
	$(COMPOSE) $(BASE) $(LOG_FILES_cadvisor) restart cadvisor

restart-otel:
	$(COMPOSE) $(BASE) $(LOG_FILES_otel) restart otel-collector

restart-prometheus:
	$(COMPOSE) $(BASE) $(LOG_FILES_prometheus) restart prometheus

restart-loki:
	$(COMPOSE) $(BASE) $(LOG_FILES_loki) restart loki

restart-grafana:
	$(COMPOSE) $(BASE) $(LOG_FILES_grafana) restart grafana