# ~/.bashrc bash interactive shell intialization, from /etc/defaults/etc/skel/.bashrc
# "mintty" and "ssh <script>" do not call .bash_profile, so most setup is here

[[ "$-" == *i* ]] && echo "Running ~/.bashrc..."

#
# debug
#

#export BASH_DEBUG="yes"
[[ "$-" != *i* && $BASH_DEBUG ]] && echo 'BASH_DEBUG: in  ~/.bashrc'

#
# Variables
#

set -a
users="/home"
pub="$users/Public"
BIN="$pub/Documents/data/bin"
p32="/Program Files (x86)"
p64="/Program Files"
p="$p64"
set +a

#
# TEMP Directory
#

# Set temp directory to correct format for unix (TMP/TEMP) or Windows (tmp/temp).  

if [[ "$TMP" != "/tmp"  ]]; then
	export tmp=$(cygpath -w "$TMP" 2> /dev/null)
	export temp=$(cygpath -w "$TEMP" 2> /dev/null)
	export TMP="/tmp"
	export TEMP="/tmp"
fi;

#
# Path
#

PathAdd() # PathAdd <path> [front], front adds to front and drops duplicates in middle
{
	if [[ "$2" == "front" ]]; then
		PATH=$1:${PATH//:$1:/:}
	elif [[ ! $PATH =~ (^|:)$1(:|$) ]]; then
    PATH+=:$1
  fi
}

# /usr/bin and /usr/local/bin must be first in the path so Cygwin utilities are used
# before Microsoft utilities, /etc/profile adds them first, but profile is not
# called by "ssh <script>.sh
PathAdd "/usr/bin" "front"
PathAdd "/usr/local/bin" "front"

#
# Interactive Shells
#

[[ "$-" != *i* ]] && return
[[ $BASH_DEBUG ]] && BASH_STATUS_INTERACTIVE_SHELL="true"

HISTCONTROL=erasedups
shopt -s autocd cdspell cdable_vars extglob

#
# Variables
#

home="$HOME"
doc="$home/Documents"
data="$doc/data"
ubin="$data/bin"
cloud="$home/Dropbox"

code="/Projects"

#
# Functions
#
[[ -n "$BIN" && -f "$BIN/function.sh" ]] && . "$BIN/function.sh"

#
# SSH
#
[[ -f "$HOME/.ssh/environment" ]] && . "$HOME/.ssh/environment"

#
# prompt
#

GetPrompt()
{
	if [[ "$PWD" == "$HOME" ]]; then
		echo '~'
	elif [[ ${#PWD} > 20 ]]; then
		local tmp=${PWD%/*/*};
		[ ${#tmp} -gt 0 -a "$tmp" != "$PWD" ] && echo ${PWD:${#tmp}+1} || echo $PWD;
	else
		echo $PWD
	fi;
}

SetPrompt() 
{
	local green='\[\e]0;\w\a\]\[\e[32m\]'
	local yellow='\[\e[33m\]'
	local clear='\[\e[0m\]'
	local dir='$(GetPrompt)'
	#local dir='\[\e[33m\]\w\[\e[0m\]'
	local user=''; [[ "$USER" != "jjbutare" ]] && user='\u '
	local host="${user}"; IsSsh && host="${user//[[:space:]]/}@\h "
	local git=''; IsFunction __git_ps1 && git='$(__git_ps1 " (%s)")'
	local elevated=''; IsElevated && elevated='*'

	PS1="${elevated}${green}${host}${yellow}${dir}${clear}${git}\$ "
}

SetPrompt

#
# completion
#
alias EnableCompletion='source /etc/bash_completion; SetPrompt'

#
# utility
#

alias cf='tc CleanupFiles.btm'
alias cls=clear
alias e='TextEdit'
alias FileInfo='tc FileInfo.btm'
alias te='TextEdit'
alias slf='tcc /c SyncLocalFiles.btm'
alias unexport='unset'
alias update='tc os.btm update'

#
# applications
#

alias chrome='/opt/google/chrome/google-chrome'

#
# directory and file management
#
alias l='explorer .'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cc='cd ~; cls'
alias cde='CdEcho'
alias del='rm'
alias la='ls -QAl'
alias ll='ls -Ql'
alias ls='ls -Q --color'
alias lt='ls -QAh --full-time'
alias md='MkDir'
alias rd='RmDir'

alias dirss="ls -1s --sort=size --reverse --human-readable -l" # sort by size
alias dirst='ls -l --sort=time --reverse' # sort by last modification time
alias dirsct='ls -l --time=ctime --sort=time --reverse' # sort by creation  time
 #-l | awk '{ print \$5 \"\t\" \$9 }'

alias lsh='file * | egrep "Bourne-Again shell script"'


#
# locations
#

alias dl:='cd $data/download'
alias p:='cd "$p"'
alias p32:='cd "$p32"'
alias bin:='cd $BIN'
alias mbin:='cd "$BIN/mac"'
alias lbin:='cd $BIN/linux'
alias w32:='cd "$BIN/win32"'
alias w64:='cd $BIN/win64'

alias pub:='cd $users/Public'
alias doc:='cd $doc'
alias home:='cd $home'
alias ubin:='cd $ubin'
alias desktop:='cd "$home/desktop"'
alias cloud:='cd "$cloud"'

alias code:='cd "$code"'

alias pp:='cd "/cygdrive/c/ProgramData/Microsoft/Windows/Start Menu/Programs"'
alias up:='cd "/cygdrive/c/Users/jjbutare/AppData/Roaming/Microsoft/Windows/Start Menu/Programs"'

alias WinTmp:='cd $(wtu $tmp)'

#
# edit
#

alias ei='te $BIN/install.sh $BIN/win32/install.btm'
alias es='te $BIN/setup.sh $BIN/win32/setup.btm'

# Bash
alias sa='. ~/.bashrc'
alias ea='te $ubin/.bashrc'

alias sf='. ~/.bashrc'
alias ef='te $BIN/function.sh'

alias bstart='source ~/.bash_profile; bind -f ~/.inputrc;'
alias estart='te /etc/profile /etc/bash.bashrc $ubin/.bash_profile $ubin/.bashrc'

alias ebo='te $ubin/.minttyrc $ubin/.inputrc /etc/bash.bash_logout $ubin/.bash_logout'

alias e4a='te $ubin/alias.tc'

# Autohotkey
alias ek='te $ubin/keys.ahk'
alias sk='tc AutoHotKey.btm restart'

# Startup
alias st='startup.sh'
alias es='te $BIN/startup.sh'

#
# find
#
alias fa='FindAll'
alias fcd='FindCd'

#
# archive
#

alias fm='start "$p/7-Zip/7zFM.exe"'

#
# power management
#

alias slp='tc power.btm sleep'

#
# network
#

alias SshKey='ssh-add ~/.ssh/id_dsa'
alias sk='SshKey'
alias rs='RemoteServer'

#
# wiggin
#

alias wn='start "$cloud/Systems/Wiggin Network Notes.docx"'
alias house='start "$cloud/House/House Notes.docx"'

NasDrive='//butare.net@ssl@5006/DavWWWRoot'
NasDrive() { net use n: '\\butare.net@ssl@5006\DavWWWRoot' /user:jjbutare; }
alias nas:='cd $NasDrive'
alias n:='cd /cygdrive/n'

#
# .NET Development
#

alias n='tc .net.btm'
build() { n MsBuild /verbosity:minimal /m "$(utw $code/$1)"; }
BuildClean() { n MsBuild /t:Clean /m "$(utw $code/$1)"; }
alias vs='tc VisualStudio.btm'

#
# Source Control
# 

alias tsvn='tc TortoiseSVN.btm'
alias svn='tsvn svn'
alias svnu='tsvn code update'
alias svnsw='tsvn code switch'
alias svnl='tsvn code log'
alias svnc='tsvn code commit'
alias svns='tsvn code status'

alias gith='tc GitHelper.btm'
#alias git='gith git'
alias ge='gith extensions'
alias gi='{ ! IsFunction __git_ps1; } && source /etc/bash_completion && SetPrompt'

# git Test
alias gt:='gi; cd "$code/test/git"'

#
# Intel
#

alias MoblBoot="tc host boot jjbutare-mobl"
alias MoblConnect="tc host connect jjbutare-mobl"
alias MoblSleep="slp jjbutare-mobl"
alias MoblSync="slf jjbutare-mobl"

# Software Solutions Group
alias ssu='mu;au;fru;'
alias ssc='mc;ac;frc;'

# FaSTr
alias fru='svnu RPIAD'
alias frc='svnc RPIAD'

# Magellan
alias mu='svnu Magellan'
alias mc='svnc Magellan'

# Antidote
alias au='svnu Antidote'
alias ac='svnc Antidote'
