xserver $command || return
app -b $command DropBox AutoHotKey AquaSnap LogitechOptions word Greenshot PuttyAgent sshd terminator DropBox || return # dropbox shows false start initially, try again at end
return 0
