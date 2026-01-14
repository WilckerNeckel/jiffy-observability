antes de fazer o deploy você precisa dar esses comandos para setar as permissões corretas na pasta do loki:

```bash
mkdir -p ./loki-data
sudo chown 10001:10001 ./loki-data
sudo chmod -R 755 ./loki-data
```