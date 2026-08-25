########
# Docker Post Installation Configuration
#     To allow non-root users to execute docker commands, we create the 'docker' group and add ourselves to it.
#     On Ubuntu we should also add the user to that group. (By default it is called "ubuntu").
#     See https://docs.docker.com/engine/install/linux-postinstall

# SUDO_USER is a standard environment variable set by sudo to the
# username of the account that invoked sudo. Fall back to USER when
# the bootstrap is run without sudo.
INVOKING_USER="${SUDO_USER:-$USER}"

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
if id -nG "$INVOKING_USER" | grep -qw "$GROUP"; then
  # No change needed -> idempotent behavior
  echo "User '$INVOKING_USER' is already in group '$GROUP' - no action needed."
else
  # Only run usermod if the user is NOT already in the group
  echo "Adding user '$INVOKING_USER' to group '$GROUP'..."

  # -aG appends the group without removing existing memberships
  # Requires sudo/root privileges
  sudo usermod -aG "$GROUP" "$INVOKING_USER"

  echo "User '$INVOKING_USER' has been added to group '$GROUP'."
  echo "Note: You may need to log out/in or run 'newgrp $GROUP' for this to take effect."
fi

#   With a fresh shell you can now do `docker run hello-world` instead of `sudo docker run hello-world`.
#   Alternatively you could use `newgrp docker` to have the user log in to the docker group in the
#   same session.
########
