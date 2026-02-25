#!/bin/bash

# Start Prometheus in the background
echo "Starting Prometheus..."
prometheus --config.file=/etc/prometheus/prometheus.yml &

# Start Grafana in the foreground
echo "Starting Grafana..."
# Fix for Render: Force Grafana to listen on 0.0.0.0 and Port 3000
export GF_SERVER_HTTP_PORT=3000
export GF_AUTH_ANONYMOUS_ENABLED=true
export GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
export GF_AUTH_DISABLE_LOGIN_FORM=true
export GF_SECURITY_ALLOW_EMBEDDING=true

# Launch Grafana
/usr/sbin/grafana-server --homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini
