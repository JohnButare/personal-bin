# ensure bash.bashrc has been sourced
[[ ! $BIN ]] && { BASHRC="/usr/local/data/bin/bash.bashrc"; [[ -f "$BASHRC" ]] && . "$BASHRC"; }

# set the home directory - must be before Powerlevel10k otherwise old directory is displayed
[[ "${(L)PWD}" == (${(L)WINDIR}/system32|${(L)WIN_HOME}|${(L)WIN_ROOT}) ]] && cd

# Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

# theme
ZSH_THEME="johnbutare" # robbyrussell johnbutare powerlevel10k/powerlevel10k
[[ -e ~/.p10k.zsh && -d "$ZSH/custom/themes/powerlevel10k" ]] && ZSH_THEME="powerlevel10k/powerlevel10k"

# plugins - hass-cli
plugins=(git history-substring-search zsh-syntax-highlighting)

# other configuration
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="mm/dd/yyyy"

# Oh My Zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] && . "$ZSH/oh-my-zsh.sh"

# completion
zstyle ':completion:*' known-hosts-files "$DATA/setup/hosts"
InPath consul && complete -o nospace -C /usr/local/bin/consul consul
InPath nomad && complete -o nospace -C /usr/local/bin/nomad nomad
InPath vault && complete -o nospace -C /usr/local/bin/vault vault

# set terminal title after oh-my-zsh.sh
ZSH_THEME_TERM_TAB_TITLE_IDLE="terminal %15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="terminal %n@%m: %~"

# zsh specific aliases
IsPlatform qnap,synology && alias bash="/opt/bin/bash -l"
IsPlatform mac && [[ $HOMEBREW_PREFIX ]] && alias bash="$HOMEBREW_PREFIX/bin/bash -l"

# scripts
[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.p10k.zsh ]] && . ~/.p10k.zsh

return 0

autoload -U +X bashcompinit && bashcompinit
