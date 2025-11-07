# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source function.sh if needed - don't depend on BIN variable
{ [[ ! $FUNCTIONS ]] || ! declare -f "IsFunction" >& /dev/null; } && { . "/usr/local/data/bin/function.sh" "" || return; }

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

# configure
alias sp10=". $HOME/.p10k.zsh" ep10="e $HOME/.p10k.zsh"

# prompt

SetP10ContextFull() { export PROMPT_CONTEXT_FULL="true"; sp10; }
SetP10ContextMinimal() { unset PROMPT_CONTEXT_FULL; sp10; }

# show full prompt when logged in locally for single board computers
IsZsh && [[ "$HOSTNAME" =~ (bl.*|pi.*|rp.*) ]] && export PROMPT_CONTEXT_FULL="true"

# p10k-on-pre-prompt - run before prompt
function p10k-on-pre-prompt()
{
  local dir="${PROMPT_DIR_STATUS:-show}"
  p10k display '1/left/dir'=$dir
}

# chpwd - directory changed
chpwd()
{
  local last; GetFileName "$PWD" last
  
  # prompt configuration
  NodeConf && PythonConf

  # determine git length
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
# scripts
#
[[ -f ~/.bashrc ]] && . ~/.bashrc # SourceIfExists not available yet
SourceIfExists "$HOME/.p10k.zsh" || return

#
# events
#


lastCheckSeconds="$SECONDS"
networkLastUpdateSeconds="$(GetSeconds)"

# executeCommand - executed before a command is run, allows command modification to update environment
function executeCommand {  

  # periodic checks every 10 seconds
  (( SECONDS - lastCheckSeconds < 10 )) && { zle accept-line; return; }
  lastCheckSeconds="$SECONDS"

  # SSH agent
  ! ssh-add -L >& /dev/null && { BUFFER="SshAgentConf;$BUFFER" }

  # network - check if the network has changed
  if force= UpdateSince "${NETWORK_CACHE:-network}" "$networkLastUpdateSeconds"; then    
    networkLastUpdateSeconds="$(GetSeconds)"
    [[ "$(NetworkCurrent)" != "$(NetworkOld)" ]] && BUFFER="NetworkCurrentConfigShell;$BUFFER"
  fi

  zle accept-line
}

zle -N executeCommandWidget executeCommand
bindkey '^J' executeCommandWidget
bindkey '^M' executeCommandWidget

# preexec - execute before command is run
# preexec()
# {
#   :
# }

# precmd - executed after command is run
# precmd()
# {  
#   :
# }

# TRAPWINCH - executed on window resize
TRAPWINCH () {
  chpwd; p10k-on-pre-prompt
}

return 0
