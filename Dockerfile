FROM ubuntu/prometheus

# Install Supervisor
RUN apt-get update && apt-get install -y supervisor

# Install grafana:
RUN apt-get install -y apt-transport-https software-properties-common wget
RUN mkdir -p /etc/apt/keyrings/
RUN wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
RUN echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list
RUN apt-get update
RUN apt-get install grafana -y


# Copy Prometheus configuration file
COPY prometheus.yml /etc/prometheus/prometheus.yml
# Copy Prometheus configuration file
COPY grafana.sh /grafana.sh
RUN chmod +x /grafana.sh

# Copy Supervisor configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports for Prometheus and Grafana
EXPOSE 9090 3000

# Set the entrypoint to Supervisor
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
