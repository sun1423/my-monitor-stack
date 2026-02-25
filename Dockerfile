FROM ubuntu:22.04

# 1. Install Prometheus and Grafana
RUN apt-get update && \
    apt-get install -y prometheus wget gnupg2 software-properties-common && \
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - && \
    add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" && \
    apt-get update && \
    apt-get install -y grafana && \
    apt-get clean

# 2. Copy Configuration Files
COPY prometheus.yml /etc/prometheus/prometheus.yml
COPY datasource.yml /etc/grafana/provisioning/datasources/datasource.yml

# 3. Expose Ports (Render only allows one public port, so we expose Grafana)
EXPOSE 3000

# 4. Create a startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 5. Start command
CMD ["/start.sh"]
