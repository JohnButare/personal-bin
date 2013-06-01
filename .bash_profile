# ~/.bash_profile login shell initialization, from /etc/defaults/etc/skel/.bash_profile

[[ "$-" == *i* ]] && echo "Running ~/.bash_profile..."

#
# debug
#

#export BASH_DEBUG="yes"
[[ $BASH_DEBUG ]] && export BASH_STATUS_LOGIN_SHELL_CHILD="true"
[[ $BASH_DEBUG ]] && BASH_STATUS_LOGIN_SHELL="true"
[[ "$-" != *i* && $BASH_DEBUG ]] && echo 'BASH_DEBUG: in  ~/.bash_profile'

# 
# login startup
#
SshAgent startup
[[ -f "$HOME/.ssh/environment" ]] && . "$HOME/.ssh/environment"

#
# Non-login startup script (BASH runtime control)
#
[[ -f "${HOME}/.bashrc" ]] && . "${HOME}/.bashrc"
