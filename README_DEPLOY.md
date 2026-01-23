antes de fazer o deploy você precisa dar esses comandos para setar as permissões corretas na pasta do loki e grafana:

```bash
mkdir -p ./loki-data
sudo chown 10001:10001 ./loki-data
sudo chmod -R 755 ./loki-data

mkdir -p .data/grafana
sudo chown -R 472:472 .data/grafana
```