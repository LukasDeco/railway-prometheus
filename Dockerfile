FROM ubuntu/prometheus

ARG GRAFANA_ADMIN_PASSWORD
ENV GRAFANA_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}

# Install Supervisor
RUN apt-get update && apt-get install -y supervisor

# Install grafana:
RUN apt-get install -y apt-transport-https software-properties-common wget
RUN mkdir -p /etc/apt/keyrings/
RUN wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
RUN echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list
RUN apt-get update
RUN apt-get install grafana git -y


# Copy Prometheus configuration file
ADD grafana.ini /etc/grafana/
ADD supervisord.conf /etc/
ADD prometheus.yml /etc/prometheus/prometheus.yml

RUN grafana-cli admin reset-admin-password ${GRAFANA_ADMIN_PASSWORD}

# Set the entrypoint to Supervisor
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

