# Notes:
# - Usage of `--force` in commands is so that they can be run non-interactively.

##############
# Step 1 - Reset to factory defaults.
#   This is so we start our configuration from the baseline default.
#   Example output:
#      root@ip-172-26-2-19:~# sudo ufw --force disable
#      Firewall stopped and disabled on system startup
#
#      root@ip-172-26-2-19:~# sudo ufw --force reset
#      Backing up 'user.rules' to '/etc/ufw/user.rules.20260330_122038'
#      Backing up 'before.rules' to '/etc/ufw/before.rules.20260330_122038'
#      Backing up 'after.rules' to '/etc/ufw/after.rules.20260330_122038'
#      Backing up 'user6.rules' to '/etc/ufw/user6.rules.20260330_122038'
#      Backing up 'before6.rules' to '/etc/ufw/before6.rules.20260330_122038'
#      Backing up 'after6.rules' to '/etc/ufw/after6.rules.20260330_122038'
sudo ufw --force disable
sudo ufw --force reset

##############
# Step 2 - Add baseline rules

# `deny incoming` and `allow outgoing` is the normal default - we apply it explicitly here.
# Subsequent rules later will allow specific ports (e.g. ssh)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# This is so that you don't lock yourself out when the firewall is enabled, and future sessions can connect.
sudo ufw allow ssh

##############
# Step 3 - Configure tailscale

# By default:
# - Tailscale installs firewall rules directly. You need to logged in for this to occur. You can see them with:
#    - iptables style:        `sudo iptables -S | grep -i tailscale`
#    - nftables (definitive): `sudo nft list ruleset | grep tailscale`
# - nftables works with the following steps:
#     ruleset
#      └── tables
#           └── chains    [INPUT=Packets destined for this machine, OUTPUT=Packets originating from this machine,FORWARD=Packets passing through the machine (not for it)]
#                └── rules
#                     └── expressions → verdicts
#    - rules for tailscale are added to "table ip filter" and "table ip6 filter" (i.e. ipv4 and ipv6 tables called "filter")
#    - The INPUT,FORWARD chains add rules so traffic bound for interface tailscale0 is matched by them.
#      These rules are placed BEFORE the ufw ones. So tailscale0 traffic is NOT managed by ufw.
# - See this issue discussing it: https://github.com/tailscale/tailscale/issues/11033

# Some old tutorials say you should run `sudo ufw allow in on tailscale0` but this is outdated - there is no point
# in configuring ufw to try and manage tailscale. By default all inbound/outbound traffic to tailscale0 is allowed.

# It is still worth having ufw enabled to prevent access for the other interface(s) though!
# I.E. Public ipv4 and ipv6 addresses do not allow any packets.

##############
# Step 4 - Enable ufw
sudo ufw --force enable