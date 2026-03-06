FROM gautada/debian:13.3

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      python3-venv \
      curl \
      jq \
 && apt-get clean \
 && rm -rf /var/lib/lists/*

RUN python3 -m venv /opt/devpi \
 && /opt/devpi/bin/pip install --no-cache-dir \
      devpi-server \
      devpi-web \
      devpi-client

VOLUME ["/mnt/volumes/data"]

EXPOSE 3141

COPY version.sh /usr/bin/container-version
COPY latest.sh /usr/bin/container-latest
COPY appversion-check.sh /etc/container/health.d/appversion-check
COPY osversion.sh /usr/bin/container-osversion
COPY devpi-running.sh /etc/container/health.d/devpi-running
COPY devpi-entrypoint.sh /usr/bin/devpi-entrypoint

RUN chmod +x \
    /usr/bin/container-version \
    /usr/bin/container-latest \
    /etc/container/health.d/appversion-check \
    /usr/bin/container-osversion \
    /etc/container/health.d/devpi-running \
    /usr/bin/devpi-entrypoint

ENTRYPOINT ["/usr/bin/devpi-entrypoint"]
