# ensure bash.bashrc has been sourced
[[ ! $BIN ]] && { BASHRC="/usr/local/data/bin/bash.bashrc"; [[ -f "$BASHRC" ]] && . "$BASHRC"; }

# non-interactive initialization - available from child processes and scripts, i.e. ssh <script>
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# return if not interactive
[[ "$-" != *i* ]] && return 

#
# Interactive Configuration
#

# ensure DISPLAY is set first
InitializeXServer || return

# fix locale error
IsPlatform wsl2 && { LANG="C.UTF-8"; } 

# options
IsBash && shopt -s autocd cdspell cdable_vars dirspell histappend direxpand globstar
IsZsh && { setopt no_beep; alias help="run-help"; }

# Ruby - initialize Ruby Version Manager, inlcuding adding Ruby directories to the path
SourceIfExists "$HOME/.rvm/scripts/rvm" || return

# credential manager
if [[ ! $CREDENTIAL_MANAGER_CHECKED ]]; then
	export CREDENTIAL_MANAGER="$(credential --quiet type)"; 	
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

p="$P" p32="$P32" win="$DATA/platform/win" sys="/mnt/c" pub="$PUB" b="$BIN" bin="$BIN" data="$DATA"
psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" # PublicStartMenu
pp="$psm/Programs" 															# PublicPrograms
pd="$pub/Desktop" 															# PublicDesktop
v="/Volumes"																		# volumes

appdata="$DATA/appdata" appconfig="$DATA/appconfig"
happconfig() { IsLocalHost "$1" && echo "$appconfig" || echo "//$1/root$appconfig"; }
happdata() { IsLocalHost "$1" && echo "$appdata" || echo "//$1/root$appdata"; }

home="$HOME" wh="$WIN_HOME" doc="$DOC" udoc="$DOC" udata="$home/data" dl="$HOME/Downloads"
code="$CODE" wcode="$WIN_HOME/$(GetFileName "$CODE")"
ubin="$udata/bin"
usm="$ADATA/../Roaming/Microsoft/Windows/Start Menu" # UserStartMenu
up="$usm/Programs" # UserPrograms
ud="$home/Desktop" # UserDesktop
db="$home/Dropbox"; cloud="$db"; c="$cloud"; cdata="$cloud/data"; cdl="$cdata/download"; ccode="$c/code"; export CDATA="$cdata" # cloud
ncd="$c/network" # network configuration directory

alias p='"$p"' p32='"$p32"' pp='"$pp"' up='"$up"' usm='"$usm"'
alias jh='"$WIN_HOME/Juntos Holdings Dropbox/Company"'
alias ncd="$ncd"

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
alias f='firefox'
alias grep='command grep --color=auto'
alias m='merge'

bcat() { InPath batcat && batcat "$@" || command cat "$@"; }
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

		win) 
			if [[ -f "/usr/share/bash-completion/completions/git" ]] && ! IsFunction __git_ps1; then
				. "/usr/share/bash-completion/completions/git"
				. "$DATA/platform/agnostic/git-prompt.sh"
			fi
			;;
	esac

	# cd should not complete variables without a leading $
	complete -r cd >& /dev/null 

	# git
	complete -o default -o nospace -F _git g 

	# HashiCorp
	InPath consul && complete -C /usr/local/bin/consul consul
	InPath nomad && complete -C /usr/local/bin/nomad nomad
	InPath vault && complete -C /usr/local/bin/vault vault
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

CronLogShow() { LogShow "/var/log/cron.log" "$1"; }
IncronLogShow() { LogShow "/var/log/syslog" "incron"; }

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

# GO
[[ -d "/usr/local/go/bin" ]] && { PathAdd "/usr/local/go/bin"; GOPATH=$HOME/go; }

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
	
	# if IsFunction __enhancd::cd; then
	# 	__enhancd::cd "$@"
	# else
		builtin cd "$@"
	# fi
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
# functions
#

def() { IsBash && type "$1" || whence -f "$1"; }
alias unexport='unset'
alias unfunction='unset -f'

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
alias eg='e ~/.gitconfig; IsPlatform win && { pause; cp ~/.gitconfig $WIN_HOME; }'
alias gg='GitHelper gui'
alias gh='GitHelper'
alias ghub='GitHelper hub'
alias lg='lazygit'
alias tgg='GitHelper tgui'

# Git Headquarters (ghq)
ghqg() { local url="$1"; ghq get "$1"; url="$(echo "$url" | cut -d/ -f3-)"; cd "$(ghq root)/$(ghq list | grep "$url")"; } # get REPO
ghqcd() { cd "$(ghq root)/$(ghq list | fzf)"; } # select an existing ghq repository to change to

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
# history
#

HISTSIZE=5000
HISTFILESIZE=10000
IsBash && HISTCONTROL=ignoreboth
IsZsh && setopt SHARE_HISTORY HIST_IGNORE_DUPS

HistoryClear() { IsBash && cat /dev/null > $HISTFILE; history -c; }

#
# homebridge
#

alias hconfig="e $HOME/.homebridge/config.json" 						# edit configuration
alias hcconfig="e $ncd/system/homebridge/config/config.json" # edit cloud configuration
alias hlogclean="sudoc rm /var/lib/homebridge/homebridge.log"
alias hssh="sudo cp ~/.ssh/config ~/.ssh/known_hosts ~homebridge/.ssh && sudo chown homebridge ~homebridge/.ssh/config ~homebridge/.ssh/known_hosts" # update SSH configuration 
alias hrestart="service restart homebridge"
alias hstart='sudo hb-service start'
alias hstop='sudo hb-service stop'
alias hlog='sudo hb-service logs'
alias hloge='e /var/lib/homebridge/homebridge.log' # log edit
alias hbakall='hbak pi5'

hbak() { HomebridgeHelper backup "$@"; } # hbak HOST
hrest() { HomebridgeHelper restore "$@"; } # hrest HOST

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
# projects
#

# Blue Assignor
bac() { cd "$WIN_HOME/Juntos Holdings Dropbox/Company/consulting/BlueAssignor"; }

#
# network
#

alias cdv="cd ~/Volumes"
alias NetworkUpdate='UpdateInit || return; network current update; ScriptEval network proxy --$(UpdateGet "proxy")'
alias nu="NetworkUpdate"

alias ehosts='sudoedit /etc/hosts' # edit hosts file

PortUsage() { IsPlatform win && { netstat.exe -an; return; }; sudoc netstat -tulpn; }
PingFix() { sudoc chmod u+s "$(FindInPath ping)" || return; }
DnsSuffixFix() { echo "search $(ConfigGet "domain")\n" | sudo tee -a "/etc/resolv.conf" || return; }

# Apache
ApacheConfig() { e "$(unc mount //nas3/root)/etc/config/apache/extra/wiggin.conf"; } # specific to QNAP location for now
ApacheLog() { LogShow "/usr/local/apache/logs/main_log"; } # specific to QNAP location for now

ApacheRestart() 
{ 
	IsPlatform qnap && { sudo /etc/init.d/Qthttpd.sh restart ; return; }
	[[ -f "/usr/local/apache/bin/apachectl" ]] && { sudo "/usr/local/apache/bin/apachectl" restart; return; }
	ssh -t "$(ConfigGet "web")" "sudo /etc/init.d/Qthttpd.sh restart" || return
}

# DNS
DnsLog() { service log bind9; }
DnsRestart() { service restart bind9; }

# DHCP
DhcpMonitor() {	IsPlatform win && { dhcptest.exe "$@"; return; }; }
DhcpOptions()
{ 
	IsPlatform win && { pushd $win > /dev/null; powershell ./DhcpOptions.ps1; popd > /dev/null; return; }
	[[ -f "/var/lib/dhcp/dhclient.leases" ]] && cat "/var/lib/dhcp/dhclient.leases"
}

# HashiCorp
alias h="hashi"
alias hcd="cd $ncd/hashi"

hc() { HashiConfig "$@" && hashi status; } # hc - HashiConfig
hr() { hashi resolve "$@"; }	# hr SERVER - resolve a consul service address
hs() { hashi status; }

j() { hashi nomad job "$@"; }	# job

# test
hti() { wiggin setup hashi test -- "$@" && HashiConfig test; }		# Hashi Test Install
htr() { wiggin remove hashi test --force --yes -- "$@"; HashiConfig reset; }				# Hashi Test Clean

# run program and set configuration if necessary
consul() { [[ ! $CONSUL_HTTP_ADDR ]] && HashiConfig; command consul "$@"; }
nomad() { [[ ! $NOMAD_ADDR ]] && HashiConfig; command nomad "$@"; }
vault() { [[ ! $VAULT_ADDR ]] && HashiConfig; command vault "$@"; }

# put token for a HashiCorp program into the clipboard
clipc() { clipw "$CONSUL_HTTP_TOKEN"; }
clipn() { clipw "$NOMAD_TOKEN"; }
clipv() { clipw "$VAULT_TOKEN"; }

# Kea DHCP
KeaConfig() { sudoe "/etc/kea/kea-dhcp4-"*".json"; KeaRestart; }

KeaLog() { LogShow "/var/log/kea-dhcp4.log"; }
KeaServiceLog() { service log kea-dhcp4-server; }
KeaFixLog() { local f="/var/run/kea/isc_kea_logger_lockfile"; [[ -f "$f" ]] && return; sudo mkdir "/var/run/kea"; sudo touch "$f"; }

KeaStart() { service start kea-dhcp4-server; }
KeaStatus() { service status kea-dhcp4-server; }
KeaStop() { service stop kea-dhcp4-server; }
KeaRestart() { service restart kea-dhcp4-server; }

KeaTest() { SshHelper connect "$1.local" -- 'sudo dhclient -r; sudo dhclient'; ping "$1.local"; }

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
		IsPlatform win && IsMdnsName "$host" && { host="$(MdnsResolve "$host")" || return; }

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
alias FindSyncTxt='fa ".*_sync.txt"'
alias RemoveSyncTxt='FindSyncTxt | xargs rm'
alias HideSyncTxt="FindSyncTxt | xargs run.sh FileHide"

# TFTP
TftpLog() { IsPlatform qnap && LogShow "/share/Logs/opentftpd.log"; }

# web
urlencode() { echo "$1" | sed 's/ /%20/g'; }
curle() { curl "$(urlencode "$1")" "${@:2}"; } # curl encode - encode spaces in the URL

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
hib() { power hibernate "$@"; }
on() { power on "$@"; }; alias boot='on'
off() { power off "$@"; }; alias down='off'
slp() { power sleep "$@"; (( $# == 0 )) && cls; }
reb() { power reboot "$@"; }

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

# LogShow FILE [PATTERN]
LogShow()
{ 
	local sudo file="$1" pattern="$2"; [[ $pattern ]] && pattern=" $pattern"

	setterm --linewrap off
	SudoCheck "$1"; $sudo tail -f "$1" | grep "$pattern"
	setterm --linewrap on
}

# NetConsole

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

PiImageLite() { pi image "$(i dir)/platform/linux/Raspberry Pi/Raspberry Pi OS/2020-05-27-raspios-buster-lite-armhf.zip"; }

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

fu() { FindText "$1" "*" "$BIN"; FindText "$1" "*" "$UBIN"; } # FindUsages TEXT - find all script usages of specified TEXT
fuf() { fu "$@" | cut -d: -f1 | sort | uniq; } # FindUsagesFiles - find all script names that use the specified TEXT
fue() { fuf "$@" | xargs sublime; } # FindUsagesEdit - edit all script names that use the specified TEXT

#
# security
#

alias cred='credential'
SudoCheck() { [[ ! -r "$1" ]] && sudo="sudoc"; } # SudoCheck FILE - set sudo variable to sudoc if user does not have read permissiont o the file

# certificates
CertView() { openssl x509 -in "$1" -text; }

#
# SSH
#

alias s=sx	# connect with ssh
alias hssh="hyperv ssh" # connect to a Hyper-V host with ssh
alias sshconfig='e ~/.ssh/config'
alias sshkh='e ~/.ssh/known_hosts'

# informations
sshs() { IsSsh && echo "Logged in from $(RemoteServerName)" || echo "Not using ssh"; } # ssh status

# connecting

sm() { SshHelper connect --mosh "$@"; } # mosh
sx() { SshHelper connect -x "$@"; } 		# X forwarding
ssht() { ssh -t "$@"; } 				# allocate a pseudo-tty for screen based programs like sudo, i.e. ssht sudo ls /

# connect with additional startup scripts
sshfull() { ssh -t $1 ". /etc/profile; ${@:2}";  } # full environment
sshfunc() { ssh $1 ". function.sh; ${@:2}"; } # functions, sshfunc GetIpAddress
sshfuncx() { ssh -X $1 ". function.sh; ${@:2}"; } # functions and X forwarding (enables credential manager), i.e. sshfuncx sudoc ls
sshalias() { ssh -t $1 "bash -li -c \"${@:2}\""; } # ssh with aliases available, i.e. sshalias pi3 dirss

# connecting with additional permissions
sshsudo() { ssh -t $1 sudo ${@:2}; } # ssh using sudo (prompt for sudo password)
sshsudoc() { ssh -X $1 ". function.sh; sudoc ${@:2}"; } # ssh using sudoc (use credential store for sudo password)

# run applications
sterm() { sx -f $1 -t 'bash -l -c terminator'; } # sterminator HOST - start terminator on host, -f enables X11, bash -l forces a login shell

# SSH Agent - check and start the SSH Agent if needed
# - avoid password prompt - only start if there is a credential manager installed
# - avoid output - for clean PowerLevel 10K startup (Pass credential prompt requires output and input)
[[ -f "$HOME/.ssh/environment" ]] && . "$HOME/.ssh/environment"
if [[ $CREDENTIAL_MANAGER ]] && [[ "$CREDENTIAL_MANAGER" != "pass" ]] && ! ssh-add -L >& /dev/null; then
	SshAgentHelper start --quiet
fi

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
alias hv="hyperv"
hvc() { h console  "$1"; } 																												# console
hvoc() { h on "$1" && h console  "$1"; } 																					# on-console
hvct() { h create --type "$@" && h on "$2" && h console "$2"; } 									# create-type
hvcl() { hct linux "$@" ; } ; hcp() { hct pxe "$@" ; }; hcw() { hct win "$@" ; }  # create-linux

# vmware
vm() { vmware IsInstalled && VMware start || hyperv start; }
vmon() { vmware -n "$1" run start; } # on (start)
vmoff() { vmware -n "$1" run suspend; } # off (suspend)

#
# wiggin
#

# devices
cam() { wiggin device "$@" cam; }
wcore() { wiggin device "$@" core; }
wtest() { wiggin device "$@" test; }

# encrypted files
encm() { VeraCrypt mount "$CDATA/VeraCrypt/personal.hc" p; } 	# mount encrypted file share on drive p
encum() { VeraCrypt unmount p; }															# unmount encrypted file share from drive p

# media
mcd() { cd "//nas3/data/media"; }

# netboot
n3c() { cd "$(happconfig "$(ConfigGet "fs")")$1"; } # nas3 application configuration
n3d() { cd "$(happdata "$(ConfigGet "fs")")/$1"; } 	# nas3 application data

# network DNS and DHCP configuration
alias nae='TextEdit "$ncd/system/dns/forward.txt"'	# network alias edit
alias nce='wiggin network edit'											# network configuration edit
alias ncb='wiggin network backup all'								# network configuration backup
alias ncu='wiggin network update all all'						# network configuration update

# UniFi
alias uc='UniFiController'
SwitchPoeStatus() { ssh admin@$1 swctrl poe show; }

# update
u() { SshAgentCheck; HostUpdate "$@" || return; }

# web
n3w() { IsLocalHost "$(ConfigGet "web")" && cd "/share/Web" || cd "$(ConfigGet "webUnc")"; } # web directory
n3wc() { local f="$(unc mount "//$(ConfigGet "web")/root/etc/config/apache/extra/wiggin.conf")"; e "$f"; } # web configure

#
# windows
#

SetTitle() { printf "\e]2;$*\a"; }

# Xpra
xprac() { IsPlatform win && "$P/Xpra/xpra_cmd.exe" "$@" || xpra "$@"; } # client

xpraa() { coproc xprac attach "ssh://$1/$2"; } 	# attach
xprad() { xprac detach "ssh://$1/$2"; } 				# detatch
xpral() { s "$1" -- xpra list; } 								# list
xpras() { xprac exit "ssh://$1/$2"; } 					# exit
xprat() { coproc xprac start "ssh://$1" --start terminator; } # terminator

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