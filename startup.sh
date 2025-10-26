# cache processes for faster checks below
export CACHED_PROCESSES="$(ProcessList)"

# initial setup
st network xserver WindowManager
! IsDomainRestricted && IsPlatform wsl && st time # fix time drift in WSL and major differences when Hyper-V guest resumes
! { IsPlatform win && IsSystemd; } && st dbus

# applications
st 1Password dropbox OneDrive AnyplaceUSB						# shared
st AutoHotKey UltraMon															# win
st alfred AltTab bartender moom rectangle shottr		# mac
IsPlatform parallels && { drive mount all --no-optical || return; }
[[ "$HOSTNAME" == @(bl?) ]] && st BgInfo

# services
st chrony nix sshd
[[ "$HOSTNAME" == @(bl?) ]] && st docker consul nomad guacamole

return 0
