FROM prom/prometheus
LABEL maintainer="Your Name <your.email@example.com>"

# Install Supervisor
RUN apt-get update && apt-get install -y supervisor

# Copy Prometheus configuration file
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Copy Supervisor configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports for Prometheus and Grafana
EXPOSE 9090 3000

# Set the entrypoint to Supervisor
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
