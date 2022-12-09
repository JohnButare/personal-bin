export CACHED_PROCESSES="$(ProcessList)"

# start X Server, D-Bus, and network first
# - D-Bus enables the GNOME Keyring credential manager which is used below for credentials
st xserver dbus network || return

# start SSH before port forwarding, as we check for open ports using SSH
st sshd ports || return

# services - dbus docker chrony cron incron
st docker || return 

# chrony - fixes time drift in WSL under Hyper-V
IsPlatform wsl && IsHypervVm && { st chrony time || return; } 	

# applications
st WindowManager AutoHotKey LogitechOptions pu slack teams || return

# specific applciations
case "$HOSTNAME" in
	oversoul) st DellDisplayManager;;
esac

IsPlatform parallels && { drive mount all || return; }

return 0
