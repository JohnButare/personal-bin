# ~/.bashrc, user intialization

[[ ! $BIN ]] && { BASHRC="/usr/local/data/bin/bash.bashrc"; [[ -f "$BASHRC" ]] && . "$BASHRC"; }

# non-interactive initialization - available from child processes and scripts, i.e. ssh <script>
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

[[ "$-" != *i* ]] && return # return if not interactive

#
# Interactive Configuration
#

IsPlatform wsl2 && { LANG="C.UTF-8"; } # fix locale error

# options
IsBash && shopt -s autocd cdspell cdable_vars dirspell histappend direxpand globstar
IsZsh && { setopt no_beep; alias help="run-help"; }

# Ruby - initialize Ruby Version Manager, inlcuding adding Ruby directories to the path
SourceIfExists "$HOME/.rvm/scripts/rvm" || return

# credential manager
if [[ ! $CREDENTIAL_MANAGER_CHECKED ]]; then

	# ensure get Ubuntu gnome keyring password prompt over ssh 
	if IsSsh && [[ $DISPLAY ]] && InPath dbus-launch dbus-update-activation-environment; then
		dbus-update-activation-environment --systemd DISPLAY || return
	fi 

	credential check >& /dev/null && export CREDENTIAL_MANAGER="true"
	export CREDENTIAL_MANAGER_CHECKED="true"
fi

# editor
if [[ ! $EDITOR_CHECKED ]]; then	
	SetTextEditor
	EDITOR_CHECKED="true"
fi

# keyboard
IsZsh && bindkey "^H" backward-kill-word

#
# locations
#

fileServer="nas3.hagerman.butare.net"

p="$P" p32="$P32" win="$DATA/platform/win" sys="/mnt/c" pub="$PUB" b="$BIN" bin="$BIN" data="$DATA"
psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" # PublicStartMenu
pp="$psm/Programs" 	# PublicPrograms
pd="$pub/Desktop" 	# PublicDesktop
v="/Volumes"

appdata="$DATA/appdata" appconfig="$DATA/appconfig"
happconfig() { IsLocalHost "$1" && echo "$appconfig" || echo "//$1/root$appconfig"; }
happdata() { IsLocalHost "$1" && echo "$appdata" || echo "//$1/root$appdata"; }

home="$HOME" wh="$WIN_HOME" doc="$DOC" udoc="$DOC" udata="$udoc/data" dl="$HOME/Downloads"
bash="$udata/bash"
code="$CODE"; source="$CODE"; s="$CODE"; # code=local code (repositores), ccode=cloud code
ubin="$udata/bin"
usm="$APPDATA/Microsoft/Windows/Start Menu" # UserStartMenu
up="$usm/Programs" 													# UserPrograms
ud="$home/Desktop" 													# UserDesktop
db="$home/Dropbox"; cloud="$db"; c="$cloud"; cdata="$cloud/data"; cdl="$cdata/download"; ccode="$c/code"

alias p='"$p"' p32='"$p32"' pp='"$pp"' up='"$up"' usm='"$usm"'
alias jh='"$WIN_HOME/Juntos Holdings Dropbox/Company"'

#
# other
#

alias cls=clear
alias ei='e $bin/inst'
alias ehp='start "$udata/replicate/default.htm"'
alias st='startup --no-pause'

#
# applications
#

alias e='TextEdit'
alias bc='BeyondCompare'
alias f='firefox'
alias grep='\grep --color=auto'
alias m='merge'

cat() { InPath batcat && batcat "$@" || command cat "$@"; }
terminator() { coproc /usr/bin/terminator "$@"; }

#
# archive
#

alias fm='start "$p/7-Zip/7zFM.exe"'
alias untar='tar -v -x --atime-preserve <'
zbak() { [[ $# == 1  ]] && zip -r --symlinks "$1.zip" "$1" || zip --symlinks "$1" "${@:2}"; } # zbak DIR [FILE]
zrest() { unzip "${@}"; }
zls() { unzip -l "${@}"; }
zll() { unzip -ll "${@}"; }

tls() { sudo tar --list --gunzip --verbose --file="$1"; }
tbak() { sudo tar --create --preserve-permissions --numeric-owner --verbose --gzip --file="${2:-$1.tar.gz}" "$1"; } # tak DIR [FILE]
trest() { local dir; [[ $2 ]] && dir=( --directory "$2" ); sudo tar --extract --preserve-permissions --verbose --gunzip --file="$1" "${dir[@]}"; }

#
# configuration
#

# edit/set 
alias sa=". ~/.bashrc" ea="e ~/.bashrc" sz=". ~/.zshrc" ez="e ~/.zshrc" sf=". $BIN/function.sh" ef="e $BIN/function.sh"; # set aliases
alias s10k="sz" e10k="e ~/.p10k.zsh"
eaa() { local files; GetPlatformFiles "$UBIN/.bashrc." ".sh" || return 0; TextEdit "${files[@]}" ~/.bashrc; } 					# edit all aliases
efa() { local files; GetPlatformFiles "$bin/function." ".sh" || return 0; TextEdit "${files[@]}" $bin/function.sh; }  			# edit all functions

alias estart="e /etc/environment /etc/profile /etc/bash.bashrc $BIN/bash.bashrc $UBIN/.profile $UBIN/.bash_profile $UBIN/.zlogin $UBIN/.p10k.zsh $UBIN/.zshrc $UBIN/.bashrc"
alias kstart='bind -f ~/.inputrc' ek='e ~/.inputrc'
alias ebo='e ~/.minttyrc ~/.inputrc /etc/bash.bash_logout ~/.bash_logout'

sfull() # set full
{
	declare {CREDENTIAL_MANAGER_CHECKED,COLORLS_CHECKED,EDITOR_CHECKED,FZF_CHECKED}="" # .bashrc
	declare {PLATFORM,PLATFORM_LIKE,PLATFORM_ID}=""		# bash.bashrc
	declare {CHROOT_CHECKED,VM_TYPE_CHECKED}=""				# function.sh

	. "$bin/bash.bashrc"
	. "$bin/function.sh"
	IsZsh && { . ~/.zshrc; } || { kstart; . ~/.bash_profile; }
}

#
# completion
#

if [[ ! $COLORLS_CHECKED ]]; then
	COLORLS_CHECKED="true"
	unset COLORLS
	if InPath colorls; then
		COLORLS="true"
		. "$(GetFilePath "$(gem which colorls 2> /dev/null)")/tab_complete.sh" # slow .1s
	fi
fi

if IsBash; then
	#  hosts

	HOSTFILE=$DATA/setup/hosts
	complete -A hostname -o default curl dig host mosh netcat nslookup on off ping telnet

	# git
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
				. "$DATA/platform/agnostic/git-prompt.sh"
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

	# git
	complete -o default -o nospace -F _git g 

fi

if [[ ! $FZF_CHECKED && -d ~/.fzf ]]; then
	FZF_CHECKED="true"
	. "$HOME/.fzf/shell/completion.$PLATFORM_SHELL" || return # slow .2s
	. "$HOME/.fzf/shell/key-bindings.$PLATFORM_SHELL" || return
	_fzf_complete_ssh() { _fzf_complete +m -- "$@" < <(command cat "$UBIN/hosts" 2> /dev/null); }
	_fzf_complete_ping() { _fzf_complete +m -- "$@" < <(command cat "$UBIN/hosts" 2> /dev/null); }
fi

#
# Date/Time
#

clock()
{
	if [[ $DISPLAY ]] && InPath xclock; then coproc xclock -title $HOSTNAME -digital -update 1
	elif InPath tty-clock; then clockt
	else date
	fi
}

clockt() # clock terminal
{
	if InPath tty-clock; then tty-clock -s -c; 
	else date;
	fi
} 

clockc() # clock check
{

	InPath chronyc && { header "Chrony Client"; chronyc tracking || return; }
	
	if [[ -f "/etc/chrony/chrony.conf" ]] && grep "^allow" "/etc/chrony/chrony.conf" >& /dev/null; then
		header "Chrony Server"
		sudoc chronyc serverstats || return
	fi
}

#
# cron
#

IncronLog() { LogShowPattern "/var/log/syslog" "incron"; }

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
# directory management
#

[[ ! $LS_COLORS ]] && InPath dircolors && eval "$(dircolors $ubin/default.dircolors)"

alias cd='DoCd'

alias ls='DoLs'
alias lsc='DoLs'											# list with colorls
alias lsn='DoLs --native'							# list native (do not use colorls)
alias la='DoLs -Al'										# list all
alias lgs="DoLs -A --git-status" 			# list git status
alias ll='DoLs -l'										# list long
alias llh='DoLs -d -l .*'							# list long hidden
alias lh='DoLs -d .*' 								# list hiden
alias lt='DoLs --tree --dirs'					# list tree
alias ltime='DoLs --full-time -Ah'		# list time

alias dir='cmd.exe /c dir' # Windows dir
alias dirss="DoLs -l --sort=size --reverse --human-readable" 				# sort by size
alias dirst='DoLs -l --sort=time --reverse' 												# sort by last modification time
alias dirsct='DoLs --native -l --time=ctime --sort=time --reverse' 	# sort by creation time

DoCd()
{
	IsUncPath "$1" && { ScriptCd unc mount "$1"; return; }
	
	if IsFunction __enhancd::cd; then
		__enhancd::cd "$@"
	else
		builtin cd "$@"
	fi
}

DoLs()
{
	local unc="${@: -1}" # last argument
	
	if IsUncPath "$unc"; then
		local dir; dir="$(unc mount "$unc")" || return	
		set -- "${@:1:(( $# - 1 ))}" "$dir"
	fi

	if [[ ! $COLORLS || "$1" == "-d" || "$1" == "--native" || "$1" == "--full-time" ]]; then
		[[ "$1" == "--native" ]] && shift
		command ${G}ls --hide="desktop.ini" -F --group-directories-first --color "$@"
	else
		colorls --group-directories-first "$@"
	fi
}

#
# disk
#

alias duh='${G}du --human-readable' # disk usage human readable
alias dsu='DiskSpaceUsage'					# disk apace usage
tdu() { ncdu -x /; } 								# total disk usage
dus() { ${G}du --summarize --human-readable "$@" |& grep -Ev "Permission denied|Transport endpoint is not connected"; } # disk usage summary

ListPartitions() { sudo parted -l; }
ListDisks() { sudo parted -l |& grep -i '^Disk' |& grep -Ev 'Error|Disk Flags' | cut -d' ' -f2 | cut -d: -f1; }
ListFirstDisk() { ListDisks | head -1; }
pm() { PartitionManager "$@"; }

#
# file management
#

alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'
alias .....='cbuiltin d ../../../..'

alias c='cls'									# clear screen
alias cb='builtin cd ~; cls' 	# clear screen and cd
alias cf='cb; InPath fortune && InPath cowsay && InPath lolcat && fortune | cowsay | lolcat ;' # clear both, fortune

alias del='rm'
alias md='mkdir'
alias rd='rmdir'

alias inf="FileInfo"
alias l='explore'
alias rc='CopyDir'

lcf() { local f="$1"; mv "$f" "${f,,}.hold" || return; mv "${f,,}.hold" "${f,,}" || return; } # lower case file

FileTypes() { file * | sort -k 2; }

#
# functions
#

def() { IsBash && type "$1" || whence -f "$1"; }
alias unexport='unset'
alias unfunction='unset -f'

#
# history
#

HISTSIZE=5000
HISTFILESIZE=10000
IsBash && HISTCONTROL=ignoreboth
IsZsh && setopt HIST_IGNORE_DUPS

HistoryClear() { cat /dev/null > ~/.$HISTFILE && history -c; }

#
# performance
#

sysmon()
{ 
	if HasWindowManager; then
		case "$PLATFORM" in
			linux) 
				InPath stacer && { coproc stacer; return; }
				InPath gnome-system-monitor && { coproc gnome-system-monitor; return; }
				;;
			mac) start "Activity Monitor.app";;
			win) start taskmgr; return;; 
		esac
	fi
	
	InPath glances && { glances; return; }
	InPath htop && { htop; return; }
	InPath top && { top; return; }

	EchoErr "sysmon: no system monitor installed"
	return 1
}

# time
alias t='time pause'
alias ton='TimerOn'
alias toff='TimerOff'

# disk
alias TestDisk='sudo bench32.exe'
DiskTestCopy() { tar cf - "$1" | pv | (cd "${2:-.}"; tar xf -); }
DiskTestGui() { start --elevate ATTODiskBenchmark.exe; }
DiskTestRead() { sudo hdparm -t /dev/$1; } 
DiskTestAll() { bonnie++ | tee >> "$(os name)_performance_$(GetDateStamp).txt"; }

DiskTestWrite() # [DEST](disktest) [COUNT] - # use smaller count for Pi and other lower performance disks
{
	local file="$1"; [[ ! $file ]] && file="disktest"
	local count="$2"; [[ ! $count ]] && count="1024" 
	
	sync
	dd if=/dev/zero of="$file" bs=1M count="$count"
	if=/dev/zero of=tempfile bs=1M count=1024
	sync
	rm "$file"
} 

# network
iperfs() { echo iPerf3 server is running on $(hostname); iperf3 -s -p 5002; } # server
iperfc() { iperf3 -c $1 -p 5002; } # client

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
ftl() { grep -iE "$@" *; } # Find Text Local - find specified text in the current directory

fsql() { ft "$1" "*.sql"; } # FindSql TET
esql() { fte "$1" "*.sql"; } # EditSql TEXT
fsqlv() { fsql "-- version $1"; } # FindSqlVersion [VERSION]
esqlv() { esql "-- version $1"; } # EditSqlVersion [VERSION]
msqlv() { fsqlv | cut -f 2 -d : | cut -f 3 -d ' ' | grep -Eiv "deploy|skip|ignore|NonVersioned" | sort | tail -1; } # MaxSqlVersion

eai() { fte "0.0.0.0" "VersionInfo.cs"; } # EditAssemblyInfo that are set to deploy (v0.0.0.0)

FindText() # TEXT FILE_PATTERN [START_DIR](.)
{ 
	local startDir="${@:3}"
	grep --color -ire "$1" --include="$2" --exclude-dir=".git" "${startDir:-.}"
}

FindAll()
{
	[[ $# == 0 ]] && { echo "No file specified"; return; }
	find . -iname "$@" |& grep -v "Permission denied"
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
# git
#

alias g='git'
alias ga='g add'
alias gd='gc diff'
alias gf='gc freeze'
alias gl='g logb; echo'					# log
alias gla='g loga'							# log all
alias gca='g ca'								# commit all
alias gcam='g amendAll'					# commit ammend all
alias gcn='GitHelper clone nas1' # clone a repository from nas1
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
alias gpf='g push --force'			# push force
alias grft='grf && g i Test' 		# fixup commit and push to test
alias grfpp='grf && g i Pre-Production' # fixup commit and push to pre-production
alias ge='g status --porcelain=2 | cut -f9 -d" " | xargs edit' # git edit modified files
alias eg='e ~/.gitconfig'
alias gg='GitHelper gui'
alias gh='GitHelper'
alias ghub='GitHelper hub'
alias lg='lazygit'
alias tgg='GitHelper tgui'

# GitLab
glc() { sudoedit /etc/gitlab/gitlab.rb; } # GitLab configuration
glr() { sudoc gitlab-ctl reconfigure; } # GitLab reconfigure

glb() 
{ 
	sudoc gitlab-rake gitlab:backup:create STRATEGY=copy
	local dir="$(unc mount //oversoul/drop)" || return
	mkdir --parents "$dir/gitlab" || return
	sudo rsync --info=progress2 --archive --recursive --delete "/var/opt/gitlab/backups" "$dir/gitlab"
	unc unmount //oversoul/drop || return
}

#
# homebridge
#

alias hconfig="e $HOME/.homebridge/config.json" 						# edit configuration
alias hcconfig="e $c/network/homebridge/config/config.json" # edit cloud configuration
alias hlogclean="rm /var/lib/homebridge/homebridge.log"
alias hssh="sudo cp ~/.ssh/config ~/.ssh/known_hosts ~homebridge/.ssh && sudo chown homebridge ~homebridge/.ssh/config ~homebridge/.ssh/known_hosts" # update SSH configuration 
alias hrestart="systemctl restart homebridge"
alias hstart='sudo hb-service start'
alias hstop='sudo hb-service stop'
alias hlog='sudo hb-service logs'
alias hbakall='hbak pi5'

hbak() { HomebridgeHelper backup "$@"; } # hbak HOST
hrest() { HomebridgeHelper restore "$@"; } # hrest HOST

#
# host
#

u() { SshAgentCheck; HostUpdate "$@" || return; }

#
# network
#

alias NetworkUpdate='UpdateInit || return; network current update; ScriptEval network proxy --$(UpdateGet "proxy")'
alias nu="NetworkUpdate"

alias ehosts='sudoedit /etc/hosts' # edit hosts file

PortUsage() { IsPlatform win && { netstat.exe -an; return; }; sudoc netstat -tulpn; }
PingFix() { sudoc chmod u+s "$(FindInPath ping)" || return; }
DnsSuffixFix() { . "$BIN/bootstrap-config.sh" || return; echo "search $domain\n" | sudo tee -a "/etc/resolv.conf" || return; }

# Apache
ApacheConfig() { sudo $(GetTextEditor) "/etc/config/apache/extra/wiggin.conf"; } # specific to QNAP location for now
ApacheLog() { LogShow "/usr/local/apache/logs/main_log"; } # specific to QNAP location for now

ApacheRestart() 
{ 
	IsPlatform qnap && { sudo /etc/init.d/Qthttpd.sh restart; return; }
	[[ -f "/usr/local/apache/bin/apachectl" ]] && { sudo "/usr/local/apache/bin/apachectl" restart; return; }
}

# DNS
DnsLog() { service log bind9; }
DnsRestart() { service restart bind9; }

# DHCP
DhcpMonitor() {	IsPlatform win && { DhcpTest.exe "$@"; return; }; }
DhcpOptions()
{ 
	IsPlatform win && { pushd $win > /dev/null; powershell ./DhcpOptions.ps1; popd > /dev/null; return; }
	[[ -f "/var/lib/dhcp/dhclient.leases" ]] && cat "/var/lib/dhcp/dhclient.leases"
}

# Kea DHCP
KeaConfig() { sudoe "/etc/kea/kea-dhcp4-"*".json"; KeaRestart; }

KeaLog() { LogShow "/var/log/kea-dhcp4.log"; }
KeaServiceLog() { service log kea-dhcp4-server; }
KeaFixLog() { local f="/var/run/kea/isc_kea_logger_lockfile"; [[ -f "$f" ]] && return; sudo mkdir "/var/run/kea"; sudo touch "$f"; }

KeaStart() { service start kea-dhcp4-server; }
KeaStatus() { service status kea-dhcp4-server; }
KeaStop() { service stop kea-dhcp4-server; }
KeaRestart() { service restart kea-dhcp4-server; }

KeaTest() { SshHelper "$1.local" 'sudo dhclient -r; sudo dhclient'; ping "$1.local"; }

# mDNS
MdnsList() {  avahi-browse  -p --all -c | grep _device-info | cut -d';' -f 4 | sort | uniq; }
MdnsListFull() {  avahi-browse -p --all -c -r; }
MdnsPublishHostname() { avahi-publish-address -c $HOSTNAME.local "$(GetPrimaryIpAddress eth0)"; }

mdnsStart()
{ 
	sudo /etc/init.d/dbus start
	sudoc avahi-daemon &
}

if IsPlatform win; then
	ping()
	{
		local host="$1"; shift

		# resolve .local host - WSL getent does not currently resolve mDns (.local) addresses
		IsPlatform win && IsLocalAddress "$host" && { host="$(MdnsResolve "$host")" || return; }

		command ping "$host" "$@"
	}
fi

# proxy server
alias ProxyEnable="ScriptEval network proxy vars --enable; network proxy vars --status"
alias ProxyDisable="ScriptEval network proxy vars --disable; network proxy vars --status"
alias ProxyStatus="network proxy status"

# salt
RunAll() { a="$@"; sudoc salt '*' cmd.run "/usr/local/data/bin/RunScript $a"; }

# Squid
SquidLog() { LogShow "/usr/local/squid/var/logs/access.log"; } # specific to QNAP location for now
SquidRestart() { sudo /etc/init.d/ProxyServer.sh restart; }
SquidUtilization() { squidclient -h "$1" cache_object://localhost/ mgr:utilization; }
SquidInfo() { squidclient -h "$1" cache_object://localhost/ mgr:info; }

# sync files
alias slf='SyncLocalFiles'
alias FindSyncTxt='fa .*_sync.txt'
alias RemoveSyncTxt='FindSyncTxt | xargs rm'
alias HideSyncTxt="FindSyncTxt | xargs run.sh FileHide"

# TFTP
TftpLog() { IsPlatform qnap && LogShow "/share/Logs/opentftpd.log"; }

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

	local title="\[\e]0;terminal $host $dir\a\]"; # forces the title bar to update

	[[ $user ]] && user="@${user}"

 	PS1="${title}${green}${host}${user}${clear}${cyan}${git}${clear}\$ "
	
	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -r;' 
}

if [[ ! $SET_PROMPT_CHECK ]]; then
	SET_PROMPT_CHECK="true"
	IsBash && SetPrompt # slow .1s
fi

#
# hardware
#

GetArchitecture() { for host in $@; do printf " $host "; ssh $host uname -m; done; }

# on|off|sleep|reb HOST [HOST...] [OPTIONS]
hib() { PowerCommand hibernate "$@"; }
on() { PowerCommand on "$@"; }; alias boot='on'
off() { PowerCommand off "$@"; }; alias down='off'
slp() { PowerCommand sleep "$@"; }
reb() { PowerCommand reboot "$@"; }

PowerCommand()
{ 
	local cmd="$1" args=() hosts=() a h; shift; 
	for a in "$@"; do IsOption "$a" && args+=( $a ) || hosts+=( $a ); done
	[[ ! "${hosts[@]}" ]] && { power $cmd "${args[@]}"; return; }
	for h in "${hosts[@]}"; do power $cmd "${args[@]}" "$h" || return; done
}

logoff()
{
	IsSsh && exit
	IsPlatform win && { logoff.exe; return; }
	IsPlatform ubuntu && { gnome-session-quit --no-prompt; return; }
}

NumProcessors() { cat /proc/cpuinfo | grep processor | wc -l; }

#
# media
#

alias mg="media get"

#
# monitoring
#

alias ev='EventViewer'
EventViewer() { IsPlatform win && start eventvwr.msc; InPath ksystemlog && coproc sudox "ksystemlog"; }

LogShow() { setterm --linewrap off; tail -f "$1"; setterm --linewrap on; }
LogShowPattern() { setterm --linewrap off; sudo tail -f "$1" | grep " incrond"; setterm --linewrap on; }
LogNetConsole() { netconsole -l -u $(GetIpAddress) 6666 | sudoc tee /var/log/netconsole.log; }

NetConsoleEnable() # HOST
{
	local host="$1"
	[[ ! $host ]] && { MissingOperand "host" "EnableNetConsole"; return 1; }

	! grep "netconsole" /etc/modules && { echo "netconsole" | sudo tee -a "/etc/modules" || return; }
	echo "options netconsole netconsole=6666@$(GetIpAddress)/$(GetPrimaryAdapterName),6666@$(GetIpAddress "$host")/$(GetMacAddress "$host")" | sudo tee "/etc/modprobe.d/netconsole.conf"
}

NetConsoleDisable()
{
	sudo sed -i "/^netconsole/d" "/etc/modules" || return
	sudo rm -f "/etc/modprobe.d/netconsole.conf"
}

#
# process
#

ParentProcessName() {  cat /proc/$PPID/status | head -1 | cut -f2; }
procmon() { start -rid -e procmon; }

#
# python
#

alias FixPythonPackage='sudo -H pip3 install --ignore-installed' # if get distutils error

#
# Raspberry Pi
#
PiImageLite() { pi image "$(i dir)/platform/Raspberry Pi/Raspberry Pi OS/2020-05-27-raspios-buster-lite-armhf.zip"; }

#
# scripts
#

mint() { e "$ccode/bash/template/min"; } # bash min template
alias scd='ScriptCd'
alias se='ScriptEval'
alias slist='file * .* | FilterShellScript | cut -d: -f1'
alias sfind='slist | xargs grep'
sfindl() { sfind --color=always "$1" | less -R; }
alias sedit='slist | xargs RunFunction.sh TextEdit'
alias slistapp='slist | xargs grep -iE "IsInstalledCommand\(\)" | cut -d: -f1'
alias seditapp='slistapp | xargs RunFunction.sh TextEdit'

fu() { FindText "$1" "*" "$BIN"; FindText "$1" "*" "$UBIN"; } # FindUsages
fue() { fu "$1" | cut -d: -f1 | sort | uniq | xargs sublime; } # FindUsagesEdit

#
# SSH
#

alias s=sx	# connect with ssh
alias hs="hyperv ssh" # connect to a Hyper-V host with ssh
alias sshconfig='e ~/.ssh/config'
alias sshkh='e ~/.ssh/known_hosts'

sm() { SshHelper --mosh "$@"; } # connect with mosh
sx() { SshHelper -x "$@"; } 		# connect with X forwarding

sshfull() { ssh -t $1 "source /etc/profile; ${@:2}";  } # ssh full: connect with a full environment, i.e. sshfull nas2 power shutdown
sshsudo() { ssh -t $1 sudo ${@:2}; }
ssht() { ssh -t "$@"; } # connect and allocate a pseudo-tty for screen based programs like sudo, i.e. ssht sudo ls /
sshs() { IsSsh && echo "Logged in from $(RemoteServerName)" || echo "Not using ssh"; } # ssh status
sterm() { sx -f $1 -t 'bash -l -c terminator'; } # sterminator HOST - start terminator on host, -f enables X11, bash -l forces a login shell

# SSH Agent - check and start the SSH Agent 
# - avoid password prompt - only start if there is a credential manager installed
# - avoid output - for clean PowerLevel 10K startup (Pass credential prompt requires output and input)
[[ -f "$HOME/.ssh/environment" ]] && . "$HOME/.ssh/environment"
[[ $CREDENTIAL_MANAGER ]] && [[ "$(credential type)" != "Pass" ]] && ! ssh-add -L >& /dev/null && SshAgentHelper start --quiet

#
# sound
#

alias sound='os sound'
alias TestSound='playsound "$data/setup/test.wav"'

playsound()
{ 
	InPath play && { play "$@"; return; }
	IsPlatform mac && { afplay "$@"; return; }
	EchoErr "No audio program was found"; return 1
}

# 
# tmux 
#

alias tmls='tmux list-session'								# tmux list session
tmas() { tmux attach -t "${1:-0}"; } 	# tmux attach session

#
# variables
#

alias ListVars='declare -p | grep -v "\-x"'
alias ListExportVars='export'
alias ListFunctions='declare -F'
alias ListFunctionsAll='declare -f'

#
# Virtual Machine
#

# chroot
alias cr="ChrootHelper"
alias crdown="schroot --all-sessions --end-session"

# hyper-v
alias h="hyperv"
hc() { h console  "$1"; } 																				# console
hoc() { h on "$1" && h console  "$1"; } 													# on-console
hct() { h create --type "$@" && h on "$2" && h console "$2"; } 		# create-type
hcl() { hct linux "$@" ; } ; hcp() { hct pxe "$@" ; }; hcw() { hct win "$@" ; } 

# vmware
vm() { vmware IsInstalled && VMware start || hyperv start; }
vmon() { vmware -n "$1" run start; } # on (start)
vmoff() { vmware -n "$1" run suspend; } # off (suspend)

#
# wiggin
#

# netboot
n3c() { cd "$(happconfig "$fileServer")$1"; } # nas3 application configuration
n3d() { cd "$(happdata "$fileServer")/$1"; } # nas3 application data

# web
n3w() { IsLocalHost "$fileServer" && cd "/share/Web" || cd "//$fileServer/web"; } # web directory
n3wc() { local f="$(unc mount "//$fileServer/root/etc/config/apache/extra/wiggin.conf")"; e "$f"; } # web configure

# Gigabyte applications
gapp() { elevate "$P32/GIGABYTE/AppCenter/RunUpd.exe"; } # Gigabyte Application Center
gfan() { elevate "$P32/GIGABYTE/siv/ThermalConsole.exe"; }

# synology entware opt interferes with Domotz Agent
OptOn() { [[ -d "/opt/lib.hold" ]] && sudo mv "/opt/lib.hold" "/opt/lib"; }
OptOff() { [[ -d "/opt/lib" ]] && sudo mv "/opt/lib" "/opt/lib.hold"; }

# configuration
alias ncd="cd $c/network/configuration"
alias nce='wiggin config edit'
alias ncb='wiggin config backup'
alias ncu='wiggin config update'

alias ncu1='wiggin config update pi1.local'
alias ncu2='wiggin config update pi2.local'
alias ncuw='ncu1 && ncu2'

nae() { TextEdit "$c/network/configuration/dns/forward.txt"; } # network alias edit

# UniFi
SwitchPoeStatus() { ssh admin@$1 swctrl poe show; }

#
# windows
#

InitializeXServer || return
SetTitle() { printf "\e]2;$*\a"; }

#
# xml
#

alias XmlValue='xml sel -t -v'
alias XmlShow='xml sel -t -c'

#
# final
#

SourceIfExists "$BIN/z.sh" || return
SourceIfExistsPlatform "$UBIN/.bashrc." ".sh" || return
