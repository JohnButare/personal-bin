# ~/.bash_profile, user specific login initialization, template /etc/defaults/etc/skel/.bash_profile

#export BASH_DEBUG="yes"
[[ $BASH_DEBUG ]] && export BASH_STATUS_LOGIN_SHELL_CHILD="true"
[[ $BASH_DEBUG ]] && BASH_STATUS_LOGIN_SHELL="true"
[[ "$-" != *i* && $BASH_DEBUG ]] && echo 'Running ~/.bash_profile...'

# SSH
IsSsh() { [ -n "$SSH_TTY" ] || [ "$(RemoteServer)" != "" ]; }
RemoteServer() { who am i | cut -f2  -d\( | cut -f1 -d\); }
[[ ! IsSsh ]] && SshAgent startup

# Non-login startup script (BASH runtime control)
[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
