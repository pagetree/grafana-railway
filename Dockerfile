FROM grafana/grafana:latest

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
