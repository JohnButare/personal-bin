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

# zsh specific aliases
IsPlatform qnap,synology && alias bash="/opt/bin/bash -l"
IsPlatform mac && [[ $HOMEBREW_PREFIX ]] && alias bash="$HOMEBREW_PREFIX/bin/bash -l"

# scripts
[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.p10k.zsh ]] && . ~/.p10k.zsh

return 0
