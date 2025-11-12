# cache processes for faster checks below
export CACHED_PROCESSES="$(ProcessList)"

# arguments
a=()

# initial setup
st network xserver WindowManager
! IsDomainRestricted && IsPlatform wsl && st time "${a[@]}" # fix time drift in WSL and major differences when Hyper-V guest resumes
! { IsPlatform win && IsSystemd; } && st dbus "${a[@]}"

# applications
st 1Password dropbox OneDrive AnyplaceUSB	"${a[@]}"					# shared
st AutoHotKey UltraMon "${a[@]}"													 	# win
st alfred AltTab bartender moom rectangle shottr "${a[@]}" 	# mac
IsPlatform parallels && { drive mount all --no-optical || return; }
[[ "$HOSTNAME" == @(bl?) ]] && st BgInfo "${a[@]}"

# services
st chrony nix sshd "${a[@]}"
if [[ "$HOSTNAME" == @(bl?) ]]; then
	st docker consul nomad guacamole "${a[@]}"
fi

return 0
