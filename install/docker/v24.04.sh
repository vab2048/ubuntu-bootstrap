#!/usr/bin/env bash
set -euo pipefail

#######################################################################################################################
# Install `docker` and `docker compose`
# - IDEMPOTENT:
#   - If run again will update package to latest version [example output: (docker.io is already the newest version
#     (28.2.2-0ubuntu1~24.04.1).]
#   - This is good enough.
#######################################################################################################################
# There are two ways in which you can install docker:
# 1. Official Ubuntu packages
#   - Ships with Ubuntu
#   - Gives you an older version compared to the official docker repository
#   - called "docker.io" in their repository
# 2. Official Docker packages
#   - Requires more setup - adding the docker apt package repository to the system, pulling from there.
#   - Gives you the latest version
#   - called "docker.ce" in their repository
#
# In this script we go with option 1 since it is just easier to maintain, and user facing
# CLI is pretty stable now in Docker regardless of which repository we pull from.

# Install docker from the Ubuntu packages and enable it as a service.
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

########
# Docker Post Installation steps
#     To allow non-root users to execute docker commands, we create the 'docker' group and add ourselves to it.
#     On Ubuntu this means adding the default user (called "ubuntu" and referenced as $USER) to the group.
#     See https://docs.docker.com/engine/install/linux-postinstall
if getent group docker > /dev/null; then
    echo "Group 'docker' already exists."
else
    sudo groupadd docker
    echo "Group 'docker' created"
fi

# Add the current user to the "docker" group if it is not there already.
# - id -nG lists all groups for the user
# - grep -qw ensures an exact match (no partial matches like 'dockerroot')
GROUP="docker"
if id -nG "$USER" | grep -qw "$GROUP"; then
  # No change needed -> idempotent behavior
  echo "User '$USER' is already in group '$GROUP' - no action needed."
else
  # Only run usermod if the user is NOT already in the group
  echo "Adding user '$USER' to group '$GROUP'..."

  # -aG appends the group without removing existing memberships
  # Requires sudo/root privileges
  sudo usermod -aG "$GROUP" "$USER"

  echo "User '$USER' has been added to group '$GROUP'."
  echo "Note: You may need to log out/in or run 'newgrp $GROUP' for this to take effect."
fi

#   With a fresh shell you can now do `docker run hello-world` instead of `sudo docker run hello-world`.
#   Alternatively you could use `newgrp docker` to have the user log in to the docker group in the
#   same session.
########

########
# Docker compose installation
#     docker-compose-v2 is the recommended pacakge to use for docker compose now.
#     It is the golang implementation which integrates directly with the docker CLI,
#     so it can be used like so: `docker compose`
#
#     This is opposed to v1 which was a python binary that was invoked directly and
#     not through the docker cli i.e. `docker-compose.
sudo apt-get install -y docker-compose-v2