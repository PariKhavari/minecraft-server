# ---- Base image: minimal JRE, no prebuilt Minecraft image ----
FROM eclipse-temurin:25-jre-jammy

# Build-time argument: which official Minecraft server version to fetch
ARG MINECRAFT_VERSION=1.21.1

# Install packages needed to resolve & download the official server jar
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl jq && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /server

# Resolve the official download URL via Mojang's public version manifest
# (same source the official launcher uses) and download server.jar.
RUN VERSION_URL=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest_v2.json \
        | jq -r --arg VER "${MINECRAFT_VERSION}" '.versions[] | select(.id == $VER) | .url') && \
    SERVER_JAR_URL=$(curl -s "${VERSION_URL}" | jq -r '.downloads.server.url') && \
    curl -s -o server.jar "${SERVER_JAR_URL}"

# Entrypoint script: builds server.properties from env vars and starts the server
COPY entrypoint.sh /server/entrypoint.sh
RUN chmod +x /server/entrypoint.sh

# ---- Default environment variables (container must always be able to start) ----
# EULA_ACCEPTED has NO default of "true" on purpose: accepting Mojang's EULA is a
# legal decision the operator must make explicitly via docker-compose/.env.
ENV EULA_ACCEPTED="false"
ENV SERVER_NAME="My Minecraft Server"
ENV DIFFICULTY="normal"
ENV MAX_PLAYERS="20"
ENV GAME_MODE="survival"
ENV SERVER_PORT="25565"
ENV MEMORY_MIN="1G"
ENV MEMORY_MAX="2G"

EXPOSE ${SERVER_PORT}

ENTRYPOINT ["/server/entrypoint.sh"]