# set the home directory - must be before Powerlevel10k otherwise old directory is displayed
[[ "$1" != "update" && "${(L)PWD}" == (${(L)WINDIR}/system32|${(L)WIN_HOME}|${(L)WIN_ROOT}) ]] && cd

# Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

# theme
ZSH_THEME="johnbutare" # robbyrussell johnbutare powerlevel10k/powerlevel10k
[[ -e ~/.p10k.zsh && -d "$ZSH/custom/themes/powerlevel10k" ]] && ZSH_THEME="powerlevel10k/powerlevel10k"

# plugins
plugins=(git)

# other configuration
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="mm/dd/yyyy"

# Oh My Zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] && . "$ZSH/oh-my-zsh.sh"

# completion
zstyle ':completion:*' known-hosts-files "$UBIN/hosts"

_fzf_complete_ssh() { _fzf_complete +m -- "$@" < <(command cat "$UBIN/hosts" 2> /dev/null); }
_fzf_complete_ping() { _fzf_complete +m -- "$@" < <(command cat "$UBIN/hosts" 2> /dev/null); }

# set terminal title after oh-my-zsh.sh
ZSH_THEME_TERM_TAB_TITLE_IDLE="terminal %15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="terminal %n@%m: %~"

# zsh specific aliases
IsPlatform qnap && alias bash="/opt/bin/bash -l"
IsPlatform mac && alias bash="/usr/local/bin/bash -l"

# scripts
[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.p10k.zsh ]] && . ~/.p10k.zsh
