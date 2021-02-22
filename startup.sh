xserver $command || return

# service
app -b $command dbus sshd  || return # dbus docker chrony cron incron sshd

# applications
app -b $command AquaSnap AutoHotKey LogitechOptions pu TidyTabs || return

return 0
