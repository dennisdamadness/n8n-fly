FROM docker.n8n.io/n8nio/n8n:latest

# Ensure we start as root for setup operations
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /usr/local/n8n-python-venv
RUN /usr/local/n8n-python-venv/bin/pip install pandas requests
# Copy entrypoint script with executable permissions
COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY n8n-task-runners.json /etc/n8n-task-runners.json

# Create necessary directories as root
RUN mkdir -p /home/node/data/.n8n && \
    chown -R node:node /home/node && \
    chown node:node /etc/n8n-task-runners.json
# The entrypoint will handle switching to node user
# Environment variables will be set via Fly.io

# Use custom entrypoint to capture env vars at runtime
ENTRYPOINT ["/entrypoint.sh"]
CMD ["n8n"] 
