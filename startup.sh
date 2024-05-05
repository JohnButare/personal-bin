# cache processes for faster checks below
export CACHED_PROCESSES="$(ProcessList)"

# ensure network configure is correct first
st network

# start X Server and D-Bus (for credentials)
st xserver dbus

# start SSH before port forwarding (ports check uses SSH)
st sshd ports

# other services - docker cron incron nix
st docker nix

# clock - fix time drift in WSL and major differences when Hyper-V guest resumes
IsPlatform wsl && { st time; }

# applications
st WindowManager																					# start first
st AutoHotKey pu UltraMon																	# win
st alfred alttab hammerspoon rectangle shottr || return		# mac

IsPlatform parallels && { drive mount all --no-optical || return; }

# time synchronization - run last, can fail
st chrony
