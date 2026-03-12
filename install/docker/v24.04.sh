#!/usr/bin/env bash
set -euxo pipefail

#######################################################################################################################
# Install `docker` and `docker compose`
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

echo "Adding '$USER' user to 'docker' group"
sudo usermod -aG docker $USER

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