xserver $command || return
app -b $command dropbox AutoHotKey AquaSnap LogitechOptions word greenshot PuttyAgent sshd terminator dropbox || return # dropbox shows false start initially, try again at end
return 0
