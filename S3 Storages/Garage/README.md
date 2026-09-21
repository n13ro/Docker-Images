# Garage (S3) — single-node через Docker Compose

## Запуск

```bash
# 1. Сгенерируйте секреты и положите в .env
sh ./gen.sh
# или
cp .env.example .env 
# отредактируйте .env, либо же сгенерируйте сразу в .env:
cat > .env <<EOF
RPC_SECRET=$(openssl rand -hex 32)
ADMIN_TOKEN=$(openssl rand -base64 32)
METRICS_TOKEN=$(openssl rand -base64 32)
GARAGE_DEFAULT_ACCESS_KEY=GK$(openssl rand -hex 16)
GARAGE_DEFAULT_SECRET_KEY=$(openssl rand -hex 32)
EOF

# 2. Подними
docker compose -f docker-compose.garage.yml up -d

# 3. Проверь статус(Опционально)
docker exec garage /garage status
```

## Использование (awscli) ОПЦИОНАЛЬНО!!!

```bash
pip install --user awscli   # нужен >= 1.29.0 или >= 2.13.0

cat > ~/.awsrc <<EOF
export AWS_ENDPOINT_URL='http://localhost:3900'
export AWS_DEFAULT_REGION='garage'
export AWS_ACCESS_KEY_ID='<GARAGE_DEFAULT_ACCESS_KEY из .env>'
export AWS_SECRET_ACCESS_KEY='<GARAGE_DEFAULT_SECRET_KEY из .env>'
EOF

source ~/.awsrc
aws s3 ls
aws s3 cp ./file.txt s3://default-bucket/file.txt
```

## Порты

| Порт | Назначение        |
|------|-------------------|
| 3900 | S3 API            |
| 3902 | S3 веб-сайты      |
| 3903 | Admin API / метрики |
| 3909 | UI Panel         |

RPC (3901) опционально для нод

## Управление

```bash
docker compose  logs -f garage
docker exec garage /garage status
docker exec garage /garage bucket list
docker exec garage /garage key list
```

⚠️ Это развёртывание без репликации — для прода используй
multi-node кластер (см. документацию Garage).

## Веб-интерфейс (WebUI)

В стеке есть сторонний Web UI (`khairul169/garage-webui`):
http://localhost:3909 — статус кластера, бакеты, ключи, браузер объектов
с drag-and-drop загрузкой. Подключается к Garage через Admin API (порт 3903)
внутри docker-сети, наружу торчит только 3909.

Опционально можно включить авторизацию (bcrypt-хеш пароля):
```bash
htpasswd -nbBC 10 "admin" "твой_пароль"
# результат в .env: AUTH_USER_PASS: "admin:$2y$10$..."
```
