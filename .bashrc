# ~/.bashrc, user specific interactive intialization, and non-interactive ("mintty" and "ssh <script>")

# interactive initialization - remainder not needed in child processes or scripts
[[ "$-" != *i* ]] && return

# sytem-wide configuration - if not done in /etc/bash.bashrc
if [[ ! $BIN ]]; then
	[[ "$-" == *i* ]] && echo ".bashrc: system configuration was not set in /etc/bash.bashrc" > /dev/stderr
	[[ -f /usr/local/data/bin/bash.bashrc ]] && . "/usr/local/data/bin/bash.bashrc"
fi

# non-interactive initialization (available from child processes and scripts)
set -a
LESS='-R'
LESSOPEN='|~/.lessfilter %s'
#IGNOREEOF=1
set +a

# interactive initialization - remainder not needed in child processes or scripts
[[ "$-" != *i* ]] && return

# history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s autocd cdspell cdable_vars dirspell histappend direxpand globstar

# completion - win
if [[ -f "/usr/share/bash-completion/completions/git" ]] && ! IsFunction __git_ps1; then
	. "/usr/share/bash-completion/completions/git"
	. "$BIN/git-prompt.sh"
fi

#__git_eread
#

# completion - mac
d="/usr/local/etc/bash_completion.d"
if [[ -f "$d/git-prompt.sh" ]] && ! IsFunction __git_ps1; then
	. "$d/git-prompt.sh"
	. "$d/git-completion.bash"
	. "$d/hub.bash_completion.sh"
	. "$d/tig-completion.bash"
fi
unset d

# completion - generic
complete -r cd >& /dev/null # cd should not complete variables without a leading $

#
# locations - lower case (not exported), for cd'able variables ($<var><return or tab>) 
#

p="$P" p32="$P32" win="$DATA/platform/win" sys="/cygdrive/c" pub="$PUB" bin="$BIN" data="$DATA"
psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" # PublicStartMenu
pp="$psm/Programs" # PublicPrograms
pd="$pub/Desktop" # PublicDesktop
i="$data/install" # install
v="/Volumes"

# user

home="$HOME" doc="$DOC" udoc="$DOC" udata="$udoc/data"
bash="$udata/bash"
code="$CODE"; c="$CODE"
[[ "$COMPUTERNAME" == @(jjbutare-ivm1) ]] && dl="//psf/Home/downloads" || dl="$HOME/Downloads"
ubin="$udata/bin"
usm="$APPDATA/Microsoft/Windows/Start Menu" #UserStartMenu
up="$usm/Programs" # UserPrograms
ud="$home/Desktop" # UserDesktop
db="$home/Dropbox"; cloud="$db"; c="$cloud"; cdata="$cloud/data"; cdl="$cdata/download"
alias p='"$p"' p32='"$p32"' pp='"$pp"' up='"$up"' usm='"$usm"'

#
# applications
#
alias e='edit'
alias s="start"
alias te='TextEdit'

alias autoruns='start autoruns.exe'
alias AutoItDoc="start $pdata/doc/AutoIt.chm"
alias bc='BeyondCompare'
alias cctray='CruiseControlTray'
alias chrome='chrome' # /opt/google/chrome/google-chrome
alias ed='explorer microsoft-edge://'
alias f='firefox'
alias h='HostUtil'
alias ie='InternetExplorer'
alias m='merge'
alias npp='notepadpp start'
alias powershell="$WINDIR/system32/WindowsPowerShell/v1.0/powershell.exe"
alias rdesk='cygstart mstsc /f /v:'
alias vm='VMware'
alias wmp='start "$P32\Windows Media Player\wmplayer.exe"'
alias wmc='WindowsMediaCenter'
alias wmic="$WINDIR/system32/wbem/WMIC.exe"

alias grep='\grep --color=auto'
alias egrep='\egrep --color=auto'

alias nruby='/usr/local/opt/ruby/bin/ruby'
alias unruby='export PATH="/usr/local/opt/ruby/bin:$PATH"' # use new ruby

export LPASS_AGENT_TIMEOUT=0

#
# misc
#

alias cf='CleanupFiles'
alias cls=clear

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#
# archive
#

alias fm='start "$p/7-Zip/7zFM.exe"'
alias untar='tar -v -x --atime-preserve <'
z7bak() { [[ $# == 1  ]] && 7z a -m1=LZMA2 "$1.7z" "$1" || 7z a -m1=LZMA2 "$1" "${@:2}"; }
zbak() { local z="zip -r"; [[ "$PLATFORM" == "win" ]] && z="7z.exe a"
	[[ $# == 1  ]] && eval $z "$1.zip" "$1" || eval $z "$1" "${@:2}"; }
zrest() { [[ "$PLATFORM" == "win" ]] && 7z.exe x "${@}"|| unzip "${@}"; }
zls() { [[ "$PLATFORM" == "win" ]] && 7z.exe l "${@}" || unzip -l "${@}"; }
zll() { [[ "$PLATFORM" == "win" ]] && 7z.exe l -slt "${@}" || unzip -ll "${@}"; }

#
# variables and functions
#

alias ListVars='declare -p | egrep -v "\-x"'
alias ListExportVars='export'
alias ListFunctions='declare -F'
alias ListFunctionsAll='declare -f'
alias unexport='unset'
alias unfunction='unset -f'

#
# performance
#

alias t='time pause'
alias ton='TimerOn'
alias toff='TimerOff'

#
# file management
#

alias cd='UncCd'
alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'
alias .....='cbuiltin d ../../../..'
alias c='cls'		# clear screen
alias cb='builtin cd ~; cls' # clear screen and cd
alias del='rm'
alias md='mkdir'
alias rd='rmdir'
alias wln='start --direct "$BIN/win/ln.exe"' # Windows ln

UncCd()
{
	[[ "$PLATFORM" == "win" ]] || ! IsUncPath "$1" && { builtin cd "$@"; return; }
	[[ ! "$(GetUncShare "$1")" ]] && { unc list "$1"; return; }
	ScriptCd unc mount "$1" || return
}

UncLs()
{
	local unc="${@: -1}"
	
	if [[ "$PLATFORM" == "win" ]] || ! IsUncPath "$unc"; then
		command ${G}ls --hide={desktop.ini,NTUSER.*,ntuser.*} -F -Q --group-directories-first --color "$@"
		return
	fi

	[[ ! "$(GetUncShare "$unc")" ]] && { unc list "$unc"; return; }
	local dir; dir="$(unc mount "$unc")" || return
	${G}ls --hide={desktop.ini,NTUSER.*,ntuser.*} -F --group-directories-first -Q --group-directories-first --color "${@:1:$#-1}" "$dir"
}

alias inf="FileInfo"
alias l='explore'
alias rc='CopyDir'

#
# list
#

alias ls='UncLs'									# list 
alias la='UncLs -Al'							# list all
alias ll='UncLs -l'								# list long
alias llh='UncLs -d .*'						# list long hidden
alias lh='UncLs -d .*' 						# list hiden
alias lt='UncLs -Ah --full-time'	# list time

alias dir='cmd /c dir'
alias dirss="UncLs -1s --sort=size --reverse --human-readable -l" # sort by size
alias dirst='UncLs -l --sort=time --reverse' # sort by last modification time
alias dirsct='UncLs -l --time=ctime --sort=time --reverse' # sort by creation  time
 #-l | awk '{ print \$5 \"\t\" \$9 }'

#
# find
#

alias fa='FindAll'
alias fcd='FindCd'
alias fs='FindStart'
alias ft='FindText'
fclip() { IFS=$'\n' files=( $(FindAll "$1") ) && clipw "${files[@]}"; } # FindClip
fe() { IFS=$'\n' files=( $(FindAll "$1") ) && [[ ${#files[@]} == 0 ]] && return; TextEdit "${files[@]}"; } # FindAllEdit
fte() { IFS=$'\n' files=( $(FindText "$@" | cut -d: -f1) ) && [[ ${#files[@]} == 0 ]] && return; TextEdit "${files[@]}"; } # FindTextEdit

fsql() { ft "$1" "*.sql"; } # FindSql TET
esql() { fte "$1" "*.sql"; } # EditSql TEXT
fsqlv() { fsql "-- version $1"; } # FindSqlVersion [VERSION]
esqlv() { esql "-- version $1"; } # EditSqlVersion [VERSION]
msqlv() { fsqlv | cut -f 2 -d : | cut -f 3 -d ' ' | egrep -i -v "deploy|skip|ignore|NonVersioned" | sort | tail -1; } # MaxSqlVersion

alias ftd="egrep --color -r --binary-files=without-match -e 'TODO:' --exclude={*.idt,*.jpg,*.png} --exclude-dir={.git,bin,Bin,Components,Libraries,obj,packages} --include=. | egrep -v 'find and remove all TODO'" # Find TODO text
eai() { fte "0.0.0.0" "VersionInfo.cs"; } # EditAssemblyInfo that are set to deploy (v0.0.0.0)

FindText() # TEXT FILE_PATTERN [START_DIR](.)
{ 
	local startDir="${@:3}"
	egrep --color -i -r -e "$1" --include=$2 "${startDir:-.}"
}

FindAll()
{
	[[ $# == 0 ]] && { echo "No file specified"; return; }
	find . -iname "$@" |& egrep -v "Permission denied"
}

FindStart()
{
	start "$(FindAll "$@" | head -1)";
}

FindCd()
{
	local file="$(FindAll "$@" | head -1)"
	local dir="$(GetFilePath "$file")"

	if [ -d "$dir" ]; then
		cd "$dir"
	else
		echo Could not find directory "$@"
	fi;
}

#
# drives
#

alias d='drive'
alias de='drive eject'
alias dl='drive list'
alias dr='drive list | egrep -i removable'

#
# disk usage
#

alias duh='${G}du --human-readable'
alias ds='DirSize m'
alias dsu='DiskSpaceUsage'
alias dus='${G}du --summarize --human-readable'
alias TestDisk='sudo bench32.exe'

#
# package management
#

IsPlatform win && alias apt-get='apt-cyg'
IsPlatform mac && alias apt-get='brew'

#
# edit/set
#

alias ei='te $bin/inst'
alias ehp='edit "$udata/replicate/default.htm"'

# Bash (aliases, functions, startup, other)

startupFiles="/etc/profile /etc/bash.bashrc $BIN/bash.bashrc $UBIN/.bash_profile $UBIN/.bashrc"
IsPlatform mac && startupFiles+="/etc/bashrc"

alias sa='. ~/.bashrc'
alias ea='te $ubin/.bashrc'

alias ef='te $bin/function.sh'
alias sf='. function.sh'

alias kstart='bind -f ~/.inputrc'
alias ek='te ~/.inputrc'

alias bstart='. "$bin/bash.bashrc"; . ~/.bash_profile; kstart;'
alias estart="te $startupFiles"

alias ebo='te $ubin/.minttyrc $ubin/.inputrc /etc/bash.bash_logout $ubin/.bash_logout'

alias ahk='AutoHotkey'
alias ahkr='ahk restart'

# Startup
alias st='startup'

# host file
alias ehosts='HostUtil file edit'
alias uhosts='HostUtil file update'

#
# media
#

alias gp='media get'
alias sm='merge "$pub/Music" "//nas/music"'
alias sk='SyncKey'

alias et='exiftool'
alias etg='start exiftoolgui' # ExifToolGui

#
# X Windows
#

# set the X DISPLAY if not set and X is installed (in /usr/bin/XWin for Cygwin)
[[ ! "$DISPLAY" && -f /usr/bin/XWin ]] && export DISPLAY=:0

#
# ssh
#

[[ ! -f "$SSH_AGENT_AUTH_SOCK" ]] && SshAgent startup && eval "$(SshAgent initialize)"

sshfull() { ssh -t $1 "source /etc/profile; ${@:2}";  } # connect with a full environment, i.e. sshfull nas2 power shutdown
sshsudo() { ssh -t $1 sudo ${@:2}; }

alias ssht='ssh -t' # connect and allocate a pseudo-tty for screen based programs like sudo, i.e. ssht sudo ls /
alias sshx='ssh -Y'; alias sx=sshx; # connect with X forward
alias sshf='SshFix'
alias sshf='sshfull'
alias SshKey='ssh-add ~/.ssh/id_dsa'

RemoteServerName() { nslookup "$(RemoteServer)" | grep "name =" | cut -d" " -f3; }
SshShow() { IsSsh && echo "Logged in from $(RemoteServerName)" || echo "Not using ssh";}
SshFix() { SshAgent fix || return; ScriptEval SshAgent initialize; }

#
# network
#

[[ "$PLATFORM" == "win" ]] && alias dig="\"$P/dig/bin/dig.exe\""
alias hu='HostUtil'
alias ipc='network ipc'
alias slf='SyncLocalFiles'
alias FindSyncTxt='fa .*_sync.txt'
alias RemoveSyncTxt='FindSyncTxt | xargs rm'

nu() { net use "$(ptw "$1")" "${@:2}"; } # NetUse

#
# portable and backup
#

alias b='sudo WigginBackup'
alias be='WigginBackup eject'

alias sp='portable sync'
alias mp='portable merge'
alias ep='portable eject'

alias eject='be; ep;'

#
# prompt
#

alias SetBashGitPrompt='source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"'

GitPrompt()
{
	local gitColor red='\e[31m'
	unset GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWUNTRACKEDFILES GIT_PS1_SHOWUPSTREAM

	if [[ "$PLATFORM" == "Win" ]]; then # basic prompt - git is slow on windows
		[[ -d .git ]] || return
		#gitColor="$(gw status --porcelain 2> /dev/null | egrep .+ > /dev/null && echo -ne "$red")"
		#__git_ps1 "$gitColor (%s)"	
		echo "$gitColor ($(git rev-parse --abbrev-ref HEAD))"
		return 
	fi

	gitColor="$(gw status --porcelain 2> /dev/null | egrep .+ > /dev/null && echo -ne "$red")"
	GIT_PS1_SHOWUPSTREAM="auto verbose"; 
	GIT_PS1_SHOWDIRTYSTATE="true" # shows *
	GIT_PS1_SHOWSTASHSTATE="true"	 # shows $
	GIT_PS1_SHOWUNTRACKEDFILES="true" # shows %
	__git_ps1 "$gitColor (%s)"
}

SetPrompt() 
{
	local cyan='\[\e[36m\]'
	local clear='\[\e[0m\]'
	local green='\[\e[32m\]'
	local red='\[\e[31m\]'
	local yellow='\[\e[33m\]'

	local dir='\w' user='\u'
	local git; IsFunction __git_ps1 && git='$(GitPrompt)'
	local elevated; IsElevated && elevated='*'
	local pwd="\[\e]0;\w\a\]"; # forces the directgory in TMUX status line to update

	host="${HOSTNAME#$USER-}"; host="${host%%.*}" # remove the username freom the hostname to shorten it
	[[ "$USER" != "jjbutare" ]] && host+="@\u" 		# add the username if it is not me (i.e. root)

	# dir='$(GetPrompt)'; user=''; [[ "$(id -un)" != "jjbutare" ]] && user='\u '
	# PS1="${elevated}${green}${host}${yellow}${dir}${clear}${cyan}${gitColor}${git}${clear}\$ "

	# use a multi-line prompt with directory unless using tmux (which cotnains the directory in the status area)
	if [[ $TMUX ]]; then
	 	PS1="${pwd}${green}${host}${red}${elevated}${clear}${cyan}${git}${clear}\$ "
	else
		PS1="${pwd}\n${green}${host}${red}${elevated} ${yellow}${dir}${clear}${cyan}${git}\n${clear}\$ "
	fi
	
	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -r' 
}

SetPrompt
[[ "$PWD" == @(/cygdrive/c|/usr/bin) ]] && cd ~
[[ $SET_PWD ]] && { cd "$SET_PWD"; unset SET_PWD; }


#
# Source Control
# 

# code

alias cdc='code commit --gui'
alias cdl='code log'
alias cdr='code revert --gui'
alias cds='code status'
alias cdco='code checkout'
alias cdup='code update'

# git

alias g='git' gc=g gw=g # platform specific git (Cygwin, Git for Windows)
[[ "$PLATFORM" == "win" ]] && alias gc='/usr/bin/git' gw='"$P/Git/cmd/git.exe"'	g='gw'

#alias g='git'
alias gd='gc diff'
alias gf='gc freeze'
alias gl='g l'
alias gca='g ca'
alias gs='g s' 		# status
alias gbs='g bs'	# branch status [PATTERN]
alias gr='g rb' 	# rebase
alias gr1='g rb HEAD~1 --onto' 	# rebase first commit onto specified branch
alias gri='g rbi' 	# rebase interactive
alias gria='g rbia' # rebase interactive auto, rebase all fixup! commits
alias grc='g rbc' 	# rebase continue
alias grf='g rf' 	# create a rebase fixup commit
alias grs='g rsq' 	# create a rebase squash commit
alias gmt='g mergetool'
alias gp='g push'
alias gpf='g push --force'		# push force
alias grft='grf && g i Test' 	# fixup commit and push to test
alias grfpp='grf && g i Pre-Production' # fixup commit and push to pre-production

alias ge='g status --porcelain=2 | cut -f9 -d" " | xargs edit' # git edit modified files

alias eg='te ~/.gitconfig'
alias gg='GitHelper gui'
alias gh='GitHelper'
alias ghub='GitHelper hub'
alias tgg='GitHelper tgui'

complete -o default -o nospace -F _git g

#
# scripts
#

alias scd='ScriptCd'
alias se='ScriptEval'

alias slist='file * .* | FilterShellScript | cut -d: -f1'
alias sfind='slist | xargs egrep'
sfindl() { sfind --color=always "$1" | less -R; }
alias sedit='slist | xargs RunFunction.sh TextEdit'
alias slistapp='slist | xargs egrep -i "IsInstalledCommand\(\)" | cut -d: -f1'
alias seditapp='slistapp | xargs RunFunction.sh TextEdit'
sstat() { echo "****** bin ******"; gh status "$bin"; echo -e "\n****** ubin ******"; gh status "$ubin"; }
sdiff() { echo "****** bin ******"; gh diff "$bin"; echo -e "\n****** ubin ******"; gh diff "$ubin"; }
sgg() { gh gui "$bin"; gh gui "$ubin"; }

# script (bin and ubin) - Update/Commit/Status/Save
scup() { cd "$bin" && git up && cd "$ubin" && git up; }
scpush() { cd "$bin" && git push "$@" && cd "$ubin" && git push "$@"; }
scpull() { cd "$bin" && git pull --rebase "$@" && cd "$ubin" && git pull --rebase "$@"; }
scc() { gh commitg "$ubin"; gh commitg "$bin"; }
scs() { gh status "$bin"; gh status "$ubin"; }
scsave() { local m="script changes from $COMPUTERNAME${1+: $1}"; gu "$bin" "$m" || return; gu "$ubin" "$m"; }

#
# Node.js
#
alias node='\node --use-strict'
alias npmls='npm ls --depth=0'

#
# power management
#

alias boot='HostUtil boot'
alias bw='HostUtil boot wait'
alias connect='HostUtil connect'
alias hib='power hibernate'
alias down='power shutdown'
alias reb='power reboot'
alias slp='power sleep'

#
# process
#

ParentProcessName() {  cat /proc/$PPID/status | head -1 | cut -f2; }
alias NumProcs='cat /proc/cpuinfo | grep processor | wc -l'
IsPlatform win && alias htop="top"

# 
# windows
#
alias WindowSpy="Au3Info.exe &"

#
# sound
#

playsound() { case "$PLATFORM" in win) cat "$1" > /dev/dsp;; mac) afplay "$1";; esac; }
alias sound='os sound'
alias TestSound='playsound "$data/setup/test.wav"'

#
# Operating System
#

if IsPlatform win; then
	alias apps='explorer shell:AppsFolder'
	alias cm='start CompMgmt.msc'
	alias credm='start control /name Microsoft.CredentialManager'
	alias dm='start DevMgmt.msc'
	alias ev='start eventvwr.msc'
	alias prog='product gui'
	alias prop='os SystemProperties'
	alias SystemRestore='vss'

	alias ws='wscript /nologo'
	alias cs='cscript /nologo'
fi

#
# wiggin
#

# NAS

nas='//nas1'
ni="$nas/public/documents/data/install"
nr='//butare.net@ssl@5006/DavWWWRoot'
ng='git@butare.net:/volume1/git'

alias NasDown='ssh nas1 poweroff; ssh nas2 poweroff'
alias nussh='ssh nas1 "chmod 700 /volume1/homes/$user/.ssh; chmod 644 /volume1/homes/$user/.ssh/authorized_keys"  || return' # NAS update SSH
alias ned='NasEditDns'; alias NasEditDns="e ~/Dropbox/systems/nas/dns/1.168.192.in-addr.arpa ~/Dropbox/systems/nas/dns/hagerman.butare.net ~/Dropbox/systems/nas/dns/dhcpd-eth0-static.conf" # NAS edit DHCP and DNS
alias nud='NasUpdateDhcp'; alias nbd='NasBackupDhcp'
alias nudns='NasUpdateDns';
alias ncc='NasCopyConfig'; NasCopyConfig() { scp "nas1:/etc/dhcpd/dhcpd-eth0-"*".conf" "nas1:/var/packages/DNSServer/target/named/etc/zone/master/*" ~/"Dropbox/systems/nas/dns/copy"; } # NAS copy (backup) configuration

NasUpdateDns() 
{
	local f=~/"Dropbox/systems/nas/dns/"
	scp "$f/1.168.192.in-addr.arpa" "$f/hagerman.butare.net" "router:/var/packages/DNSServer/target/named/etc/zone/master"; 
	scp "$f/1.168.192.in-addr.arpa" "$f/hagerman.butare.net" "nas1:/var/packages/DNSServer/target/named/etc/zone/master"; 
}

NasBackupDhcp()
{ 
	local h="$1" f="$1.dhcpd.zip" d="$cloud/systems/nas/dhcp/$1"

	[[ $h ]] || { EchoErr "USAGE: NasBackupDhcp HOST"; return 1; }
	[[ ! -d "$d" ]] && { mkdir "$d" || return; }
	[[ -f "$d/$f" ]] && { bak --move "$d/$f" || return; }

	ssh $h "rm -f $f; zip -r $f /etc/dhcpd" || return
	scp $h:~/$f "$d" || return
	echo "Successfully backed up $h dhcpd configuration to $d/$f"
}

NasUpdateDhcp() 
{ 
	local f="/tmp/dhcpd.conf"

	NasBackupDhcp router; NasBackupDhcp nas1; NasBackupDhcp nas2;

	cat ~/Dropbox/systems/nas/dns/dhcpd-eth0-static.conf | sed '/^#/d' | sed '/^$/ d' > $f
	scp "$f" router:/etc/dhcpd; scp "$f" router:/etc/dhcpd/dhcpd-static-static.conf; scp "$f" router:/etc/dhcpd/dhcpdStatic.ori;
	scp "$f" nas1:/etc/dhcpd; scp "$f" nas1:/etc/dhcpd/dhcpd-eth0-static.conf;
	#scp "$f" nas2:/etc/dhcpd; scp "$f" nas2:/etc/dhcpd/dhcpd-eth0-static.conf;
} 

alias nrslf='slf butare.net'
alias nsb='NasSyncBean'; alias NasSyncBean='scup; scpush; unc mount $nas/usbshare1/home && merge bean-udata; unc mount //nasc/usbshare1/public/documents/data && merge bean-data'
alias nsi='NasSyncIntel'; alias NasSyncIntel='m install-nas-rrsprsps'
alias nso='NasSyncOversoul'; alias NasSyncOversoul='m nas-oversoul'

# homebridge
hedit() { eval e "~$1/.homebridge/config.json"; }
alias hstatus='sudo /etc/init.d/homebridge status'
alias hstart='sudo /etc/init.d/homebridge start'
alias hstop='sudo /etc/init.d/homebridge stop'
alias hrestart='sudo /etc/init.d/homebridge restart'
alias hlog='tail /var/log/homebridge.log'
alias hlogerr='tail /var/log/homebridge.err'
alias hbakall='hbak jjbutare@pi1; hbak pi@pi2'

hbak()
{ 
	local h="$1" f="$1.homebridge.zip" d="$cloud/systems/homebridge/$1"

	[[ $h ]] || { EchoErr "USAGE: hbak HOST"; return 1; }
	[[ ! -d "$d" ]] && { mkdir "$d" || return; }
	[[ -f "$d/$f" ]] && { bak --move "$d/$f" || return; }

	ssh $h "rm -f $f; zip -r $f .homebridge" || return
	scp $h:~/$f "$d" || return
	echo "Successfully backed up $h homebridge configuration to $d/$f"
}

hrest()
{ 
	local h="$1";
	local f="$h.homebridge.zip" d="$cloud/systems/homebridge/$h" bakFile="$h.$(GetTimeStamp).homebridge" hb="/etc/init.d/homebridge"

	[[ $h ]] || { EchoErr "USAGE: hbak HOST"; return 1; }
	[[ -f "$d/$f" ]] || { EchoErr "$f does not exist"; return 1; }
	ask -dr n "Are you sure you want to restore $f to $h" || return

	ssh $h "[[ -d .bak ]] || mkdir .bak; zip -r .bak/$bakFile ~/.homebridge" || return
	scp "$d/$f" $h:~ || return
	ssh $h "sudo $hb stop && rm -fr ~/.homebridge && unzip -o $f && sudo $hb start" || return
	echo "Successfully restored $f homebridge configuration to $h"
}

# Raspberry Pi
alias pcp="PiCheckPower"; alias PiCheckPower='! dmesg --time-format ctime | egrep -i volt' # check for under voltage in the log

#
# other
#
ffw="sudo powershell FlipFlopWheel.ps1"

#
# XML
#

alias XmlValue='xml sel -t -v'
alias XmlShow='xml sel -t -c'

#
# Development
#

www="/cygdrive/c/inetpub/wwwroot"

alias ss='SqlServer'
alias ssms='SqlServerManagementStudio'
alias sscd='ScriptCd SqlServer cd'
alias ssp='SqlServer profiler express'

test="$code/test"
alias tup='cdup test'
alias tc='cdc test'
alias ts='cds test'

# 
# C Development
#
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#
# JAVA Development
#

alias j='JavaUtil'
alias jd='j decompile'
alias jdp='j decompile progress'
alias jrun='j run'

alias ec='eclipse'

#
# Android Development
#

alias ab='as adb'

#
# .NET Development
#

alias n='DotNetHelper'
alias ncd='scd DotNet cd'
alias gcd='scd DotNet GacCd'
build() { n build /verbosity:minimal /m "$code/$1"; }
BuildClean() { n build /t:Clean /m "$code/$1"; }
alias vs='VisualStudio'
s="$/"

#
# Juntos
#
alias jh='"$cloud/group/Juntos Holdings"'

#
# Intel
#

alias BashAd="start runas '/env' '/user:amr\ad_"$USERNAME"' mintty"
alias IntelSyncLocalFiles='slf rrsprsps; slf CsisBuild.intel.com; slf CsisBuild-dr.intel.com'
alias IntelSyncInstall='m install-CsisBuild; m install-CsisBuildDr; m install-dfs ;m install-cr'
alias isi=IntelSyncInstall islf=IntelSyncLocalFiles
alias SetIntelProxy='se intel SetProxy'
export GITHUB_HOST=github.intel.com

# locations
s="$home/Syncplicity"; sdata="$s/data"; sql="$sdata/sql"; ssp="$sql/SCADA Portal"
ihome="//jjbutare-mobl/john/documents"
SsSoftware="//VMSPFSFSCH09/DEV_RNDAZ/Software"

alias ssp='cd "$ssp"'

# laptop
SetMobileAliases() 
{
	local m="$1" h="jjbutare-mobl$1"
	case $m in 0) h="jjbutare-mobl";; 1) h="jjbutare-ivm1";; esac
	alias m${m}b="HostUtil boot ${h}"
	alias m${m}c="HostUtil connect ${h}"
	alias m${m}slf="slf ${h}"
	alias m${m}slp="slp ${h}"
	alias m${m}m="m m${m}s"
	eval "m${m}s() { HostUtil available ${h} && { m m${m}s; m${m}slf; }; }"
	eval m${m}dl='//${h}/c$/Users/jjbutare/Documents/data/download'
}
SetMobileAliases 0; SetMobileAliases 1; SetMobileAliases 7; SetMobileAliases 9;

PrepKey() { local k="/cygdrive/e/mobl"; mkdir -p "$k/bin" "$k/doc"; }
SyncKey() { local k="/cygdrive/e/mobl" f="/filters=-.*_sync.txt"; m "$bin" "$k/bin" "$f"; m "$udoc" "$k/doc" "/filters=-data\\VMware\\;-data\\mail\\"; }

# vpn
alias vpn="intel vpn"
alias von="vpn on"
alias voff="vpn off"

# Source Control - Software Solutions Update/Commit/Status
alias ssup='mup;aupd;spup'
alias ssc='mc;ac;spc'
alias sss='mst;as;sps'

# Profile Manager
profiles="$P/ITBAS/Profiles"
alias profiles='"$profiles"'
alias pm='ProfileManager'
alias pcd='"$profiles"'
alias ProfileManagerConfig='TextEdit C:\winnt\system32\ProfileManager.xml'

ProfileManager() 
{
	local p="$code/ProfileManager/bin/Debug/ProfileManager.exe"
	[[ ! -f "$p" ]] && p="$P/ITBAS/ProfileManager/ProfileManager.exe"
	if [[ $# == 1 && -f "$1" ]]; then
		start "$p" \"$(utw $1)\"
	elif [[ $# == 1 ]]; then
		start "$p" \"$(utw $profiles/$1.profile)\"
	else
		start "$p"
	fi
} 

#
# IntelNuGet
#

alias inu='code update IntelNuGet'
alias inc='code commit IntelNuGet'

#
# Tablet POC
#

alias albert='rdesk asmadrid-mobl2'

#
# Magellan
#

mc="$code/Magellan"
ms="$mc/Source"

alias mup='cdup Magellan'
alias mc='cdc Magellan'
alias mst='cds Magellan'
alias mr='cdr Magellan'

alias mvs='vs "$ms/Magellan.sln"'
alias mb='build Magellan/Source/Magellan.sln'
alias mbc='BuildClean Magellan/Source/Magellan.sln'
alias mlb='antidote App=Magellan BuildType=LocalBuild CacheBrokerAddress=@DatabaseServer@'

alias mpu='cp "$mc/Profiles/"*.profile "$profiles"'

#
# Antidote
#

ac="$code/Antidote/Source"

alias aupd='cdup Antidote'
alias ac='cdc Antidote'
alias as='cds Antidote'
alias ar='cdr Antidote'

alias avs='vs "$ac/Antidote.sln"'
alias ab='build Antidote/source/Antidote.sln'
alias abc='BuildClean Antidote/Antidote.sln'
alias alb='antidote verbose App=Antidote BuildType=LocalBuild'

alias ap='ProfileManager Antidote'
alias apu='cp "$ac/deployment/profiles/"*.profile "$profiles"'

alias aum='start "$ac/libraries/UpdateMagellan.cmd"'
alias aumc="cp $mc/Source/Magellan.Core/bin/Debug/Magellan.Core.* $ac/../Libraries; cp $mc/Source/Magellan.Silverlight.Data/bin/Debug/Magellan.Silverlight.Data.* $ac/../Libraries/Silverlight" # Updte Magellan Core
alias aumt="cp $mc/Source/Magellan.Threading/bin/Debug/Magellan.Threading.* $ac/../Libraries" # Antidote Update Magellan Threading
alias aumsm="cp $mc/Source/Magellan.ServiceManagement/bin/Debug/Magellan.ServiceManagement.* $ac/../Libraries;" # Update Magellan Service Management
alias aup='sudo cp "$code/Antidote/source/Antidote/bin/Debug/*" "$P/Antidote"' # Antidote Update ProgramFiles
alias aub='4 "$code/Antidote/source/Antidote/bin/Debug" "//CsisBuild.intel.com/d$/Program Files/Antidote"' # Antidote Update BuildServer
alias aul='CopyDir "$code/Antidote/source/Antidote/bin/Debug" "$P/Antidote"' # Antidote Update LocalServer

#
# FaSTr
#

fr="$code/RPIAD"
frc="$fr/Source"
frs="$fr/DataScripts"

alias fru='cdup RPIAD'
alias frc='cdc RPIAD'
alias frs='cds RPIAD'
alias frr='cdr RPIAD'
alias frco='cdco RPIAD'

alias frb='build RPIAD/Source/RPIAD.sln'
alias frbc='BuildClean RPIAD/Source/RPIAD.sln'
alias frlb='sudo antidote App=Rpiad BuildType=LocalBuild'

alias frp="ProfileManager Rpiad"
alias frpu='cp "$fr/Profiles/Rpiad.profile" "$profiles/Rpiad.profile"'
alias frput='cp "$fr/Profiles/DevProfiles/Test/Rpiad.profile" "$profiles"'
alias frpupp='cp "$fr/Profiles/DevProfiles/Preprod/Rpiad.profile" "$profiles"'
alias frpc='cp "$profiles/Rpiad.profile" "$fr/Profiles"'

alias frt='$frc/Test/WebServiceTest/bin/Debug/WebServiceTest.exe'

#
# SCADA Portal
#

alias spi="ScadaPortalInstall"

sp="$code/ScadaPortal"; [[ "$COMPUTERNAME" == "VMSPWBLD01" ]] && sp="$code/ScadaPortal/DevQa"
spt="$code/ScadaPortalTest"
sps="$sp/DataScripts"
spc="$sp/Source"

alias spic='g integrate Continuous'
alias spit='g integrate Test'
alias spipp='g integrate Pre-Production'

alias spup='cdup ScadaPortal'
alias spc='cdc ScadaPortal'
alias sps='cds ScadaPortal'
alias spr='cdr ScadaPortal'
alias spco='cdco ScadaPortal'

alias spvs='vs "$spc/ScadaPortal.sln"'
alias spb='build ScadaPortal/Source/ScadaPortal.sln'
alias spbc='BuildClean ScadaPortal/Source/ScadaPortal.sln'
alias splb='antidote App=ScadaPortal BuildType=LocalBuild'
alias sptb='antidote App=ScadaPortal BuildType=DeployToTest'

alias spua='start "$sp/bin/UpdateAntidote.cmd"'
alias spum='start "$sp/bin/UpdateMagellan.cmd"'
alias spumc="cp $mc/Source/Magellan.Core/bin/Debug/Magellan.Core.{dll,pdb,xml} $sp/Libraries; cp $mc/Source/Magellan.Silverlight.Data/bin/Debug/Magellan.Silverlight.Data.* $sp/Libraries/Silverlight"
alias spumd="cp $mc/Source/Magellan.Data/bin/Debug/Magellan.Data.* $sp/Libraries; cp $mc/Source/Magellan.Silverlight.Data/bin/Debug/Magellan.Silverlight.Data.* $sp/Libraries/Silverlight"
alias spumt="cp $mc/Source/Magellan.Threading/bin/Debug/Magellan.Threading.* $sp/Libraries"
alias spumsm="cp $mc/Source/Magellan.ServiceManagement/bin/Debug/Magellan.ServiceManagement.* $sp/Libraries; cp $mc/Source/Magellan.Silverlight.Data/bin/Debug/Magellan.Silverlight.Data.* $sp/Libraries/Silverlight"

# update build server
alias spudqa="CopyDir -r $spc //CsisBuild.intel.com/c$/Projects/ScadaPortal/DevQa/Source"

# service
alias sstStop='service stop ScadaService RASSI1PRSQLS; service stop ScadaService RASSI1BKSQLS; echo "Disable AlertChecker to prevent automatic service start"'
alias sstStart='service start ScadaService RASSI1PRSQLS; service start ScadaService RASSI1BKSQLS;'
alias sstStatus='service status ScadaService RASSI1PRSQLS; service status ScadaService RASSI1BKSQLS;'

# run on all
RunOnAllSql="$sp/DataScripts/Miscellaneous Scripts/sqlCommandToRun.sql"
RunOnAllInput="$sp/DataScripts/Miscellaneous Scripts/prodinput.txt"
alias ScadaRunOnAll='/cygdrive/c/Projects/ScadaPortal/Source/Utilities/ScadaRunOnAll/bin/Debug/ScadaRunOnAll.exe'
alias ser="s \"$RunOnAllSql\"" # edit run on all
alias seri="e \"$RunAllAllInput" # edit run on all input
alias sra="ScadaRunOnAll InputFile=\"$(utw "$RunOnAllInput")\" CommandFile=\"$(utw "$RunOnAllSql")\""
alias srt="sra Environment=Test"
alias srp="sra include=AllProjects " # run on all projects
alias srha="sra include=HistorianAccess" # run on Historian Access

# logs
ssl() { start explorer "//$1/d$/Program Files/Scada/ScadaService/log"; }
alias ssll='start explorer "$P/Scada/ScadaService/Log"'
alias ssltpr='ssl rasSI1prsqls'
alias ssltbk='ssl rasSI1bksqls'
alias sslpppr='ssl rasPPprsqls'
alias sslppbk='ssl rasPPbksqls'

# deploy
deploy() { pushd $spc/Deploy/Deploy/bin/Debug > /dev/null; start --direct ./deploy.exe "$@"; popd > /dev/null; }
alias spud='CopyDir "$spc/Deploy/Deploy/bin/Debug" "//CsisBuild.intel.com/c$/Projects/ScadaPortal/Development/Source/Deploy/Deploy/bin/Debug"' # update deploy

# deploy relay
alias drt="deploy HistorianRelayDb Environment=Test force=true DeployScripts=true DeployClr=true"
alias drpp="deploy Web Environment=Pre-Production force=true DeployWeb=false DeployScripts=false DeployClr=true"
alias drpilot="deploy Web Environment=Production force=true DeployWeb=false DeployScripts=false DeployClr=true Servers=ORPRSPS.amr.corp.intel.com"
alias drp="deploy Web Environment=Production force=true DeployWeb=false DeployScripts=false DeployClr=true"

# deploy log
alias dlog='deploy log'
alias dll='deploy log'
alias dlt='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Test.Log.vmspwbld001.txt'
alias dlpp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/PreProduction.Log.vmspwbld001.txt'
alias dlp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Production.Log.vmspwbld001.txt'

# deploy to LocalBuild
alias dadbLB='deploy AntidoteDb environment=LocalBuild'

# deploy to dev
alias dclr='deploy HistorianDb force=true PrOnly=Atrue include=TB1 DeployClr=false DeployHistorianSharedClr=true DeployScripts=false ControlServiceModules=false' # deploy custom
alias dra='deploy RelayAgent force=true Environment=Test' # deploy relay agent
alias dps='deploy ProjectService force=true Environment=dev RelayAgent=true include=pr ' # deploy project service
alias das='deploy AlarmShelvingService force=true Environment=dev RelayAgent=true include=pr' # deploy alarm shelving service

alias dss='deploy ScadaService force=true'
alias dsps='deploy ScadaProjectService force=true ForceLocalDeployment=true Environment=test'
alias dhdb='deploy HistorianDb force=true Environment=Test DeployScripts=false PrOnly=true DeployMagellanClr=false DeployClr=true NoSecondary=false ControlServiceModules=false'
alias ddlc='deploy DataLogger force=true InstallDataLogger=false ConfigureDataLogger=false PopPoints=false DeployScreens=false AddPoints=false ChangeCredentials=true ForceLocalDeployment=true'
alias ddl='deploy DataLogger force=true InstallDataLogger=false ConfigureDataLogger=true PopPoints=true DeployScreens=true AddPoints=true ChangeCredentials=true ForceLocalDeployment=true'
alias dac='deploy AlertChecker force=true'
alias dpm='deploy PointManagement force=true'
alias dw='deploy Web force=true'

# deploy to pre-production
alias drapp='deploy RelayAgent force=true environment=Pre-Production'
alias dwpp='deploy web force=true environment=PreProduction'
alias dacpp='deploy AlertChecker force=true environment=Pre-Production'
alias dsspp='deploy ScadaService force=true environment=Pre-Production'
alias dhdbpp='deploy HistorianDb force=true environment=Pre-Production'

# deploy to pilot
alias dwPILOT='deploy web force=true environment=Production servers=ORPRSPS'

# deploy production
alias drap='deploy deploy Environment=Production force=true'
alias draRA='drap SqlServers=RASBK1SQLS,3180:CB3'
alias draRR='drap SqlServers=RRSBK1SQLS,3180:CUB'

alias dssp='deploy ScadaService Environment=Production'
alias dssJR='dssp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ'
alias dssRA='dssp SqlServers=RASBK1SQLS,3180:CB3 servers=RAsbk1sqls;RAspr1sqls'
alias dssRR='dssp SqlServers=RRSBK1SQLS,3180:F11X servers=RRsbk1sqls;RRspr1sqls '
alias dssIR='dss Environment=PreProduction SqlServers=IRsbk1sqls,3180:F10 servers=IRsbk1sqls;IRspr1sqls'

alias dacp='deploy AlertChecker Environment=Production'
alias DacRA='dacp SqlServers=RASBK1SQLS,3180:CB3 Servers=rasD1Bprcimf'
alias DacRR='dacp SqlServers=RRsbk1sqls,3180:CUB'

alias ddlp='deploy DataLogger Environment=Production InstallDataLogger=false'
alias DdlIr='deploy DataLogger SqlServers=IRsbk1sqls,3180:F10 Environment=PreProduction InstallDataLogger=true ConfigureDataLogger=false PopPoints=false'

alias dhdbp='deploy HistorianDb Environment=Production DeployClr=true'
alias dhdbIDPJ='dhdbp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ;JRSPR1SQLS.ger.corp.intel.com,3180:IDPJ'
alias dhddLC='dhdbp SqlServers=LCSBK1SQLS.ger.corp.intel.com,3180:EPMS;LCSBK1SQLS.ger.corp.intel.com,3180:F28;LCSBK1SQLS.ger.corp.intel.com,3180:LC12;LCSBK1SQLS.ger.corp.intel.com,3180:LCC2;LCSBK1SQLS.ger.corp.intel.com,3180:MBR'
alias dhdbD1D='dhdbp SqlServers=RASBK1SQLS,3180:D1D'
alias dhdbTD1='dhdbp SqlServers=RASBK1SQLS,3180:TD1'

alias dwp='deploy Web Environment=Production'
alias dwpDL='dwp Servers=shsprsps'

# platform specific
[[ -f "$UBIN/.bashrc.$PLATFORM" ]] && . "$UBIN/.bashrc.$PLATFORM"

#
# CruiseControlPlugins
#

ccdir="$(wtu '\\csisbuild-dr.intel.com\d$\Program Files (x86)\CruiseControl.NET\server')"
#ccdir="$(wtu '\\csisbuild.intel.com\d$\Program Files (x86)\CruiseControl.NET - PreProd\server')"
#ccdir="$(wtu '\\csisbuild.intel.com\d$\Program Files (x86)\CruiseControl.NET - Prod\server')"

ccpu() # CruiseControlProgramUpdate
{
	4 "$code/CruiseControlPlugins/Source/ccnet.GitHub.plugin/bin/Debug" "$ccdir" /xf '*.pdb' '*.vshost.*' 'log4net.dll' 'NetReflector.dll' 'ThoughtWorks.*'
	CopyDir "$code/CruiseControlPlugins/Source/GitHubApi/bin/Debug" "$ccdir" /xf '*.pdb' '*.vshost.*'
}

ccts() { cctray close; cp "$APPDATA/cctray-settings-$1.xml"  "$APPDATA/cctray-settings.xml"; cctray start; } # CruiseControlTraySettings

#
# update
#

u() 
{ 
	local OnIntelNetwork

	# Intel
	if [[ $# == 0 ]] && intel OnIntelNetwork; then
		OnIntelNetwork=true
		ask 'Intel code repository update' && { ssc || return; ssup || return; }
		ask 'Intel install directory update' && { IntelSyncInstall || return; }
	fi

	HostUpdate $1 || return
}
