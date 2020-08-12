xserver $command || return
app -b $command chrony dropbox AutoHotKey AquaSnap LogitechOptions greenshot PuttyAgent sshd dropbox || return # dropbox shows false start initially, try again at end
return 0
