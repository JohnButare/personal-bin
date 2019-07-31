# ~/.bashrc, user specific interactive intialization, and non-interactive ("mintty" and "ssh <script>")

# sytem-wide configuration - if not done in /etc/bash.bashrc
if [[ ! $BIN ]]; then
	[[ "$-" == *i* ]] && echo ".bashrc: system configuration was not set in /etc/bash.bashrc" > /dev/stderr
	[[ -f /usr/local/data/bin/bash.bashrc ]] && . "/usr/local/data/bin/bash.bashrc"
fi

# non-interactive initialization (available from child processes and scripts)
set -a
LESS='-R'
LESSOPEN='|~/.lessfilter %s'
set +a

# interactive initialization - remainder not needed in child processes or scripts
[[ "$-" != *i* ]] && return

# history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s autocd cdspell cdable_vars dirspell histappend direxpand globstar

# completion
if IsPlatform win,raspbian && [[ -f "/usr/share/bash-completion/completions/git" ]] && ! IsFunction __git_ps1; then
	. "/usr/share/bash-completion/completions/git"
	. "$BIN/git-prompt.sh"
fi

if IsPlatform mac && [[ -f "/usr/local/etc/bash_completion.d/git-prompt.sh" ]] && ! IsFunction __git_ps1; then
	. "/usr/local/etc/bash_completion.d/git-prompt.sh"
	. "/usr/local/etc/bash_completion.d/git-completion.bash"
	. "/usr/local/etc/bash_completion.d/hub.bash_completion.sh"
	. "/usr/local/etc/bash_completion.d/tig-completion.bash"
fi

complete -r cd >& /dev/null # cd should not complete variables without a leading $

# locations - lower case (not exported), for cd'able variables ($<var><return or tab>) 
p="$P" p32="$P32" win="$DATA/platform/win" sys="/mnt/c" pub="$PUB" bin="$BIN" data="$DATA"
psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" # PublicStartMenu
pp="$psm/Programs" 	# PublicPrograms
pd="$pub/Desktop" 	# PublicDesktop
i="$data/install" 	# install
v="/Volumes"

home="$HOME" doc="$DOC" udoc="$DOC" udata="$udoc/data" dl="$HOME/Downloads"
bash="$udata/bash"
code="$CODE"; c="$CODE"
ubin="$udata/bin"
usm="$APPDATA/Microsoft/Windows/Start Menu" # UserStartMenu
up="$usm/Programs" 													# UserPrograms
ud="$home/Desktop" 													# UserDesktop
db="$home/Dropbox"; cloud="$db"; c="$cloud"; cdata="$cloud/data"; cdl="$cdata/download"
alias p='"$p"' p32='"$p32"' pp='"$pp"' up='"$up"' usm='"$usm"'

# variables and functions
alias ListVars='declare -p | egrep -v "\-x"'
alias ListExportVars='export'
alias ListFunctions='declare -F'
alias ListFunctionsAll='declare -f'
alias unexport='unset'
alias unfunction='unset -f'

# scripts
alias scd='ScriptCd'
alias se='ScriptEval'
alias slist='file * .* | FilterShellScript | cut -d: -f1'
alias sfind='slist | xargs egrep'
sfindl() { sfind --color=always "$1" | less -R; }
alias sedit='slist | xargs RunFunction.sh TextEdit'
alias slistapp='slist | xargs egrep -i "IsInstalledCommand\(\)" | cut -d: -f1'
alias seditapp='slistapp | xargs RunFunction.sh TextEdit'

# configure
startupFiles="/etc/profile /etc/bash.bashrc $BIN/bash.bashrc $UBIN/.bash_profile $UBIN/.bashrc"; IsPlatform mac && startupFiles+="/etc/bashrc"
alias sa='. ~/.bashrc update' ea='e ~/.bashrc'
alias ef='e $bin/function.sh' sf='. function.sh'
alias kstart='bind -f ~/.inputrc' ek='e ~/.inputrc'
alias bstart='. "$bin/bash.bashrc"; . ~/.bash_profile; kstart;' estart="e $startupFiles"
alias ebo='e ~/.minttyrc ~/.inputrc /etc/bash.bash_logout ~/.bash_logout'

#
# other
#
alias cf='CleanupFiles'
alias cls=clear
alias ei='e $bin/inst'
alias ehp='start "$udata/replicate/default.htm"'
alias hw='cowsay "Hello, World!" | lolcat'
alias ffw='elevate powershell.exe FlipFlopWheel.ps1'
alias st='startup'


#
# applications
#
u() { HostUpdate $1 || return; }

alias e='TextEdit'
alias bc='BeyondCompare'
alias f='firefox'
alias h='HostUtil'
alias m='merge'
alias vm='VMware'

alias grep='\grep --color=auto'
alias egrep='\egrep --color=auto'

if [[ "$PLATFORM" == "win" ]]; then
	alias autoruns='start autoruns.exe'
	alias ahk='AutoHotkey'
	alias ahkr='ahk restart'
	alias AutoItDoc="start $pdata/doc/AutoIt.chm"
	alias cctray='CruiseControlTray'
	alias ie='InternetExplorer'
	alias npp='notepadpp start'
	alias powershell="$WINDIR/system32/WindowsPowerShell/v1.0/powershell.exe"
	alias rdesk='cygstart mstsc /f /v:'
	alias wmic="$WINDIR/system32/wbem/WMIC.exe"

	alias apps='explorer shell:AppsFolder'
	alias cm='start CompMgmt.msc'
	alias credm='start control /name Microsoft.CredentialManager'
	alias dm='start DevMgmt.msc'
	alias ev='start eventvwr.msc'
	alias prog='product gui'
	alias prop='os SystemProperties'
	alias SystemRestore='vss'
	alias WindowSpy="start Au3Info.exe"

	alias ws='wscript /nologo'
	alias cs='cscript /nologo'

	ffw="sudo powershell FlipFlopWheel.ps1"

	alias wsllr='wslconfig.exe /list /running'
	alias wslt='wslconfig.exe /terminate Ubuntu-18.04'
fi

# Add an "alert" alias for long running commands.  sleep 10; alert
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
alias ch='cb; hw;' # clear both, hello world
alias del='rm'
alias md='mkdir'
alias rd='rmdir'
alias wln='start --direct "$BIN/win/ln.exe"' # Windows ln
alias wh="$WIN_HOME"

UncCd()
{
	[[ "$PLATFORM" == "cygwin" ]] || ! IsUncPath "$1" && { builtin cd "$@"; return; }
	[[ ! "$(GetUncShare "$1")" ]] && { unc list "$1"; return; }
	ScriptCd unc mount "$1" || return
}

UncLs()
{
	local unc="${@: -1}"
	
	if [[ "$PLATFORM" == "cygwin" ]] || ! IsUncPath "$unc"; then
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
# directory management
#
alias ls='UncLs'									# list 
alias la='UncLs -Al'							# list all
alias ll='UncLs -l'								# list long
alias llh='UncLs -d .*'						# list long hidden
alias lh='UncLs -d .*' 						# list hiden
alias lt='UncLs -Ah --full-time'	# list time

alias dir='cmd.exe /c dir' # Windows dir
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
# media
#
alias gp='media get'
alias sm='merge "$pub/Music" "//nas/music"'
alias sk='SyncKey'
alias et='exiftool'
alias etg='start exiftoolgui' # ExifToolGui

#
# Windows
#

# set the X DISPLAY if not set and X is installed (in /usr/bin/XWin for Cygwin)
[[ ! "$DISPLAY" && -f /usr/bin/XWin ]] && export DISPLAY=:0
[[ "$DISPLAY" && -f /usr/bin/ssh-askpass ]] && export SUDO_ASKPASS=/usr/bin/ssh-askpass

SetTitle() { printf "\e]2;$*\a"; }

#
# ssh
#

# check and repair the ssh-agent - call this directly over the sshc function for speed
[[ ! $SSH_AUTH_SOCK && -f "$HOME/.ssh/environment" ]] && . "$HOME/.ssh/environment"
if [[ ! -S "$SSH_AUTH_SOCK" ]] || ! ProcessIdExists "$SSH_AGENT_PID"; then
	echo "Fixing the ssh-agent..."
	SshAgent startup && . "$HOME/.ssh/environment"
fi

# connect
sshf() { ssh -t $1 "source /etc/profile; ${@:2}";  } # ssh full: connect with a full environment, i.e. sshfull nas2 power shutdown
sshsudo() { ssh -t $1 sudo ${@:2}; }
alias ssht='ssh -t' # connect and allocate a pseudo-tty for screen based programs like sudo, i.e. ssht sudo ls /

alias sx=sshx; sshx() # connect with X forward
{
	IsPlatform win && DISPLAY=localhost:0 ssh -X $@|| ssh -X $@;
}

# agent
sshc() { ! ( [[ -S "$SSH_AUTH_SOCK" ]] && ProcessIdExists "$SSH_AGENT_PID" ) && SshAgent startup && eval "$(SshAgent initialize)"; } # sshc() - ssh check: check and repair the ssh-agent
sshf() { SshAgent fix || return; ScriptEval SshAgent initialize; } # ssh fix: force creation of a new ssh-agent

# other
RemoteServerName() { nslookup "$(RemoteServer)" | grep "name =" | cut -d" " -f3; }
sshs() { IsSsh && echo "Logged in from $(RemoteServerName)" || echo "Not using ssh";}

#
# network
#

alias hu='HostUtil'
alias ipc='network ipc'
alias slf='SyncLocalFiles'
alias FindSyncTxt='fa .*_sync.txt'
alias RemoveSyncTxt='FindSyncTxt | xargs rm'
nu() { net use "$(ptw "$1")" "${@:2}"; } # NetUse
alias NetConfig='control netconnections'
alias NetStatus='ipconfig /all'

#
# prompt
#

alias SetBashGitPrompt='source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"'

GitPrompt()
{
	local gitColor red='\e[31m'
	unset GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWUNTRACKEDFILES GIT_PS1_SHOWUPSTREAM

	# use a basic prompt for systems where we have performance issues
	if [[ "$PLATFORM" == "win" ]]; then 
		[[ ! -d .git ]] && return
		
		if [[ "$PLATFORM_LIKE" == "cygwin" ]] || IsVm; then
			echo "$gitColor ($(git rev-parse --abbrev-ref HEAD))"
			return 
		fi
	fi

	gitColor="$(gw status --porcelain 2> /dev/null | egrep .+ > /dev/null && echo -ne "$red")"
	GIT_PS1_SHOWUPSTREAM="auto verbose"; # = at origin, < behind,  > ahead, <> diverged
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

	local dir='\w'
	local git; IsFunction __git_ps1 && git='$(GitPrompt)'
	local user; [[ "$USER" != "jjbutare" ]] && user="\u"
	local root; IsRoot && user+="${red}*"
	local elevated; [[ "$PLATFORM" == "win" ]] && IsElevated && user+="${red}e"
	local title="\[\e]0;Bash $dir\a\]"; # forces the title bar to update

	host="${HOSTNAME#$USER-}"; host="${host#$SUDO_USER-}"; # remove the username from the hostname to shorten it
	host="${host%%.*}" # remove DNS suffix

	[[ $user ]] && user="@${user}"

	# use a multi-line prompt with directory unless using tmux (which cotnains the directory in the status area)
 	PS1="${title}${green}${host}${user}${clear}${cyan}${git}${clear}\$ "
	
	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -r' 
}

SetPrompt
[[ "$PWD" == @(/cygdrive/c|/usr/bin) ]] && cd ~
[[ $SET_PWD ]] && { cd "$SET_PWD"; unset SET_PWD; }

#
# git
#
alias g='git' gl=g gw=g; [[ "$PLATFORM" == "win" ]] && alias gl='/usr/bin/git' gw='"$P/Git/cmd/git.exe"'
alias gd='gc diff'
alias gf='gc freeze'
alias gl='g l'
alias gca='g ca'
alias gs='g s' 									# status
alias gbs='g bs'								# branch status [PATTERN]
alias gr='g rb' 								# rebase
alias gr1='g rb HEAD~1 --onto' 	# rebase first commit onto specified branch
alias gri='g rbi' 							# rebase interactive
alias gria='g rbia' 						# rebase interactive auto, rebase all fixup! commits
alias grc='g rbc' 							# rebase continue
alias grf='g rf' 								# create a rebase fixup commit
alias grs='g rsq' 							# create a rebase squash commit
alias gmt='g mergetool'
alias gp='g push'
alias gpf='g push --force'			# push force
alias grft='grf && g i Test' 		# fixup commit and push to test
alias grfpp='grf && g i Pre-Production' # fixup commit and push to pre-production
alias ge='g status --porcelain=2 | cut -f9 -d" " | xargs edit' # git edit modified files
alias eg='te ~/.gitconfig'
alias gg='GitHelper gui'
alias gh='GitHelper'
alias ghub='GitHelper hub'
alias tgg='GitHelper tgui'

complete -o default -o nospace -F _git g

#
# homebridge
#

hedit() { eval e "~$1/.homebridge/config.json"; }
alias hstatus='sudo /etc/init.d/homebridge status'
alias hstart='sudo /etc/init.d/homebridge start'
alias hstop='sudo /etc/init.d/homebridge stop'
alias hrestart='sudo /etc/init.d/homebridge restart'
alias hlog='tail /var/log/homebridge.log'
alias hlogerr='tail /var/log/homebridge.err'
alias hbakall='hbak jjbutare@pi1; hbak pi@pi2'

hbak() # hbak HOST
{ 
	local h="$1" f="$1.homebridge.zip" d="$cloud/systems/homebridge/$1"

	[[ $h ]] || { EchoErr "USAGE: hbak HOST"; return 1; }
	[[ ! -d "$d" ]] && { mkdir "$d" || return; }
	[[ -f "$d/$f" ]] && { bak --move "$d/$f" || return; }

	ssh $h "rm -f $f; zip -r $f .homebridge" || return
	scp $h:~/$f "$d" || return
	echo "Successfully backed up $h homebridge configuration to $d/$f"
}

hrest() # hrest HOST
{ 
	local h="$1";
	local f="$h.homebridge.zip" d="$cloud/systems/homebridge/$h" bakFile="$h.$(GetTimeStamp).homebridge" hb="/etc/init.d/homebridge"

	[[ $h ]] || { EchoErr "USAGE: hbak HOST"; return 1; }
	[[ -f "$d/$f" ]] || { EchoErr "$f does not exist"; return 1; }
	ask -dr n "Are you sure you want to restore $f to $h" || return

	ssh $h "[[ -d .bak ]] || mkdir .bak; zip -r .bak/$bakFile ~/.homebridge" || return
	scp "$d/$f" $h:~ || return
	ssh $h "rm -fr ~/.homebridge && unzip -o $f" || return
	echo "Successfully restored $f homebridge configuration to $h"
}

#
# node.js
#
alias node='\node --use-strict'
alias npmls='npm ls --depth=0'

#
# package management
#
IsPlatform win && alias apt-get='apt-cyg'
IsPlatform mac && alias apt-get='brew'

#
# hardware
#
alias boot='HostUtil boot'
alias bw='HostUtil boot wait'
alias connect='HostUtil connect'
alias down='power shutdown'
alias hib='power hibernate'
alias logoff='logoff.exe'
alias reb='power reboot'
alias slp='power sleep'
IsPlatform win && alias ffw='elevate powershell FlipFlopWheel.ps1'

NumProcessors() { cat /proc/cpuinfo | grep processor | wc -l; }

#
# process
#
elevate() { start --elevate "$@"; }
ParentProcessName() {  cat /proc/$PPID/status | head -1 | cut -f2; }
procmon() { start -rid -e procmon; }

#
# raspberry pi
#
alias pcp="PiCheckPower"; alias PiCheckPower='! dmesg --time-format ctime | egrep -i volt' # check for under voltage in the log

#
# ruby
#
alias nruby='/usr/local/opt/ruby/bin/ruby'
alias unruby='export PATH="/usr/local/opt/ruby/bin:$PATH"' # use new ruby

#
# sound
#
playsound() { case "$PLATFORM" in win) cat "$1" > /dev/dsp;; mac) afplay "$1";; esac; }
alias sound='os sound'
alias TestSound='playsound "$data/setup/test.wav"'

# 
# tmux 
#
alias tmls='tmux list-session'								# tmux list session
tmas() { tmux attach -t "${1:-0}"; } 	# tmux attach session

#
# xml
#
alias XmlValue='xml sel -t -v'
alias XmlShow='xml sel -t -c'

#
# wiggin
#

alias b='sudo WigginBackup'
alias be='WigginBackup eject'
alias sp='portable sync'
alias mp='portable merge'
alias ep='portable eject'
alias eject='be; ep;'
alias nsb='NasSyncBean'; alias NasSyncBean='scup; scpush; unc mount $nas/usbshare1/home && merge bean-udata; unc mount //nasc/usbshare1/public/documents/data && merge bean-data'
alias nsi='NasSyncIntel'; alias NasSyncIntel='m install-nas-rrsprsps'
alias nso='NasSyncOversoul'; alias NasSyncOversoul='m nas-oversoul'

# DHCP

alias ned='NasEditDhcp'; NasEditDhcp() { e ~/Dropbox/systems/nas/dns/dhcpd-eth0-static.conf; }

alias nbd='NasBackupDhcp'; NasBackupDhcp()
{ 
	local h="$1" f="$1.dhcpd.zip" d="$cloud/systems/nas/dhcp/$1"

	[[ $h ]] || { EchoErr "USAGE: NasBackupDhcp HOST"; return 1; }
	[[ ! -d "$d" ]] && { mkdir "$d" || return; }
	[[ -f "$d/$f" ]] && { bak --move "$d/$f" || return; }

	ssh $h "rm -f $f; zip -r $f /etc/dhcpd" || return
	scp $h:~/$f "$d" || return
	echo "Successfully backed up $h dhcpd configuration to $d/$f"
}

alias nud='NasUpdateDhcp'; NasUpdateDhcp() 
{ 
	local h="$1" f="/tmp/dhcpd.conf"

	[[ $h ]] || { EchoErr "USAGE: NasUpdateDhcp HOST"; return 1; }

	cat ~/Dropbox/systems/nas/dns/dhcpd-eth0-static.conf | sed '/^#/d' | sed '/^$/ d' > $f

	scp "$f" root@$h:/etc/dhcpd

	case "$h" in
		router) scp "$f" $h:/etc/dhcpd/dhcpdStatic.ori; scp "$f" $h:/etc/dhcpd/dhcpd-static-static.conf;;
		nas?) scp "$f" $h:/etc/dhcpd/dhcpd-eth0-static.conf;
	esac
} 

# DNS 

alias nedns="NasEditDns"; NasEditDns() { e ~/Dropbox/systems/nas/dns/1.168.192.in-addr.arpa ~/Dropbox/systems/nas/dns/hagerman.butare.net; }
alias nbdns='NasBackupDns'; NasBackupDns() { scp "nas1:/var/packages/DNSServer/target/named/etc/zone/master/*" ~/"Dropbox/systems/nas/dns/copy"; }

alias nudns='NasUpdateDns'; NasUpdateDns() 
{
	local f=~/"Dropbox/systems/nas/dns/"
	scp "$f/1.168.192.in-addr.arpa" "$f/hagerman.butare.net" "router:/var/packages/DNSServer/target/named/etc/zone/master"; 
	scp "$f/1.168.192.in-addr.arpa" "$f/hagerman.butare.net" "nas1:/var/packages/DNSServer/target/named/etc/zone/master"; 
}

#
# development
#
alias ss='SqlServer'
alias ssms='SqlServerManagementStudio'
alias sscd='ScriptCd SqlServer cd'
alias ssp='SqlServer profiler express'

test="$code/test"
alias tup='cdup test'
alias tc='cdc test'
alias ts='cds test'

# C
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# JAVA Development
alias j='JavaUtil'
alias jd='j decompile'
alias jdp='j decompile progress'
alias jrun='j run'
alias ec='eclipse'

# Android Development
alias ab='as adb'

# .NET Development
alias n='DotNetHelper'
alias ncd='scd DotNet cd'
alias gcd='scd DotNet GacCd'
build() { n build /verbosity:minimal /m "$code/$1"; }
BuildClean() { n build /t:Clean /m "$code/$1"; }
alias vs='VisualStudio'
s="$/"

#
# Juntos Holdings
#
alias jh='"$cloud/group/Juntos Holdings"'

#
# Intel
#
alias BashAd="start runas '/env' '/user:amr\ad_"$USER"' mintty"
alias SetIntelProxy='se intel SetProxy'
s="$home/Syncplicity"; sdata="$s/data"; sql="$sdata/sql"; ssp="$sql/SCADA Portal"

# vpn
alias vpn="intel vpn"
alias von="vpn on"
alias voff="vpn off"

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

# Magellan
mc="$code/Magellan"
ms="$mc/Source"
alias mb='build Magellan/Source/Magellan.sln'
alias mbc='BuildClean Magellan/Source/Magellan.sln'
alias mlb='antidote App=Magellan BuildType=LocalBuild CacheBrokerAddress=@DatabaseServer@'
alias mpu='cp "$mc/Profiles/"*.profile "$profiles"'

# Antidote
ac="$code/Antidote/Source"
alias ab='build Antidote/source/Antidote.sln'
alias abc='BuildClean Antidote/Antidote.sln'
alias alb='antidote verbose App=Antidote BuildType=LocalBuild'
alias ap='ProfileManager Antidote'
alias apu='cp "$ac/deployment/profiles/"*.profile "$profiles"'
alias aum='start "$ac/libraries/UpdateMagellan.cmd"'
alias aumc="cp $mc/Source/Magellan.Core/bin/Debug/Magellan.Core.* $ac/../Libraries; cp $mc/Source/Magellan.Silverlight.Data/bin/Debug/Magellan.Silverlight.Data.* $ac/../Libraries/Silverlight" # Updte Magellan Core
alias aumt="cp $mc/Source/Magellan.Threading/bin/Debug/Magellan.Threading.* $ac/../Libraries" # Antidote Update Magellan Threading
alias aumsm="cp $mc/Source/Magellan.ServiceManagement/bin/Debug/Magellan.ServiceManagement.* $ac/../Libraries;" # Update Magellan Service Management

# SCADA Portal
alias spi="ScadaPortalInstall"
deploy() { pushd $spc/Deploy/Deploy/bin/Debug > /dev/null; start --direct ./deploy.exe "$@"; popd > /dev/null; }

spb="I-continuous I-pf I-dev I-dqa I-eqa I-gold"
spica() { for b in $spb; do git ic $b $1; done; } # integration clean all, reset all branches to VERSION, g icall VERSION
spira() { for b in $spb; do git ic $b $1; done; } # integration reset all, reset all branches to their origin

sp="$code/ScadaPortal"
sps="$sp/DataScripts"
spc="$sp/Source"

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

RunOnAllSql="$sp/DataScripts/Miscellaneous Scripts/sqlCommandToRun.sql"
RunOnAllInput="$sp/DataScripts/Miscellaneous Scripts/prodinput.txt"
alias ScadaRunOnAll='/cygdrive/c/Projects/ScadaPortal/Source/Utilities/ScadaRunOnAll/bin/Debug/ScadaRunOnAll.exe'
alias ser="s \"$RunOnAllSql\"" # edit run on all
alias seri="e \"$RunAllAllInput" # edit run on all input
#sra() { ScadaRunOnAll InputFile="$(utw "$RunOnAllInput")" CommandFile="$(utw "$RunOnAllSql")"; }
alias srt="sra Environment=Test"
alias srp="sra include=AllProjects " # run on all projects
alias srha="sra include=HistorianAccess" # run on Historian Access

#
# final
#

[[ -f "$UBIN/.bashrc.$PLATFORM" ]] && . "$UBIN/.bashrc.$PLATFORM"

[[ ! $DISPLAY ]] && xserver IsInstalled && export DISPLAY=:0

# cd to home directory if needed unless we are just updating aliases
[[ "$1" != "update" && "$PWD" != "$HOME" ]] && cd "$HOME"

