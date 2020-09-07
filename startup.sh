xserver $command || return

# service
app -b $command chrony docker sshd  || return

# applications - dropbox shows false start initially, try again at end
app -b $command dropbox AutoHotKey AquaSnap LogitechOptions greenshot PuttyAgent word dropbox || return

return 0
