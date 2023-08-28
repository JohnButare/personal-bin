# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ensure bash.bashrc has been sourced
[[ ! $BIN ]] && { BASHRC="/usr/local/data/bin/bash.bashrc"; [[ -f "$BASHRC" ]] && . "$BASHRC"; }

# set the home directory - must be before Powerlevel10k otherwise the old directory is displayed
[[ "${(L)PWD}" == (${(L)WINDIR}/system32|${(L)WIN_HOME}|${(L)WIN_ROOT}) ]] && cd

export ZSH="$HOME/.oh-my-zsh"

# theme
ZSH_THEME="powerlevel10k/powerlevel10k" # robbyrussell johnbutare powerlevel10k/powerlevel10k

# plugins - git hass-cli history-substring-search
plugins=(zsh-syntax-highlighting)

# other configuration
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="mm/dd/yyyy"

# Oh My Zsh
SourceIfExists "$ZSH/oh-my-zsh.sh" || return

# completion
zstyle ':completion:*' known-hosts-files "$DATA/setup/hosts"

# set terminal title after oh-my-zsh.sh - https://github.com/trystan2k/zsh-tab-title
ZSH_THEME_TERM_TAB_TITLE_IDLE="terminal %21<..<%~%<<" # 21 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="terminal %n@%m: %~"

# prompt

function p10k-on-pre-prompt()
{
  emulate -L zsh -o extended_glob
  local dir=${(%):-%~}
  if (( $#dir > 50 )) || [[ -n ./(../)#(.git)(#qN) ]]; then
    p10k display '1/left/dir'=hide '2'=show
  else
    p10k display '1/left/dir'=show '2'=hide
  fi
}

#
# zsh specific aliases
#

# bashl - bash login
alias bashl="bash"
IsPlatform qnap,synology && alias bashl="/opt/bin/bash -l"
IsPlatform mac && [[ $HOMEBREW_PREFIX ]] && alias bashl="$HOMEBREW_PREFIX/bin/bash -l"

#
# scripts
#

[[ -f ~/.bashrc ]] && . ~/.bashrc # SourceIfExists not available yet
SourceIfExists "$HOME/.p10k.zsh" || return

return 0
