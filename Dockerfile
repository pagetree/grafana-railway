FROM grafana/grafana:latest

USER root

RUN apk add --no-cache bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Grafana data persistence
VOLUME ["/var/lib/grafana"]

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
