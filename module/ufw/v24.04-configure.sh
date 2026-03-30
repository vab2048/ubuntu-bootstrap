
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


