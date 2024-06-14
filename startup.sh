# cache processes for faster checks below
export CACHED_PROCESSES="$(ProcessList)"

# ensure network configure is correct first
st network

# start X Server and D-Bus (for credentials)
st xserver
! { IsPlatform win && IsSystemd; } && st dbus # Unable to set up transient service directory

# start SSH before port forwarding (ports check uses SSH)
st sshd ports

# other services - docker cron incron nix
st docker nix

# clock - fix time drift in WSL and major differences when Hyper-V guest resumes
! IsDomainRestricted && IsPlatform wsl && { st time; }

# applications
st WindowManager																		# start first
st dropbox																					# shared
st AutoHotKey UltraMon															# win
st alfred alttab moom rectangle shottr || return		# mac

IsPlatform parallels && { drive mount all --no-optical || return; }

# time synchronization - run last, can fail
st chrony

return 0
