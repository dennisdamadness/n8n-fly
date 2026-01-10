# Forzamos la variante Debian para que apt-get funcione
FROM n8nio/n8n:latest-debian

# Operaciones como root para instalar dependencias
USER root

# Instalamos Python 3 y herramientas de entorno virtual
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Creamos el entorno virtual e instalamos pandas y requests
RUN python3 -m venv /usr/local/n8n-python-venv
RUN /usr/local/n8n-python-venv/bin/pip install --no-cache-dir pandas requests

# Copiamos los archivos necesarios del repositorio
COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY n8n-task-runners.json /etc/n8n-task-runners.json

# Configuramos directorios de datos y permisos
# El entrypoint usa /home/node/data/.n8n para persistencia
RUN mkdir -p /home/node/data/.n8n && \
    chown -R node:node /home/node && \
    chown node:node /etc/n8n-task-runners.json

# El entrypoint se encarga de iniciar n8n como usuario 'node'
ENTRYPOINT ["/entrypoint.sh"]
CMD ["n8n"]
