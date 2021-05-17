app -b $command xserver network || return

# service
app -b $command dbus sshd || return # dbus docker chrony cron incron sshd

# chrony - fixes time drift in WSL under Hyper-V
IsPlatform wsl && IsHypervVm && { app -b $command chrony time || return; } 	

# applications
app -b $command AquaSnap AutoHotKey LogitechOptions pu TidyTabs || return

return 0
