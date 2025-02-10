# cache processes for faster checks below
export CACHED_PROCESSES="$(ProcessList)"

# ensure network configure is correct first
st network

# desktop background
[[ "$HOSTNAME" == @(bc|bl?) ]] && st BgInfo


# start X Server and D-Bus (for credentials)
st xserver
! { IsPlatform win && IsSystemd; } && st dbus # Unable to set up transient service directory

# other services - docker cron incron nix ssh ports (ports check uses SSH)
[[ "$HOSTNAME" == @(bl?) ]] && st docker consul nomad

# guacamole
[[ "$HOSTNAME" == "bl3" ]] && { docker start 02ecdca0f8f8 94fee2880bdd > /dev/null; }
[[ "$HOSTNAME" == "bl4" ]] && { docker start 61ed050aca17 9086d94e43bd > /dev/null; }

st nix sshd

# clock - fix time drift in WSL and major differences when Hyper-V guest resumes
! IsDomainRestricted && IsPlatform wsl && { st time; }

# applications
st WindowManager													# start first
st 1Password dropbox OneDrive AnyplaceUSB	# shared
st AutoHotKey UltraMon										# win
st alfred AltTab moom rectangle shottr		# mac

IsPlatform parallels && { drive mount all --no-optical || return; }

# time synchronization - run last, can fail
st chrony
