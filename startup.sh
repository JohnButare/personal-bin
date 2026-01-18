# cache processes for faster checks below
export CACHED_PROCESSES="$(ProcessList)"

# arguments
a=()
hostname="$(GetHostname)"

# initial setup
st network xserver WindowManager
! IsDomainRestricted && IsPlatform wsl && st time "${a[@]}" # fix time drift in WSL and major differences when Hyper-V guest resumes
! { IsPlatform win && IsSystemd; } && st dbus "${a[@]}"

# applications
st 1Password dropbox OneDrive AnyplaceUSB	"${a[@]}"					# shared
IsPlatform win && st AutoHotKey files QuickLook UltraMon "${a[@]}"
IsPlatform mac && st alfred AltTab bartender moom rectangle shottr "${a[@]}"
IsPlatform parallels && { drive mount all --no-optical || return; }
[[ "$hostname" == @(bl?) ]] && st BgInfo "${a[@]}"

# services
st chrony nix sshd "${a[@]}"
if [[ "$hostname" == @(bl?) ]]; then
	st PodmanDesktop consul nomad "${a[@]}" # guacamole
fi

return 0
