# ~/.bashrc bash interactive shell intialization, from /etc/defaults/etc/skel/.bashrc
# "mintty" and "ssh <script>" do not call .bash_profile, so most setup is here

#[[ "$-" == *i* ]] && echo "Running ~/.bashrc..."

#
# debug
#

#export BASH_DEBUG="yes"
[[ "$-" != *i* && $BASH_DEBUG ]] && echo 'BASH_DEBUG: in  ~/.bashrc'

#
# Global Variables (available in child processes and scripts)
#

set -a
USERS="/home"
PUB="$USERS/Public"
BIN="$PUB/Documents/data/bin"
P="$P64"
P32="/Program Files (x86)"
P64="/Program Files"
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
# Interactive Shell Initialization
#

# Return if not interactive
[[ "$-" != *i* ]] && return

[[ $BASH_DEBUG ]] && BASH_STATUS_INTERACTIVE_SHELL="true"

HISTCONTROL=erasedups
shopt -s autocd cdspell cdable_vars extglob

#
# Functions
#
[[ -n "$BIN" && -f "$BIN/function.sh" ]] && . "$BIN/function.sh"

#
# Local Variables (not avalable to child processes or scripts)
#

# locations - cd'able variables ($<var><return or tab>) 
bin="$BIN"
p="$P"
p64="$P64"
p32="$P32"

home="$HOME"
cloud="$home/Dropbox"
code="/Projects"
desktop="$home/desktop"
doc="$home/Documents"
data="$doc/data"
dl="$data/download"
ubin="$data/bin"
#wintmp="$(wtu $tmp)" # tmp not defined in ssh

i="$PUB/Documents/data/install"
pp="/cygdrive/c/ProgramData/Microsoft/Windows/Start Menu/Programs"
up="/cygdrive/c/Users/jjbutare/AppData/Roaming/Microsoft/Windows/Start Menu/Programs"

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
	local user=''; [[ "$(id -un)" != "jjbutare" ]] && user='\u '
	local host="${user}"; IsSsh && host="${user//[[:space:]]/}@\h "
	local git=''; IsFunction __git_ps1 && git='$(__git_ps1 " (%s)")'
	local elevated=''; IsElevated && elevated='*'

	PS1="${elevated}${green}${host}${yellow}${dir}${clear}${git}\$ "
}

SetPrompt
[[ "$PWD" == "/cygdrive/c" ]] && cd ~

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
alias llv='declare -p | egrep -v "\-x"' # ListLocalVars
alias lev='export' # ListExportVars

#
# applications
#

alias chrome='/opt/google/chrome/google-chrome'
alias i='tc install.btm'
alias rdesk='mstsc /f /v:'

#
# media
#

alias gp='tc media.btm get'
alias ms='tc media.btm sync'

#
# portable and backup
#

alias b='tc sudo WigginBackup'
alias be='tc WigginBackup eject'

alias sp='tc portable sync'
alias mp='tc portable merge'
alias ep='tc portable eject'

alias eject='be; ep;'

#
# file management
#

FindAll()
{
	[ $# == 0 ] && { echo No file specified; return; }
	find . -iname $*
}

FindCd()
{
	local dir=$(FindAll $* | head -1)

	if [ -z "$dir" ]; then
		echo Could not find $*
	else
		cde "$dir"
	fi;
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cc='cd ~; cls'
alias cde='CdEcho'
alias del='rm'
alias l='explorer .'
alias md='MkDir'
alias rd='RmDir'

alias d='tc drive'

alias fa='FindAll'
alias fcd='FindCd'

alias dir='cmd /c dir'
alias dirss="ls -1s --sort=size --reverse --human-readable -l" # sort by size
alias dirst='ls -l --sort=time --reverse' # sort by last modification time
alias dirsct='ls -l --time=ctime --sort=time --reverse' # sort by creation  time
 #-l | awk '{ print \$5 \"\t\" \$9 }'

alias la='ls -QAl'
alias ll='ls -Ql'
alias ls='ls -Q --color'
alias lt='ls -QAh --full-time'
alias lsh='file * | egrep "Bourne-Again shell script"'

RoboCopyAll() { RoboCopy /z /ndl /e /w:3 /r:3 "$(utw $1)" "$(utw $2)"; }
RoboCopyDir() { RoboCopyAll "$1" "$2/$(basename "$1")"; }
alias rc='RoboCopyAll'
alias rcd='RoboCopyDir'

#
# edit
#

alias ei='te $BIN/win32/install.btm' # $BIN/install.sh 
alias es='te $BIN/win32/setup.btm' # $BIN/setup.sh 

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
# Windows
#

alias cm='tc os ComputerManagement'
alias dm='tc os DeviceManager'
alias prog='tc os programs'
alias prop='tc os SystemProperties'
alias ResourceMonitor='tc os ResourceMonitor'
alias SystemRestore='tc vss'

#
# wiggin
#

alias wn='start "$cloud/Systems/Wiggin Network Notes.docx"'
alias house='start "$cloud/House/House Notes.docx"'
alias w='start "$cloud/other/wedding/Wedding Notes.docx"'

NasDrive='//butare.net@ssl@5006/DavWWWRoot'
NasDrive() { net use n: '\\butare.net@ssl@5006\DavWWWRoot' /user:jjbutare; }
alias nas:='cd $NasDrive'
alias n:='cd /cygdrive/n'

#
# Development
#

test="$code/test"

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

alias g='git'
alias gith='tc GitHelper.btm'
#alias git='gith git'
alias ge='gith extensions'
alias gi='{ ! IsFunction __git_ps1; } && source /etc/bash_completion && SetPrompt'

alias gg='tc GitHelper gui'
alias ggc='tc GitHelper gui commit'

# git Test
alias gt:='gi; cd "$code/test/git"'

#
# Intel
#

# phone
alias pb="tc lync PersonalBridge"

# locations
ihome="//jjbutare-mobl/john/documents"
ss="$ihome/group/Software\ Solutions"
SsSoftware="//VMSPFSFSCH09/DEV_RNDAZ/Software"

# primary laptop
alias MoblBoot="tc host boot jjbutare-mobl"
alias MoblConnect="tc host connect jjbutare-mobl"
alias MoblSleep="slp jjbutare-mobl"
alias MoblSync="slf jjbutare-mobl"
mdl="//jjbutare-mobl/John/Documents/data/download"

# vpn
alias vpn="tc intel vpn"
alias von="vpn on"
alias voff="vpn off"

# Source Control
alias ssu='mu;au;fru;'
alias ssc='mc;ac;frc;'

# FaSTr
alias fru='svnu RPIAD'
alias frc='svnc RPIAD'

# Magellan
mc="$code/Magellan"
alias mu='svnu Magellan'
alias mc='svnc Magellan'
alias mb='build Magellan/Source/Magellan.sln'
alias mst='svns Magellan'

# Antidote
alias au='svnu Antidote'
alias ac='svnc Antidote'

# Tablet POC
alias albert='rdesk asmadrid-mobl2'
