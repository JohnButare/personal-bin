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

# cleanup orphan Docker completion file
# - prevents ~/oh-my-zsh.sh error if Docker is not running
# - link created when Docker starts
dir="/usr/share/zsh/vendor-completions/_docker"
[[ -L "$dir" && ! -f "$dir" ]] && sudoc rm "$dir"
unset dir

# Oh My Zsh
SourceIfExists "$ZSH/oh-my-zsh.sh" || return

# completion
_allFiles() { compadd $(ls -1); }
zstyle ':completion:*' known-hosts-files "$DATA/setup/hosts"
compdef _allFiles start

# set terminal title after oh-my-zsh.sh - https://github.com/trystan2k/zsh-tab-title
ZSH_THEME_TERM_TAB_TITLE_IDLE="terminal %21<..<%~%<<" # 21 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="terminal %n@%m: %~"

# prompt

function p10k-on-pre-prompt()
{
  local dir="${PROMPT_DIR_STATUS:-show}"
  p10k display '1/left/dir'=$dir
}

chpwd()
{
  local last; GetFileName "$PWD" last
  
  local gitLen=0 anchorLen=0
  if IsGitWorkTree; then
    local anchor="$(GitRoot | GetFileName)" branch="$(GitBranch)"
    ((gitLen = 10 + $#branch))
    [[ "$last" != "$anchor" ]] && ((anchorLen+=$#anchor))
  fi
  
  # determine what have room for
  local dir="show" truncate="truncate_to_unique"

  if (( COLUMNS - $#last - gitLen < 40 )); then
    dir="hide"
    truncate="truncate_to_last"
  elif (( COLUMNS - anchorLen - $#last - gitLen < 40 )); then
    truncate="truncate_to_last"
  fi

  # configure
  #echo "prompt: columns=$COLUMNS pwd=$#PWD last=$#last anchorLen=$anchorLen gitLen=$gitLen dir=$dir truncate=$truncate"
  export PROMPT_DIR_STATUS="$dir"
  [[ "$POWERLEVEL9K_SHORTEN_STRATEGY" == "$truncate" ]] && return
  export POWERLEVEL9K_SHORTEN_STRATEGY="$truncate"; p10k reload
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

#
# Change Password - move here to prevent Windows division by 0 errors starting shell
#

TRAPWINCH () {
  chpwd; p10k-on-pre-prompt
}

return 0
