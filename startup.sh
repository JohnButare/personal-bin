xserver $command || return

# network
app -b $command network || return

# service
app -b $command dbus sshd || return # dbus docker chrony cron incron sshd

# fix time drift in WSL under Hyper-V
IsPlatform wsl && IsHypervVm && { app -b $command chrony time || return; } 	

# applications
app -b $command AquaSnap AutoHotKey LogitechOptions pu || return # TidyTabs

return 0
