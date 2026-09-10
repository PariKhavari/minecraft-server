#!/bin/bash
set -e

# --- EULA check (legal requirement, no silent default to "true") ---
if [ "${EULA_ACCEPTED}" != "true" ]; then
  echo "ERROR: You must explicitly accept the Mojang EULA."
  echo "Set EULA_ACCEPTED=true (see https://www.minecraft.net/en-us/eula) via your .env file."
  exit 1
fi
echo "eula=true" > eula.txt

# --- Build server.properties from environment variables ---
cat > server.properties <<EOF
motd=${SERVER_NAME}
difficulty=${DIFFICULTY}
max-players=${MAX_PLAYERS}
gamemode=${GAME_MODE}
server-port=${SERVER_PORT}
EOF

echo "Starting Minecraft server '${SERVER_NAME}' on port ${SERVER_PORT}..."
exec java -Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -jar server.jar nogui