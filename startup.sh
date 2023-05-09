export CACHED_PROCESSES="$(ProcessList)"

# start X Server, D-Bus, and network first
# - D-Bus enables the GNOME Keyring credential manager which is used below for credentials
st xserver dbus network || return

# start SSH before port forwarding, as we check for open ports using SSH
st sshd ports || return

# services - dbus docker cron incron
st docker || return 

# clock
IsPlatform wsl && { st time || return; } # fixes time drift in WSL and major differences when Hyper-V guest resumes

# applications
st WindowManager || return										# start first
st NoMachine slack || return									# common
st AutoHotKey alttab pu UltraMon || return		# win
st alfred alttab rectangle shottr || return		# mac

IsPlatform parallels && { drive mount all || return; }

return 0
