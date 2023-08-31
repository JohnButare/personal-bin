# cache processes for faster checks below
export CACHED_PROCESSES="$(ProcessList)"

# ensure network configure is correct first
st network || return

# start X Server and D-Bus (for credentials)
st xserver dbus || return

# start SSH before port forwarding (ports check uses SSH)
st sshd ports || return

# other services - chrony docker cron incron
st chrony docker || return 

# clock - fix time drift in WSL and major differences when Hyper-V guest resumes
IsPlatform wsl && { st time || return; }

# applications
st WindowManager || return										# start first
st slack || return														# common
st AutoHotKey alttab pu UltraMon || return		# win
st alfred alttab rectangle shottr || return		# mac

IsPlatform parallels && { drive mount all || return; }

return 0
