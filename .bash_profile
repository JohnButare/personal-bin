# ~/.bash_profile, user specific login initialization

# SSH
IsSsh() { [ -n "$SSH_TTY" ] || [ "$(RemoteServer)" != "" ]; }
RemoteServer() { who am i | cut -f2  -d\( | cut -f1 -d\); }
! IsSsh && { SshAgent startup; eval  "$(SshAgent initialize)"; }

# Non-login startup script (BASH runtime control)
[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
