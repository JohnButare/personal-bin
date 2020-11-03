# xserver $command || return

# service
# app -b $command sshd  || return # dbus docker chrony cron incron sshd

# applications
app -b $command AquaSnap || return # AquaSnap AutoHotKey LogitechOptions

return 0
