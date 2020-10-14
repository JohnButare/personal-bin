xserver $command || return

# service
app -b $command dbus chrony cron incron sshd  || return # docker

# applications - dropbox shows false start initially, try again at end
app -b $command dropbox AutoHotKey AquaSnap LogitechOptions greenshot dropbox || return

return 0
