#!/bin/bash
set -e

cd /home/container

# First run init (copy skeleton once)
if [ -z "$(ls -A /home/container)" ]; then
  echo "Initializing server files..."
  cp -r /skeleton/* /home/container/
fi

# Fix permissions (safe for re-run)
chown -R container:container /home/container || true

# Replace Startup Variables (Pterodactyl style)
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")

echo ":/home/container$ ${MODIFIED_STARTUP}"

exec ${MODIFIED_STARTUP}