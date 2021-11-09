# start X Server and update network first
st xserver network || return

# start SSH before port forwarding, as we check for open ports using SSH
st sshd ports || return

# services - dbus docker chrony cron incron
st dbus docker || return 

# chrony - fixes time drift in WSL under Hyper-V
IsPlatform wsl && IsHypervVm && { st chrony time || return; } 	

# applications
st WindowManager AutoHotKey ghub LogitechOptions pu TidyTabs || return

# specific applciations
case "$HOSTNAME" in
	oversoul) st DellDisplayManager;;
esac

return 0
