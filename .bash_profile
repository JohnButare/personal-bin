# ~/.bash_profile, user specific login initialization

# Non-login startup script (BASH runtime control)
[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

# QNAP Docker
[[ -d /share/CACHEDEV1_DATA/.qpkg/container-station/bin ]] && PathAdd "/share/CACHEDEV1_DATA/.qpkg/container-station/bin"

