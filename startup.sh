export CACHED_PROCESSES="$(ProcessList)"

# start X Server, D-Bus, and network first
# - D-Bus enables the GNOME Keyring credential manager which is used below for credentials
st xserver dbus network || return

# start SSH before port forwarding, as we check for open ports using SSH
st sshd ports || return

# services - dbus docker chrony cron incron
st docker || return 

# clock
st chrony || return
IsPlatform wsl && IsHypervVm && { st time || return; } # fixes time drift in WSL under Hyper-V

# applications
st WindowManager AutoHotKey LogitechOptions LogitechOptionsPlus pu slack || return

IsPlatform parallels && { drive mount all || return; }

return 0
