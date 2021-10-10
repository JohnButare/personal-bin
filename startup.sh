# start X Server and update network first
app -b $command xserver network || return

# start SSH before port forwarding, as we check for open ports using SSH
app -b sshd ports || return

# services - dbus docker chrony cron incron
app -b $command dbus docker || return 

# chrony - fixes time drift in WSL under Hyper-V
IsPlatform wsl && IsHypervVm && { app -b $command chrony time || return; } 	

# applications
app -b $command AquaSnap AutoHotKey ghub LogitechOptions pu TidyTabs || return

return 0
