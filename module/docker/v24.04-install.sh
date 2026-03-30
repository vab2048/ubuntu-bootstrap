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
# Docker compose installation
#     docker-compose-v2 is the recommended pacakge to use for docker compose now.
#     It is the golang implementation which integrates directly with the docker CLI,
#     so it can be used like so: `docker compose`
#
#     This is opposed to v1 which was a python binary that was invoked directly and
#     not through the docker cli i.e. `docker-compose.
sudo apt-get install -y docker-compose-v2