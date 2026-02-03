# ======================================
# Observability Stack - Makefile
# ======================================

COMPOSE = docker compose --project-directory .

# ---------- Base compose ----------

BASE = -f compose/base.yml

# ---------- Service files ----------

ALLOY_FILE      = -f compose/alloy-agent.yml
CADVISOR_FILE   = -f compose/cadvisor.yml
PROMETHEUS_FILE = -f compose/prometheus.yml
LOKI_FILE       = -f compose/loki.yml
GRAFANA_FILE    = -f compose/grafana.yml

# Conjunto completo de arquivos base (para up-all, ps, down-all, logs)
ALL_FILES = \
	$(BASE) \
	$(ALLOY_FILE) \
	$(CADVISOR_FILE) \
	$(PROMETHEUS_FILE) \
	$(LOKI_FILE) \
	$(GRAFANA_FILE)

# ---------- Optional overrides (per service) ----------

ALLOY_OVERRIDE      = $(if $(wildcard compose/alloy-agent.override.yml),-f compose/alloy-agent.override.yml,)
CADVISOR_OVERRIDE   = $(if $(wildcard compose/cadvisor.override.yml),-f compose/cadvisor.override.yml,)
PROMETHEUS_OVERRIDE = $(if $(wildcard compose/prometheus.override.yml),-f compose/prometheus.override.yml,)
LOKI_OVERRIDE       = $(if $(wildcard compose/loki.override.yml),-f compose/loki.override.yml,)
GRAFANA_OVERRIDE    = $(if $(wildcard compose/grafana.override.yml),-f compose/grafana.override.yml,)

# Conjunto completo de overrides (para up-all / observability / backend)
ALL_OVERRIDES = \
	$(ALLOY_OVERRIDE) \
	$(CADVISOR_OVERRIDE) \
	$(PROMETHEUS_OVERRIDE) \
	$(LOKI_OVERRIDE) \
	$(GRAFANA_OVERRIDE)


# ---------- Scenarios ----------

.PHONY: \
	backend observability \
	up-all down-all ps logs \
	alloy cadvisor prometheus loki grafana \
	log-alloy log-cadvisor log-prometheus log-loki log-grafana \
	restart-alloy restart-cadvisor restart-prometheus restart-loki restart-grafana \
	down-alloy down-cadvisor down-prometheus down-loki down-grafana

## Backend server (agent-only)
## Alloy + cAdvisor + Node Exporter
backend:
	$(COMPOSE) \
		$(BASE) \
		$(ALLOY_FILE) $(ALLOY_OVERRIDE) \
		$(CADVISOR_FILE) $(CADVISOR_OVERRIDE) \
		up -d

## Observability central server
## Prometheus + Loki + Grafana 
observability:
	$(COMPOSE) \
		$(BASE) \
		$(PROMETHEUS_FILE) $(PROMETHEUS_OVERRIDE) \
		$(LOKI_FILE)       $(LOKI_OVERRIDE) \
		$(GRAFANA_FILE)    $(GRAFANA_OVERRIDE) \
		up -d

## Full stack (lab / debug only)
up-all:
	$(COMPOSE) $(ALL_FILES) $(ALL_OVERRIDES) up -d

down-all:
	$(COMPOSE) $(ALL_FILES) down --remove-orphans

## Show running containers
ps:
	$(COMPOSE) $(ALL_FILES) ps

## Tail logs (usage: make logs SERVICE=grafana)
logs:
	$(COMPOSE) $(ALL_FILES) logs -f $(SERVICE)


# ---------- Single services (UP) ----------

alloy:
	$(COMPOSE) $(BASE) $(ALLOY_FILE) $(ALLOY_OVERRIDE) up -d alloy

cadvisor:
	$(COMPOSE) $(BASE) $(CADVISOR_FILE) $(CADVISOR_OVERRIDE) up -d cadvisor

prometheus:
	$(COMPOSE) $(BASE) $(PROMETHEUS_FILE) $(PROMETHEUS_OVERRIDE) up -d prometheus

loki:
	$(COMPOSE) $(BASE) $(LOKI_FILE) $(LOKI_OVERRIDE) up -d loki

grafana:
	$(COMPOSE) $(BASE) $(GRAFANA_FILE) $(GRAFANA_OVERRIDE) up -d grafana


# ---------- Logs (por serviço) ----------

log-alloy:
	$(COMPOSE) $(BASE) $(ALLOY_FILE) logs -f alloy

log-cadvisor:
	$(COMPOSE) $(BASE) $(CADVISOR_FILE) logs -f cadvisor

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

restart-prometheus:
	$(COMPOSE) $(BASE) $(PROMETHEUS_FILE) restart prometheus

restart-loki:
	$(COMPOSE) $(BASE) $(LOKI_FILE) restart loki

restart-grafana:
	$(COMPOSE) $(BASE) $(GRAFANA_FILE) restart grafana


# ---------- Shutdown (isolated) ----------

down-alloy:
	$(COMPOSE) $(BASE) $(ALLOY_FILE) down

down-cadvisor:
	$(COMPOSE) $(BASE) $(CADVISOR_FILE) down

down-prometheus:
	$(COMPOSE) $(BASE) $(PROMETHEUS_FILE) down

down-loki:
	$(COMPOSE) $(BASE) $(LOKI_FILE) down

down-grafana:
	$(COMPOSE) $(BASE) $(GRAFANA_FILE) down