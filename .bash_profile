
# ~/.bash_profile, user specific login initialization

# Non-login startup script (BASH runtime control)
[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

