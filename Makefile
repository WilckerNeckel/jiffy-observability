# ======================================
# Observability Stack - Makefile
# ======================================

OVERRIDE_FILE := docker-compose.override.yml
OVERRIDE := $(if $(wildcard $(OVERRIDE_FILE)),-f $(OVERRIDE_FILE),)

COMPOSE = docker compose --project-directory . $(OVERRIDE)
BASE    = -f compose/base.yml

ALL_FILES = \
	-f compose/base.yml \
	-f compose/alloy-agent.yml \
	-f compose/cadvisor.yml \
	-f compose/otel-collector.yml \
	-f compose/prometheus.yml \
	-f compose/loki.yml \
	-f compose/grafana.yml

ALLOY_FILE        = -f compose/alloy-agent.yml
CADVISOR_FILE     = -f compose/cadvisor.yml
OTEL_FILE         = -f compose/otel-collector.yml
PROMETHEUS_FILE   = -f compose/prometheus.yml
LOKI_FILE         = -f compose/loki.yml
GRAFANA_FILE      = -f compose/grafana.yml


# ---------- Scenarios ----------

.PHONY: \
	backend observability \
	up-all down-all ps logs \
	alloy cadvisor otel prometheus loki grafana \
	log-alloy log-cadvisor log-otel log-prometheus log-loki log-grafana \
	restart-alloy restart-cadvisor restart-otel restart-prometheus restart-loki restart-grafana

## Backend server (agent-only)
## Alloy + cAdvisor + Node Exporter
backend:
	$(COMPOSE) $(BASE) $(ALLOY_FILE) $(CADVISOR_FILE) up -d

## Observability central server
## Prometheus + Loki + Grafana
observability:
	$(COMPOSE) $(BASE) \
		$(PROMETHEUS_FILE) \
		$(LOKI_FILE) \
		$(OTEL_FILE) \
		$(GRAFANA_FILE) \
		up -d

## Full stack (lab / debug only)
up-all:
	$(COMPOSE) $(ALL_FILES) up -d

down-all:
	$(COMPOSE) $(ALL_FILES) down --remove-orphans

## Show running containers
ps:
	$(COMPOSE) $(ALL_FILES) ps

## Tail logs (usage: make logs SERVICE=grafana)
logs:
	$(COMPOSE) $(BASE) logs -f $(SERVICE)


# ---------- Single services ----------

alloy:
	$(COMPOSE) $(BASE) $(ALLOY_FILE) up -d alloy

cadvisor:
	$(COMPOSE) $(BASE) $(CADVISOR_FILE) up -d cadvisor

otel:
	$(COMPOSE) $(BASE) $(OTEL_FILE) up -d otel-collector

prometheus:
	$(COMPOSE) $(BASE) $(PROMETHEUS_FILE) up -d prometheus

loki:
	$(COMPOSE) $(BASE) $(LOKI_FILE) up -d loki

grafana:
	$(COMPOSE) $(BASE) $(GRAFANA_FILE) up -d grafana


# ---------- Logs ----------

log-alloy:
	$(COMPOSE) $(BASE) $(ALLOY_FILE) logs -f alloy

log-cadvisor:
	$(COMPOSE) $(BASE) $(CADVISOR_FILE) logs -f cadvisor

log-otel:
	$(COMPOSE) $(BASE) $(OTEL_FILE) logs -f otel-collector

log-prometheus:
	$(COMPOSE) $(BASE) $(PROMETHEUS_FILE) logs -f prometheus

log-loki:
	$(COMPOSE) $(BASE) $(LOKI_FILE) logs -f loki

log-grafana:
	$(COMPOSE) $(BASE) $(GRAFANA_FILE) logs -f grafana


# ---------- Restart ----------

restart-alloy:
	$(COMPOSE) $(BASE) $(ALLOY_FILE) restart alloy

restart-cadvisor:
	$(COMPOSE) $(BASE) $(CADVISOR_FILE) restart cadvisor

restart-otel:
	$(COMPOSE) $(BASE) $(OTEL_FILE) restart otel-collector

restart-prometheus:
	$(COMPOSE) $(BASE) $(PROMETHEUS_FILE) restart prometheus

restart-loki:
	$(COMPOSE) $(BASE) $(LOKI_FILE) restart loki

restart-grafana:
	$(COMPOSE) $(BASE) $(GRAFANA_FILE) restart grafana