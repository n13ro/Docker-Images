#!/bin/sh

cat > .env <<EOF
RPC_SECRET=$(openssl rand -hex 32)
ADMIN_TOKEN=$(openssl rand -base64 32)
METRICS_TOKEN=$(openssl rand -base64 32)
GARAGE_DEFAULT_ACCESS_KEY=GK$(openssl rand -hex 16)
GARAGE_DEFAULT_SECRET_KEY=$(openssl rand -hex 32)
EOF
