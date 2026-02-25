FROM ubuntu:22.04

# 1. Install Dependencies & Prometheus
# We install 'curl' and 'libfontconfig1' which Grafana needs
RUN apt-get update && \
    apt-get install -y prometheus curl libfontconfig1 musl && \
    apt-get clean

# 2. Install Grafana (Direct Download to prevent Repository Errors)
# We download the .deb file manually to ensure it works every time
RUN curl -O https://dl.grafana.com/oss/release/grafana_10.4.0_amd64.deb && \
    dpkg -i grafana_10.4.0_amd64.deb && \
    rm grafana_10.4.0_amd64.deb

# 3. Copy Config Files
COPY prometheus.yml /etc/prometheus/prometheus.yml
COPY datasource.yml /etc/grafana/provisioning/datasources/datasource.yml

# 4. Create the Startup Script INSIDE the image
# This fixes the "COPY failed: file not found" error
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "Starting Prometheus..."' >> /start.sh && \
    echo 'prometheus --config.file=/etc/prometheus/prometheus.yml &' >> /start.sh && \
    echo 'echo "Starting Grafana..."' >> /start.sh && \
    echo 'export GF_SERVER_HTTP_PORT=3000' >> /start.sh && \
    echo 'export GF_AUTH_ANONYMOUS_ENABLED=true' >> /start.sh && \
    echo 'export GF_AUTH_ANONYMOUS_ORG_ROLE=Admin' >> /start.sh && \
    echo 'export GF_AUTH_DISABLE_LOGIN_FORM=true' >> /start.sh && \
    echo 'export GF_SECURITY_ALLOW_EMBEDDING=true' >> /start.sh && \
    echo '/usr/sbin/grafana-server --homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini' >> /start.sh && \
    chmod +x /start.sh

# 5. Expose Port and Start
EXPOSE 3000
CMD ["/start.sh"]
