#!/bin/bash
set -e

cd /home/container

# First run init
if [ -z "$(ls -A /home/container)" ]; then
    echo "Initializing server directory..."
    cp -r /skeleton/* /home/container/
    chmod +x /home/container/start.sh
fi

# Pterodactyl startup replace
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP_CMD}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")

echo ":/home/container$ ${MODIFIED_STARTUP}"

exec ${MODIFIED_STARTUP}