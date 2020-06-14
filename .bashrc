# ~/.bashrc, user intialization

[[ ! $BIN ]] && { BASHRC="/usr/local/data/bin/bash.bashrc"; [[ -f "$BASHRC" ]] && . "$BASHRC"; }

# non-interactive initialization - available from child processes and scripts, i.e. ssh <script>
set -a
LESS='-R'
LESSOPEN='|~/.lessfilter %s'
set +a

# interactive initialization - remainder not needed in child processes or scripts
[[ "$-" != *i* ]] && return

# shell options
shopt -s autocd cdspell cdable_vars dirspell histappend direxpand globstar

# credential manager
if [[ ! $CREDENTIAL_MANAGER_CHECKED ]]; then
	export CREDENTIAL_MANAGER_CHECKED="true"
	credential check >& /dev/null && export CREDENTIAL_MANAGER="true"
fi

#
# history
#

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

alias hc='HistoryClear'; HistoryClear() { cat /dev/null > ~/.bash_history && history -c; }

#
# completion
#

#  hosts(5) file for completion
HOSTFILE=$UBIN/hosts
complete -A hostname -o default curl dig host mosh netcat nslookup on off ping telnet

case "$PLATFORM" in
	linux) 
		if [[ -f /usr/lib/git-core/git-sh-prompt ]] && ! IsFunction __git_ps1; then
			. /usr/lib/git-core/git-sh-prompt
			. /usr/share/bash-completion/completions/git
		fi
		;;

	win|raspbian) 
		if [[ -f "/usr/share/bash-completion/completions/git" ]] && ! IsFunction __git_ps1; then
			. "/usr/share/bash-completion/completions/git"
			. "$BIN/git-prompt.sh"
		fi
		;;

	mac)
		d="/usr/local/etc/bash_completion.d"
		if ! IsFunction __git_ps1; then
			[[ -f "$d/git-prompt.sh" ]] && . "$d/git-prompt.sh"
			[[ -f "$d/git-completion.bash" ]] && . "$d/git-completion.bash"
			[[ -f "$d/hub.bash_completion.sh" ]] && . "$d/hub.bash_completion.sh"
			[[ -f "$d/tig-completion.bash" ]] && . "$d/tig-completion.bash"
		fi
		unset d
		;;
esac

# cd should not complete variables without a leading $
complete -r cd >& /dev/null 

#
# cd'able variables - lower case (not exported), $<var><return or tab>
#

p="$P" p32="$P32" win="$DATA/platform/win" sys="/mnt/c" pub="$PUB" bin="$BIN" data="$DATA" datad="$DATAD"
psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" # PublicStartMenu
pp="$psm/Programs" 	# PublicPrograms
pd="$pub/Desktop" 	# PublicDesktop
v="/Volumes"

home="$HOME" wh="$WIN_HOME" doc="$DOC" udoc="$DOC" udata="$udoc/data" dl="$HOME/Downloads"
bash="$udata/bash"
code="$CODE"; source="$CODE"; s="$CODE"; # code=local code (repositores), ccode=cloud code
ubin="$udata/bin"
usm="$APPDATA/Microsoft/Windows/Start Menu" # UserStartMenu
up="$usm/Programs" 													# UserPrograms
ud="$home/Desktop" 													# UserDesktop
db="$home/Dropbox"; cloud="$db"; c="$cloud"; cdata="$cloud/data"; cdl="$cdata/download"; ccode="$c/code"

alias p='"$p"' p32='"$p32"' pp='"$pp"' up='"$up"' usm='"$usm"'

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

#
# configuration
#

alias sa='. ~/.bashrc update'; ea() { local files; GetPlatformFiles "$UBIN/.bashrc." ".sh" || return 0; TextEdit "${files[@]}" ~/.bashrc; }
alias sf='. $bin/function.sh'; ef() { local files; GetPlatformFiles "$bin/function." ".sh" || return 0; TextEdit "${files[@]}" $bin/function.sh; }
alias bstart='. "$bin/bash.bashrc"; . ~/.bash_profile; kstart;'
alias estart="e /etc/environment /etc/profile /etc/bash.bashrc $BIN/bash.bashrc $UBIN/.bash_profile $UBIN/.bashrc"
alias kstart='bind -f ~/.inputrc' ek='e ~/.inputrc'
alias ebo='e ~/.minttyrc ~/.inputrc /etc/bash.bash_logout ~/.bash_logout'

#
# other
#

alias cls=clear
alias ei='e $bin/inst'
alias ehp='start "$udata/replicate/default.htm"'
alias logoff='IsPlatform win && { IsSsh && exit || logoff.exe; }'
alias st='startup --no-pause'

#
# applications
#

! InPath cowsay && alias cowsay="echo"
! InPath fortune && alias fortune="echo \"Hello, World\""
! InPath lolcat && alias lolcat="cat"

alias e='TextEdit'
alias bc='BeyondCompare'
alias clock='xclock -title $HOSTNAME -digital -update 1 &'
alias f='firefox'
alias m='merge'

alias grep='\grep --color=auto'
alias egrep='\egrep --color=auto'

# Add an "alert" alias for long running commands.  sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#
# archive
#

alias fm='start "$p/7-Zip/7zFM.exe"'
alias untar='tar -v -x --atime-preserve <'
zbak() { [[ $# == 1  ]] && zip -r "$1.zip" "$1" || zip -4 "$1" "${@:2}"; }
zrest() { unzip "${@}"; }
zls() { unzip -l "${@}"; }
zll() { unzip -ll "${@}"; }

#
# performance
#

sysmon() { case "$PLATFORM" in  linux) gnome-system-monitor &;; win) start taskmgr;; esac; }

# time
alias t='time pause'
alias ton='TimerOn'
alias toff='TimerOff'

# disk - nas3=nvme0n1 pi=mmcblk0
DiskTestCopy() { tar cf - "$1" | pv | (cd "${2:-.}"; tar xf -); }
DiskTestGui() { start --elevate ATTODiskBenchmark.exe; }
DiskTestRead() { sudo hdparm -t /dev/$1; } 
DiskTestWrite() { sync; sudo dd if=/dev/${1:-sda} of=tempfile bs=1M count=${2:-1024}; sync; } # use smaller count for Pi and other lower performance disks
DiskTestAll() { bonnie++ | tee >> "$(os name)_performance_$(GetDateStamp).txt"; }

# network
iperfs() { echo iPerf3 server is running on $(hostname); iperf3 -s -p 5002; } # server
iperfc() { iperf3 -c $1 -p 5002; } # client

#
# file management
#

alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'
alias .....='cbuiltin d ../../../..'

alias c='cls'		# clear screen
alias cb='builtin cd ~; cls' # clear screen and cd
alias ch='cb; hw;' # clear both, hello world
alias cf='cb; fortune | cowsay | lolcat ;' # clear both, fortune

alias del='rm'
alias md='mkdir'
alias rd='rmdir'

alias cd='UncCd'

UncCd()
{
	[[ "$PLATFORM" == "cygwin" ]] || ! IsUncPath "$1" && { builtin cd "$@"; return; }
	ScriptCd unc mount "$1" || return
}

UncLs()
{
	local unc="${@: -1}"
	
	if [[ "$PLATFORM" == "cygwin" ]] || ! IsUncPath "$unc"; then
		command ${G}ls --hide={desktop.ini,NTUSER.*,ntuser.*} -F -Q --group-directories-first --color "$@"
		return
	fi

	local dir; dir="$(unc mount "$unc")" || return
	${G}ls --hide={desktop.ini,NTUSER.*,ntuser.*} -F --group-directories-first -Q --group-directories-first --color "${@:1:$#-1}" "$dir"
}

alias inf="FileInfo"
alias l='explore'
alias rc='CopyDir'
alias rcp='rsync --info=progress2'
lcf() { local f="$1"; mv "$f" "${f,,}.hold" || return; mv "${f,,}.hold" "${f,,}" || return; } # lower case file

#
# directory management
#

which dircolors >& /dev/null && eval $(dircolors $ubin/default.dircolors) # ls colors

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
ftl() { egrep -i "$@" *; } # Find Text Local - find specified text in the current directory

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
# disk
#

alias duh='${G}du --human-readable'
alias dsu='DiskSpaceUsage'
alias dus='${G}du --summarize --human-readable'
alias TestDisk='sudo bench32.exe'

ListPartitions() { sudo parted -l; }
ListDisks() { sudo parted -l |& egrep -i '^Disk' |& egrep -v 'Error|Disk Flags' | cut -d' ' -f2 | cut -d: -f1; }
ListFirstDisk() { ListDisks | head -1; }

#
# Windows
#

if [[ ! "$DISPLAY" && -f /usr/bin/xprop ]]; then
	if [[ "$WSL" == "1" ]]; then
		export DISPLAY=:0
	else
		export WSL_HOST="$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null)"
		export DISPLAY="${WSL_HOST}:0"
		export LIBGL_ALWAYS_INDIRECT=1
	fi
fi

SetTitle() { printf "\e]2;$*\a"; }

#
# SSH
#

s() { sshc; ssh "$@"; }
alias sx=sshx
alias sterm=sterminator
alias sshconfig='e ~/.ssh/config'
alias sshkh='e ~/.ssh/known_hosts'

RemoteServerName() { nslookup "$(RemoteServer)" | grep "name =" | cut -d" " -f3; }
sshfull() { ssh -t $1 "source /etc/profile; ${@:2}";  } # ssh full: connect with a full environment, i.e. sshfull nas2 power shutdown
sshsudo() { ssh -t $1 sudo ${@:2}; }
ssht() { ssh -t "$@"; } # connect and allocate a pseudo-tty for screen based programs like sudo, i.e. ssht sudo ls /
sshs() { IsSsh && echo "Logged in from $(RemoteServerName)" || echo "Not using ssh"; } # ssh status
sterminator() { sx -f $1 -t 'bash -l -c terminator'; } # sterminator HOST - start terminator on host, -f enables X11, bash -l forces a login shell

sshx() # connect with X forward
{ 
	sshc # ensure the ssh-agent is running

	if IsPlatform wsl1; then # WSL 1 does not support X sockets over ssh and requires localhost
		DISPLAY=localhost:0 ssh -X $@
	elif IsPlatform mac,wsl2; then # macOS XQuartz requires trusted X11 forwarding
		ssh -Y $@
	else # use use untrusted (X programs are not trusted to use all X features on the host)
		ssh -X $@
	fi
} 

# SSH agent

# sshc: check and repair the ssh-agent
sshc()
{ 
	[[ -S "$SSH_AUTH_SOCK" ]] && ProcessIdExists "$SSH_AGENT_PID" && return
	SshAgent startup || return
	eval "$(SshAgent initialize)"
} 

# ssh check: check ssh-agent and fix it if needed
sshc()
{ 
	[[ ! "$1" =~ (-f|--force) ]] && { SshAgent check && return; }
	SshAgent fix || return
	ScriptEval SshAgent initialize
}

# restore ssh-agent configuration if possible
[[ (! $SSH_AUTH_SOCK || ! $SSH_AGENT_PID) && -f "$HOME/.ssh/environment" ]] && . "$HOME/.ssh/environment"

# fix the ssh-agent if it is not running or configured corrected
if [[ $CREDENTIAL_MANAGER && ! $SSH_AGENT_CHECKED ]] && ( [[ ! -S "$SSH_AUTH_SOCK" ]] || ! ProcessIdExists "$SSH_AGENT_PID" ); then
	#echo WSL=$WSL	CREDENTIAL_MANAGER=$CREDENTIAL_MANAGER SSH_AGENT_CHECKED=$SSH_AGENT_CHECKED SSH_AUTH_SOCK=$SSH_AUTH_SOCK SSH_AGENT_PID=$SSH_AGENT_PID $(ProcessIdExists "$SSH_AGENT_PID" && echo "running" || echo "NOT running")
	export SSH_AGENT_CHECKED="true"

	echo "Fixing the ssh-agent..."
	SshAgent startup && . "$HOME/.ssh/environment"
fi

#
# network
#

LogShow() { setterm --linewrap off; tail -f "$1";  setterm --linewrap on; }

alias ProxyEnable="ScriptEval network proxy vars --enable; network proxy vars --status"
alias ProxyDisable="ScriptEval network proxy vars --disable; network proxy vars --status"
alias ProxyStatus="network proxy vars --status"

ApacheLog() { LogShow "/usr/local/apache/logs/main_log"; } # specific to QNAP location for now
DhcpOptions() { pushd $win > /dev/null; powershell ./DhcpOptions.ps1; popd > /dev/null; }

SquidLog() { LogShow "/usr/local/squid/var/logs/access.log"; } # specific to QNAP location for now
SquidRestart() { sudo /etc/init.d/ProxyServer.sh restart; }
SquidUtilization() { squidclient -h "$1" cache_object://localhost/ mgr:utilization; }
SquidInfo() { squidclient -h "$1" cache_object://localhost/ mgr:info; }

# update
ub() { pushd . && cd "$BIN" && git pull && cd "$UBIN" && git pull && SyncLocalFiles; popd; } # update bin directories
u() { sshc; HostUpdate "$@" || return; }
un() { u nas; } # update nas

# sync files
alias slf='SyncLocalFiles'
alias FindSyncTxt='fa .*_sync.txt'
alias RemoveSyncTxt='FindSyncTxt | xargs rm'
alias HideSyncTxt="FindSyncTxt | xargs run.sh FileHide"

#
# prompt
#

alias SetBashGitPrompt='source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"'

GitPrompt()
{
	local red='\e[31m'
	unset GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWUNTRACKEDFILES GIT_PS1_SHOWUPSTREAM

	GIT_PS1_SHOWUPSTREAM="auto verbose"; # = at origin, < behind,  > ahead, <> diverged
	GIT_PS1_SHOWDIRTYSTATE="true" # shows *
	GIT_PS1_SHOWSTASHSTATE="true"	 # shows $
	GIT_PS1_SHOWUNTRACKEDFILES="true" # shows %
	__git_ps1 " (%s)"
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

	local host="${HOSTNAME#$USER-}"; host="${host#$SUDO_USER-}"; # remove the username from the hostname to shorten it
	host="${host%%.*}" # remove DNS suffix

	local title="\[\e]0;bash $host $dir\a\]"; # forces the title bar to update

	[[ $user ]] && user="@${user}"

 	PS1="${title}${green}${host}${user}${clear}${cyan}${git}${clear}\$ "
	
	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -r;' 
}

SetPrompt

[[ "$PWD" == @(/cygdrive/c|/usr/bin) ]] && cd ~
[[ $SET_PWD ]] && { cd "$SET_PWD"; unset SET_PWD; }

#
# git
#

alias g='git'
alias ga='g add'
alias gd='gc diff'
alias gf='gc freeze'
alias gl='g l'
alias gca='g ca'								# commit all
alias gcam='g amendAll'					# commit ammend all
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
alias eg='e ~/.gitconfig'
alias gg='GitHelper gui'
alias gh='GitHelper'
alias ghub='GitHelper hub'
alias tgg='GitHelper tgui'

alias gcn='GitHelper clone nas1' # clone a repository from nas1

complete -o default -o nospace -F _git g

#
# homebridge
#

alias hconfig="e $HOME/.homebridge/config.json" 						# edit configuration
alias hcconfig="e $c/network/homebridge/config/config.json" # edit cloud configuration
alias hssh="sudo cp ~/.ssh/config ~/.ssh/known_hosts ~homebridge/.ssh && sudo chown homebridge ~homebridge/.ssh/config ~homebridge/.ssh/known_hosts" # update SSH configuration 
alias hrestart="systemctl restart homebridge"
alias hstart='sudo hb-service start'
alias hstop='sudo hb-service stop'
alias hrestart='hstop;hlogclean;hstart'
alias hlog='sudo hb-service logs'
alias hbakall='hbak pi5'

hbak() # hbak HOST
{ 
	local f="$1.homebridge.zip" d="$cloud/network/homebridge/backup"
	local host="$1" stamp="$(GetDateStamp)"

	[[ $host ]] || { EchoErr "USAGE: hbak HOST"; return 1; }
	[[ ! -d "$d" ]] && { mkdir "$d" || return; }

	local i=1
	while [[ -f "$d/$stamp.$i.$f" ]]; do (( ++i )); done
	local df="$d/$stamp.$i.$f"

	ssh $host "rm -f $f; zip -r $f .homebridge" || return
	scp $host:~/$f "$df" || return
	ssh $host "rm -f $f" || return
	echo "$host homebridge configuration saved to $df"
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
# hardware
#

alias on='power on'; alias boot='on'
alias off='power off'; alias down='power off'
alias slp='power sleep'
alias reb='power reboot'

NumProcessors() { cat /proc/cpuinfo | grep processor | wc -l; }

#
# process
#

elevate() { start --elevate "$@"; }
ParentProcessName() {  cat /proc/$PPID/status | head -1 | cut -f2; }
procmon() { start -rid -e procmon; }

#
# python
#

alias FixPythonPackage='sudo -H pip3 install --ignore-installed' # if get distutils error

#
# ruby
#

export RUBYOPT=-W0 # fix lolcat deprecation warnings
alias nruby='/usr/local/opt/ruby/bin/ruby' # new ruby
alias unruby='export PATH="/usr/local/opt/ruby/bin:$PATH"' # use new ruby

#
# sound
#

alias sound='os sound'
alias TestSound='playsound "$data/setup/test.wav"'

playsound()
{ 
	InPath play && { play "$@"; return; }
	IsPlatform mac && { afplay "$@"; return; }
	IsPlatform cygwin && { cat "$1" > /dev/dsp; return; }
	
	EchoErr "No audio program was found"; return 1
}


# 
# tmux 
#

alias tmls='tmux list-session'								# tmux list session
tmas() { tmux attach -t "${1:-0}"; } 	# tmux attach session

#
# Virtual Machine
#

vm() { vmware IsInstalled && VMware start || hyperv start; }
vmon() { vmware -n "$1" run start; } # on (start)
vmoff() { vmware -n "$1" run suspend; } # off (suspend)

#
# xml
#

alias XmlValue='xml sel -t -v'
alias XmlShow='xml sel -t -c'

#
# wiggin
#

gapp() { elevate "$P32/GIGABYTE/AppCenter/RunUpd.exe"; } # Gigabyte Application Center
gfan() { elevate "$P32/GIGABYTE/siv/ThermalConsole.exe"; }

WigginOn() { on nas1; on nas3; on pi5; on UniFiController; }
WigginOff() { off nas1; off nas3; off pi5; off UniFiController; }

nc="$cloud/network" # network configuration
ncd="$nc/dhcp"

alias nce='NetworkConfigurationEdit'
alias ncb='NetworkConfigurationBackup'
alias ncu='NetworkConfigurationUpdate'

# DHCP Reservation.txt-> dhcpd-eth0-static.conf
# DHCP Options.txt -> dhcpd-dns-dns.conf
# DNS Forward.txt -> hagerman.butare.net
# DNS Reverse.txt -> 100.168.192.in-addr.arpa

NetworkConfigurationEdit() { e "$ncd/DNS Reverse.txt" "$ncd/DNS Forward.txt" "$ncd/DHCP Options.txt" "$ncd/DHCP Reservations.txt"; }

NetworkConfigurationBackup() # NetworkConfigurationBackup host
{ 
	local h="$1" d="$ncd/backup" stamp="$(GetDateStamp)"

	[[ $h ]] || { EchoErr "USAGE: NetworkConfigurationBackup HOST"; return 1; }

	# DHCP
	echo "Backing up DHCP configuration from $h..."
	local f="$h.dhcpd.zip" i=1
	while [[ -f "$d/$stamp.$i.$f" ]]; do (( ++i )); done
	ssh $h "rm -f $f; zip -r $f /etc/dhcpd" || return
	scp $h:~/$f "$d/$stamp.$i.$f" || return

	# DNS	
	echo "Backing up DNS configuration from $h..."
	f="$h.dns.zip" i="1"
	while [[ -f "$d/$stamp.$i.$f" ]]; do (( ++i )); done
	ssh $h "rm -f $f; zip -r $f /var/packages/DNSServer/target/named/etc/zone/master" || return
	scp $h:~/$f "$d/$stamp.$i.$f" || return

	echo "Successfully backed up $h network configuration"
}

NetworkConfigurationUpdate() # NetworkConfigurationUpdate host
{ 
	local h="$1" f="/tmp/reservations.txt"

	[[ $h ]] || { EchoErr "USAGE: NetworkConfigurationUpdate HOST"; return 1; }

 	# cleanup reservations by removing comments, empty lines, and lines with only spaces (fix etherwake warning)
	cat "$ncd/DHCP Reservations.txt" | sed '/^#/d' | sed '/^$/ d' | sed 's/^ *$//g' > "$f"

	# update ethers - downcase to make etherwake case agnostic
	echo "Updating the ethers configuration in $BIN..."
	gawk '{ FS=","; gsub(/dhcp-host=/,""); print $1 " " $2 }' "$f" | tr A-Z a-z > "$BIN/ethers" || return

	echo "Updating the host configuration in $UBIN/hosts..."
	gawk '{ FS=","; gsub(/dhcp-host=/,""); print $2 }' "$f" | sort > "$UBIN/hosts" || return

	echo "Updating DHCP configuration on $h..."
	local target="root@$h:/etc/dhcpd"
	scp "$ncd/DHCP Options.txt" "$target/dhcpd-dns-dns.conf"

	target="root@$h:/etc/dhcpd"
	case "$h" in
		router) scp "$f" "$target/dhcpdStatic.ori"; scp "$f" "$target/dhcpd-static-static.conf";;
		nas?) scp "$f" "$target/dhcpd-eth0-static.conf";
	esac

	echo "Updating DNS configuration on $h..."
	local target="root@$h:/var/packages/DNSServer/target/named/etc/zone/master"
	scp "$ncd/DNS Forward.txt" "$target/hagerman.butare.net"

	local reverse="$ncd/DNS Reverse.txt" t="$ncd/template"
	{ cat "$t/100.txt"; grep 100.168.192 "$reverse"; } > "/tmp/100.txt"
	{ cat "$t/101.txt"; grep 101.168.192 "$reverse"; } > "/tmp/101.txt"
	{ cat "$t/102.txt"; grep 102.168.192 "$reverse"; } > "/tmp/102.txt"

	scp "/tmp/100.txt" "$target/100.168.192.in-addr.arpa"
	scp "/tmp/101.txt" "$target/101.168.192.in-addr.arpa"
	scp "/tmp/102.txt" "$target/102.168.192.in-addr.arpa"

	return 0
} 

# UniFi
SwitchPoeStatus() { ssh admin@$1 swctrl poe show; }

#
# media
#

alias mg="media get"

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

# Android
alias ab='as adb'

# C
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# DOT.NET Development
alias vs='VisualStudio'

build() { n build /verbosity:minimal /m "$code/$1"; }
BuildClean() { n build /t:Clean /m "$code/$1"; }

# JAVA
alias j='JavaUtil'
alias jd='j decompile'
alias jdp='j decompile progress'
alias jrun='j run'
alias ec='eclipse'

# Node.js
alias node='\node --use-strict'
alias npmls='npm ls --depth=0'
alias npmi='sudo npm install -g' # npm install
alias npmu='sudo npm uninstall -g' # npm uninstall

#
# Juntos Holdings
#
alias jh='"$WIN_HOME/Juntos Holdings Dropbox/Company"'

#
# final
#

# platform specific .bashrc
SourceIfExistsPlatform "$UBIN/.bashrc." ".sh" || return

# cd to home directory if needed unless we are just updating aliases
[[ "$1" != "update" && "$PWD" != "$HOME" ]] && cd "$HOME"
