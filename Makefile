# ======================================
# Observability Stack - Makefile
# ======================================

# ---------- Override (optional) ----------

OVERRIDE_FILE := docker-compose.override.yml
OVERRIDE := $(if $(wildcard $(OVERRIDE_FILE)),-f $(OVERRIDE_FILE),)

# ---------- Compose commands ----------

# Core compose (NO override) – ops, logs, restart, down
COMPOSE_CORE     = docker compose --project-directory .

# Runtime compose (WITH override) – up, lab, exposed ports
COMPOSE_OVERRIDE = docker compose --project-directory . $(OVERRIDE)

BASE = -f compose/base.yml

# ---------- Compose files ----------

ALL_FILES = \
	-f compose/base.yml \
	-f compose/alloy-agent.yml \
	-f compose/cadvisor.yml \
	-f compose/otel-collector.yml \
	-f compose/prometheus.yml \
	-f compose/loki.yml \
	-f compose/grafana.yml

ALLOY_FILE      = -f compose/alloy-agent.yml
CADVISOR_FILE   = -f compose/cadvisor.yml
OTEL_FILE       = -f compose/otel-collector.yml
PROMETHEUS_FILE = -f compose/prometheus.yml
LOKI_FILE       = -f compose/loki.yml
GRAFANA_FILE    = -f compose/grafana.yml


# ---------- Scenarios ----------

.PHONY: \
	backend observability \
	up-all down-all ps logs \
	alloy cadvisor otel prometheus loki grafana \
	log-alloy log-cadvisor log-otel log-prometheus log-loki log-grafana \
	restart-alloy restart-cadvisor restart-otel restart-prometheus restart-loki restart-grafana \
	down-alloy down-cadvisor down-otel down-prometheus down-loki down-grafana

## Backend server (agent-only)
## Alloy + cAdvisor + Node Exporter
backend:
	$(COMPOSE_OVERRIDE) $(BASE) $(ALLOY_FILE) $(CADVISOR_FILE) up -d

## Observability central server
## Prometheus + Loki + Grafana
observability:
	$(COMPOSE_OVERRIDE) $(BASE) \
		$(PROMETHEUS_FILE) \
		$(LOKI_FILE) \
		$(OTEL_FILE) \
		$(GRAFANA_FILE) \
		up -d

## Full stack (lab / debug only)
up-all:
	$(COMPOSE_OVERRIDE) $(ALL_FILES) up -d

down-all:
	$(COMPOSE_CORE) $(ALL_FILES) down --remove-orphans

## Show running containers
ps:
	$(COMPOSE_CORE) $(ALL_FILES) ps

## Tail logs (usage: make logs SERVICE=grafana)
logs:
	$(COMPOSE_CORE) $(BASE) logs -f $(SERVICE)


# ---------- Single services (UP) ----------

alloy:
	$(COMPOSE_OVERRIDE) $(BASE) $(ALLOY_FILE) up -d alloy

cadvisor:
	$(COMPOSE_OVERRIDE) $(BASE) $(CADVISOR_FILE) up -d cadvisor

otel:
	$(COMPOSE_OVERRIDE) $(BASE) $(OTEL_FILE) up -d otel-collector

prometheus:
	$(COMPOSE_OVERRIDE) $(BASE) $(PROMETHEUS_FILE) up -d prometheus

loki:
	$(COMPOSE_OVERRIDE) $(BASE) $(LOKI_FILE) up -d loki

grafana:
	$(COMPOSE_OVERRIDE) $(BASE) $(GRAFANA_FILE) up -d grafana


# ---------- Logs ----------

log-alloy:
	$(COMPOSE_CORE) $(BASE) $(ALLOY_FILE) logs -f alloy

log-cadvisor:
	$(COMPOSE_CORE) $(BASE) $(CADVISOR_FILE) logs -f cadvisor

log-otel:
	$(COMPOSE_CORE) $(BASE) $(OTEL_FILE) logs -f otel-collector

log-prometheus:
	$(COMPOSE_CORE) $(BASE) $(PROMETHEUS_FILE) logs -f prometheus

log-loki:
	$(COMPOSE_CORE) $(BASE) $(LOKI_FILE) logs -f loki

log-grafana:
	$(COMPOSE_CORE) $(BASE) $(GRAFANA_FILE) logs -f grafana


# ---------- Restart ----------

restart-alloy:
	$(COMPOSE_CORE) $(BASE) $(ALLOY_FILE) restart alloy

restart-cadvisor:
	$(COMPOSE_CORE) $(BASE) $(CADVISOR_FILE) restart cadvisor

restart-otel:
	$(COMPOSE_CORE) $(BASE) $(OTEL_FILE) restart otel-collector

restart-prometheus:
	$(COMPOSE_CORE) $(BASE) $(PROMETHEUS_FILE) restart prometheus

restart-loki:
	$(COMPOSE_CORE) $(BASE) $(LOKI_FILE) restart loki

restart-grafana:
	$(COMPOSE_CORE) $(BASE) $(GRAFANA_FILE) restart grafana


# ---------- Shutdown (isolated) ----------

down-alloy:
	$(COMPOSE_CORE) $(BASE) $(ALLOY_FILE) down

down-cadvisor:
	$(COMPOSE_CORE) $(BASE) $(CADVISOR_FILE) down

down-otel:
	$(COMPOSE_CORE) $(BASE) $(OTEL_FILE) down

down-prometheus:
	$(COMPOSE_CORE) $(BASE) $(PROMETHEUS_FILE) down

down-loki:
	$(COMPOSE_CORE) $(BASE) $(LOKI_FILE) down

down-grafana:
	$(COMPOSE_CORE) $(BASE) $(GRAFANA_FILE) down