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

# debugging
# verbose="--verbose"
# force="--force"
export TIMEFORMAT='%R seconds elapsed'

# ensure DISPLAY is set first
InitializeXServer || return

# fix locale error
IsPlatform wsl2 && { LANG="C.UTF-8"; }

# keyboard
IsZsh && bindkey "^H" backward-kill-word

# options
IsBash && shopt -s autocd cdspell cdable_vars dirspell histappend direxpand globstar
IsZsh && { setopt no_beep; alias help="run-help"; }

#
# Application Configuration
#

[[ ! $ASDF_DIR && ! $force ]] && { SourceIfExists "$HOME/.asdf/asdf.sh" || return; } 	# ASDF
SourceIfExists "$HOME/.config/broot/launcher/bash/br" || return 											# broot
InPath direnv && eval "$(direnv hook "$PLATFORM_SHELL")"															# direnv
[[ ! $EDITOR_CHECKED ]] && { SetTextEditor; EDITOR_CHECKED="true"; } 									# editor
[[ -d "$HOME/.fzf" ]] && InPath "FzfInstall.sh" && { . FzfInstall.sh || return; }			# fzf
[[ -d "/usr/games" ]] && PathAdd "/usr/games" 																				# games on Ubuntu 19.04+
[[ -d "$HOME/go/bin" ]] && PathAdd "$HOME/go/bin"																			# Go
SourceIfExists "$HOME/.ghcup/env" || return																						# Haskell
PathAdd front "/opt/local/bin" "/opt/local/sbin" 																			# Mac Ports
SourceIfExists "$HOME/.rvm/scripts/rvm" || return  																		# Ruby Version Manager
[[ -d "$HOME/.cargo/bin" ]] && PathAdd "$HOME/.cargo/bin" 														# Rust
PathAdd "/opt/X11/bin" 																																# XQuartz
PythonConf || return

# browser - for sensible-browser command
if firefox IsInstalled; then export BROWSER="firefox"
elif chrome IsInstalled; then export BROWSER="chrome"
fi

# Homebrew
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
	export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
	export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
	export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew";
fi

if [[ $HOMEBREW_PREFIX ]]; then
	PathAdd front "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" # use Homebrew utilities before system utilities
	InfoPathAdd "$HOMEBREW_PREFIX/share/info"
	ManPathAdd "$HOMEBREW_PREFIX/share/man"
fi

# Visual Studio Code
[[ -d "$UADATA/Programs/Microsoft VS Code/bin" ]] && PathAdd "$UADATA/Programs/Microsoft VS Code/bin"

#
# locations
#

tmp() { cd "$TMP"; }
b="$BIN" bin="$BIN" pd="$PUB/Desktop" pub="$PUB" data="$DATA" win="$DATA/platform/win"
home="$HOME" doc="$DOC" dl="$HOME/Downloads" code="$CODE"
ubin="$HOME/data/bin" ud="$HOME/Desktop" udata="$HOME/data"  	# user
p="$P"								 																				# programs
adata="$DATA/appdata" adataw="$DATA/appdataw"

if IsPlatform win; then
	p32="$P32"																																	# programs
	psm="$PROGRAMDATA/Microsoft/Windows/Start Menu"; pp="$psm/Programs" 				# public
	usm="$UADATA/../Roaming/Microsoft/Windows/Start Menu"; up="$usm/Programs"		# user
	wcode="$WIN_CODE" wh="$WIN_HOME" 	
fi

# Dropbox
if [[ -d "$home/Dropbox" ]]; then
	cloud="$home/Dropbox"; c="$cloud"; cdata="$cloud/data"; cdl="$cdata/download"; ccode="$c/code"
	jh="$HOME/Juntos Holdings Dropbox" jhc="$HOME/Juntos Holdings Dropbox/Company"
	IsPlatform win && alias jh='"$WIN_HOME/Juntos Holdings Dropbox/Company"'
	ncd="$cloud/network"; alias ncd="$ncd" # network configuration directory
	confDir="$ncd/system"	
fi

alias cdv="cd ~/Volumes"

# application data and configuration directories
aconfig() { IsLocalHost "$1" && echo "$ACONFIG" || echo "//$1/admin$ACONFIG"; }
adata() { IsLocalHost "$1" && echo "$ADATA" || echo "//$1/admin$ADATA"; }
acd() { ScriptCd appdata "$1"; }

#
# other
#

cls() { clear; }
ei() { TextEdit $bin/inst; }
ehp() { start "$udata/replicate/default.htm"; }
st() { startup --no-pause "$@"; }

#
# applications
#

alias f='firefox'
alias grep='command grep --color=auto'
alias m='merge'

e() { TextEdit "$@"; }
figlet() { pyfiglet "$@"; }
bcat() { InPath batcat && batcat "$@" || command cat "$@"; }
terminator() { coproc /usr/bin/terminator "$@"; }

if IsPlatform mac; then
	code() { "$P/Visual Studio Code.app/Contents/Resources/app/bin/code" "$@"; }
elif IsPlatform win; then
	code() { "$P/Microsoft VS Code/Code.exe" "$@"; }
fi

#
# archive
#

alias fm='start "$p/7-Zip/7zFM.exe"'
alias untar='tar -z -v -x --atime-preserve <'
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
efa() { local files; GetPlatformFiles "$bin/function." ".sh" || return 0; TextEdit "${files[@]}" $bin/function.sh; }  	# edit all functions

alias estart="e /etc/environment /etc/profile /etc/bash.bashrc $BIN/bash.bashrc $UBIN/.profile $UBIN/.bash_profile $UBIN/.zlogin $UBIN/.p10k.zsh $UBIN/.zshrc $UBIN/.bashrc"
alias kstart='bind -f ~/.inputrc' ek='e ~/.inputrc'
alias ebo='e ~/.inputrc /etc/bash.bash_logout ~/.bash_logout'

sfull() # set full
{
	declare {CREDENTIAL_MANAGER_CHECKED,COLORLS_CHECKED,EDITOR_CHECKED,FZF_CHECKED,NETWORK_CHECKED}="" 	# .bashrc
	declare {PLATFORM,PLATFORM_LIKE,PLATFORM_ID}=""																											# bash.bashrc
	declare {CHROOT_CHECKED,VM_TYPE_CHECKED,HASHI_CHECKED}=""																						# function.sh

	. "$bin/bash.bashrc"
	. "$bin/function.sh"
	IsZsh && { . ~/.zshrc; } || { kstart; . ~/.bash_profile; }
}

#
# completion
#

if [[ ! $COLORLS_CHECKED ]]; then
	unset COLORLS
	if InPath colorls; then
		COLORLS="true"
		. "$(GetFilePath "$(gem which colorls 2> /dev/null)")/tab_complete.sh" # slow .1s
	fi
	COLORLS_CHECKED="true"
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

#
# Data Types
#

DumpBytes() { od --address-radix d -t x1 -t c -t a; } # echo -en "01\\n" | DumpBytes

# date/time

clock() { ClockHelper start; }
clockt() { ClockHelper terminal; } 		# clock terminal
clockc() { ClockHelper check; } 			# clock check
clockdiff() { ClockHelper diff; } 		# clock difference

#
# cron
#

CronLogShow() { LogShow "/var/log/cron.log" "$1"; }
IncronLogShow() { LogShow "/var/log/syslog" "incron"; }
SysLogShow() { LogShow "/var/log/syslog" "$@"; }
SysLogShowAll() { LogShowAll "/var/log/syslog" "$@"; }

#
# development
#

codev() { command rich "$@" -n -g --theme monokai; } # code view

# C
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# DOT.NET Development

if [[ -d "$HOME/.dotnet" ]]; then
	PathAdd "$HOME/.dotnet"; export DOTNET_ROOT="$HOME/.dotnet"
elif [[ -d "$P/dotnet" ]]; then
	PathAdd "$P/dotnet"; export DOTNET_ROOT="$P/dotnet"
fi
! InPath dotnet && IsPlatform win && { alias dotnet="dotnet.exe"; }

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

[[ ! $LS_COLORS && -f "$ubin/default.dircolors" ]] && InPath dircolors && eval "$(dircolors "$ubin/default.dircolors")"

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
dirss() { local args=(); ! InPath exa && args+=(--reverse); DoLs -l --sort=size "${args[@]}" "$@"; } 													# sort by size
dirst() { local args=(); ! InPath exa && args+=(--reverse); DoLs -l --sort=time "${args[@]}" "$@"; } 													# sort by last modification time
dirsct() { local args=(); ! InPath exa && args+=(--reverse); DoLs --native -l --time=ctime --sort=time "${args[@]}" "$@"; } 	# sort by creation time

DoCd()
{
	IsUncPath "$1" && { ScriptCd unc mount "$1"; return; }
	builtin cd "$@"
}

DoLs()
{
	local unc="${@: -1}" # last argument
	
	if IsUncPath "$unc"; then
		local dir; dir="$(unc mount "$unc")" || return	
		set -- "${@:1:(( $# - 1 ))}" "$dir"
	fi

	if InPath exa; then
		exa --ignore-glob "desktop.ini" --classify --group-directories-first "$@"
	elif [[ ! $COLORLS || "$1" == "-d" || "$1" == "--native" || "$1" == "--full-time" ]]; then
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
alias dsu='DiskSpaceUsage'					# disk space usage
tdug() { sudoc ncdu --color=dark -x /; } 							# total disk usage graphical
tdu() { di -d m | head -2 | tail -1 | tr -s " " | cut -d" " -f4; } # total disk usage in MB
tdud() { local b="$(tdu)"; pause; echo "$(echo "$(tdu) - $b" | bc)MB"; } # total disk usage difference in MB
dus() { ${G}du --summarize --human-readable "$@" |& grep -Ev "Permission denied|Transport endpoint is not connected"; } # disk usage summary

ListPartitions() { sudo parted -l; }
ListDisks() { sudo parted -l |& grep -i '^Disk' |& grep -Ev 'Error|Disk Flags' | cut -d' ' -f2 | cut -d: -f1; }
ListFirstDisk() { ListDisks | head -1; }
pm() { PartitionManager "$@"; }

#
# display
#

alias ddm='DellDisplayManager'
FullWakeup() { ssh "$1" caffeinate  -u -w 10; }
sw() { ddm switch "$@"; } # switch monitor

# swe - switch monitor to ender
swe()
{
	[[ "$HOSTNAME" == "ender" ]] && return
	FullWakeup ender &
	ddm switch
}

#
# file management
#

alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'
alias .....='cbuiltin d ../../../..'

function c() { [[ $# == 0 ]] && cls || credential "$@"; }
cb() { builtin cd ~; cls; } 	# clear screen and cd
cf() { cb; InPath cowsay fortune lolcat && cowsay "$(fortune --all)" | lolcat; return 0; } # clear both, fortune
ch() { cb; InPath pyfiglet lolcat && pyfiglet --justify=center --width=$COLUMNS "$(hostname)" | lolcat; return 0; } # clear both, host

alias del='rm'
alias md='mkdir'
alias rd='rmdir'

alias inf="FileInfo"
alias l='explore'
alias rc='CopyDir'

lcf() { local f="$1"; mv "$f" "${f,,}.hold" || return; mv "${f,,}.hold" "${f,,}" || return; } # lower case file

FileTypes() { file * | sort -k 2; }

#
# DriveTime
#

alias ah='AzureHelper'
dtc="$c/group/DriveTime" # DriveTime Cloud personal files
alias dtc="$dtc"; alias dtcp="$dtc/projects"
alias dt-setsub-dev='az account set --subscription 8bc2fde5-e1ad-4bc0-9287-85957096f0b4'
alias dt-setsub-prod='az account set --subscription a1eab4f0-e17c-4e70-ab04-833c063dc515'
alias dt-get-cred='az aks get-credentials -g dtwt-aks-devops-rg -n dtwt-aks-devops01-k8'
alias dt-get-cred-devtest='az aks get-credentials -g dtwt-aks-devtest-rg -n dtwt-aks-devtest01-k8'
alias dt-get-cred-prodw='az aks get-credentials -g dtwt-aks-prod-rg -n dtwt-aks-prod01-k8'
alias dt-get-cred-prode='az aks get-credentials -g dtwt-aks-prod-rg -n dtet-aks-prod01-k8'
alias dt-new-token='az login --scope https://management.core.windows.net//.default'

# run in domain
dedge() { dtRun "$P32/Microsoft/Edge/Application/msedge.exe" --profile-directory=Default; }
dff() { dtRun "$P/Mozilla Firefox/firefox.exe"; }
dssms() { dtRun "$P32/Microsoft SQL Server Management Studio 18/Common7/IDE/Ssms.exe"; }
dvs() { dtRun "$P/Microsoft Visual Studio/2022/Preview/Common7/IDE/devenv.exe"; }
dvsp() { dtRun "$P/Microsoft Visual Studio/2022/Preview/Common7/IDE/devenv.exe"; }

vsne() { hstart64.exe /NOCONSOLE /NONELEVATED "$(utw "$P/Microsoft Visual Studio/2022/Professional/Common7/IDE/devenv.exe")"; }

#
# find
#

alias fa='FindAll'
alias fcd='FindCd'
alias fclip='FindClip'
alias fs='FindStart'
alias ft='FindText'
alias ftf='FindTextFile'

FindAll() {	fd "$@" --one-file-system; }																											# FindAll PATTERN - find all files that match the pattern from the current directory
FindClip() { local files; IFS=$'\n' ArrayMakeC files FindAll "$1" && clipw "${files[@]}"; }
FindStart() { start "$(FindAll "$@" | head -1)"; }
FindText() { grep --color -ire "$1" --include="$2" --exclude-dir=".git" "${3:-.}"; } 					# FindText TEXT FILE_PATTERN [START_DIR](.) - find all text in files matching the pattern, starting at the start directory
FindTextFile() { FindText "$@" | cut -d: -f1 | sort | uniq; }																	# FindTextFiles - similar to FindText, but find all file names

fe() { FindAll "$@" | xargs sublime; } 					# FindEdit PATTERN - find files and edit
fte() { FindTextFile "$@" | xargs sublime; } 		# FindTextEdit TEXT PATTERN - find text in files and edit
ftl() { grep -iE "$@" *; } 											# Find Text Local - find specified text in the current directory

fsql() { ft "$1" "*.sql"; } # FindSql TET
esql() { fte "$1" "*.sql"; } # EditSql TEXT
fsqlv() { fsql "-- version $1"; } # FindSqlVersion [VERSION]
esqlv() { esql "-- version $1"; } # EditSqlVersion [VERSION]
msqlv() { fsqlv | cut -f 2 -d : | cut -f 3 -d ' ' | grep -Eiv "deploy|skip|ignore|NonVersioned" | sort | tail -1; } # MaxSqlVersion

eai() { fte "0.0.0.0" "VersionInfo.cs"; } # EditAssemblyInfo that are set to deploy (v0.0.0.0)

FindCd()
{
	local dir="$(FindAll "$@" | head -1 | GetFilePath)"
	[ ! -d "$dir" ] && { ScriptErr "Could not find a directory matching '$@'"; return 1; }
	cd "$dir"
}

#
# DriveTime network
#

# dtRun PROGRAM [ARGS] – run a program as a DriveTime domain user
dtRun() 
{ 
	IsInDomain && { "$@"; return; } # we are in the domain, just run the program
	runas.exe /netonly /user:$(ConfigGet "dtAdDomain")\\$(ConfigGet "dtUser") "\"$(utw "$(FindInPath "$1")")\" ${@:2}" 
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

g() { SshAgentConf && git "$@"; }
gcd() { ScriptCd GitHelper github dir "$@"; }
gcdw() { ScriptCd GitHelper github dir --windows "$@"; }
ghlp() { SshAgentConf && GitHelper "$@"; }
ghc() { GitClone "$@"; }
ghcw() { GitClone --windows "$@"; }
gg() { SshAgentConf && GitHelper gui "$@"; }

alias ga='g add'
alias gd='g diff'
alias gf='gc freeze'
alias gl='g logb; echo'					# log
alias gla='g loga'							# log all
alias gca='g ca'								# commit all
alias gcam='g amendAll'					# commit ammend all
alias gco='g push --set-upstream origin master' # git configure origin
alias gs='ghlp changes'   			# status
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
alias lg='lazygit'

# gdir SERVER - change to the git directory on SERVER for repo creation
gdir() { cd "$(GitHelper remote dir "$@")"; }

gfd() # git fuzzy diff
{
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

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
# HashiCorp
#

alias h="hashi"
hcd() { cd "$ncd/system/hashi/$1"; }

hconf() { [[ "$NETWORK" != "hagerman" ]] && return; HashiConf --config-prefix=prod "$@" && hashi config status; } # hc - hashi config
hct() { HashiConf --config-prefix=test "$@" && hashi status; } # hct - hashi config test
hr() { hashi resolve "$@"; }	# hr SERVER - resolve a consul service address
hs() { hashi status; }
hsr() { HashiServiceRegister "$@"; } # hsr SERVICE_FILE - register a Nomad service

# test
hti() { wiggin setup hashi test -- "$@" && HashiConf test; }									# Hashi Test Install
htr() { wiggin remove hashi test --force -- --yes "$@"; HashiConf reset; }		# Hashi Test Clean

# run program and set configuration if necessary
consul() { HashiConfConsul && command consul "$@"; }
nomad() { HashiConfNomad && command nomad "$@"; }
vault() { HashiConfVault && command vault "$@"; }

# put token for a HashiCorp program into the clipboard
clipc() { HashiConfConsul && clipw "$CONSUL_HTTP_TOKEN"; }
clipn() { HashiConfNomad && clipw "$NOMAD_TOKEN"; }
clipv() { HashiConfVault && clipw "$VAULT_TOKEN"; }

# HashiCorp - Nomad
j() { hashi nomad job "$@"; }	# job
NomadApps() { hashi app node status --active; }
NomadAllocations() { hashi nomad node allocations -H=active; }

# HashiCorp - Vagrant
vagrant() { "$WIN_ROOT/HashiCorp/Vagrant/bin/vagrant.exe" "$@"; }
vcd() { cd "$WIN_HOME/data/app/vagrant"; }

#
# Home Automation
#

# Home Assistant

hassUser="homeassistant" hassService="home-assistant@$hassUser"

hass() { HomeAssistant "$@"; }
hass-conf() { ScriptEval HomeAssistant cli vars "$@"; }
hass-config() { sudoe ~"homeassistant/.homeassistant/configuration.yaml" && yamllint ~"homeassistant/.homeassistant/configuration.yaml"; }
hass-shell() { SwitchUser "$hassUser"; }

hass-log() { service log "$hassService" "$@"; }
hass-restart() { service restart "$hassService" "$@"; }
hass-start() { service start "$hassService" "$@"; }
hass-status() { service status "$hassService" "$@"; }
hass-stop() { service stop "$hassService" "$@"; }

hass-cli()
{
	# validate installed
	! InPath hass-cli && { ScriptErr "hass-cli is not installed" "hass-cli"; return 1; }

	# arguments
	local arg args=() force
	for arg in "$@"; do
		[[ "$arg" == @(-f|--force) ]] && { force="--force"; continue; }
		args+=( "$arg" )
	done
	set -- "${args[@]}"

	# configuration
	[[ $force || ! $HASS_TOKEN || ! $HASS_SERVER ]] && { hass-conf $force || return; }

	# run
	command hass-cli "$@"
}

# homebridge
alias hh='HomebridgeHelper'
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

# Node-RED
alias nrshell="SwitchUser nodered"
NodeRedCode() { cd "$HOME/.node-red/projects/$1"; }; alias nrc="NodeRedCode"

#
# Kubernetes
#

alias k="kubectl"
kcinit() { ! InPath kubectl && return; eval "$(kubectl completion "$PLATFORM_SHELL")"; } # kubectl initialization - initialize completion

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
DiskTestAll() { bonnie++ | tee >> "$(os name)_performance_$(GetDateStamp).txt"; }

DiskTestRead()
{ 
	local device="${1:-$(di | head -2 | tail -1 | cut -d" " -f1)}"
	sudo hdparm -t "$device"; 
} 

# [DEST](disktest) [COUNT] - # use smaller count for Pi and other lower performance disks
DiskTestWrite() 
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
iperfs() { echo iPerf3 server is running on $(hostname); iperf3 -s -p 5002 "$@"; } # server
iperfc() { iperf3 -c $1 -p 5002 "$@"; } # client

#
# platform
#

alias hc='HostCleanup'

#
# projects
#

#
# network
#

ScriptEval network proxy vars || return

clf() { CloudFlare "$@"; }
ncg() {	network current all; } # network current get
ncu() {	network current update "$@" && ScriptEval network vars; } # network current update
PortUsage() { IsPlatform win && { netstat.exe -an; return; }; sudoc netstat -tulpn; }
PingFix() { sudoc chmod u+s "$(FindInPath ping)" || return; }
DnsSuffixFix() { echo "search $(ConfigGet "domain")\n" | sudo tee -a "/etc/resolv.conf" || return; }

# ping HOST - resolves virtual hostnames
p()
{
	local host="$1"
	local ip; ip="$(GetIpAddress "$host" --quiet)" || ip="$(GetIpAddress "$HOSTNAME-$host" --quiet)" || { HostUnresolved "$host"; return; }
	IsAvailable "$ip" && { echo "available"; return 0; } || { echo "not available"; return 1; }
}

# backup
abd() { . app.sh; ScriptCd AppGetBackupDir; } # app backup dir

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

alias BindLog='service log bind9'
alias NamedLog='service log bind9'

# mDNS
MdnsList() { avahi-browse  -p --all -c | grep _device-info | cut -d';' -f 4 | sort | uniq; }
MdnsListFull() { avahi-browse -p --all -c -r; }
MdnsPublishHostname() { avahi-publish-address -c $HOSTNAME.local "$(GetPrimaryIpAddress eth0)"; }
MdnsTest() { local h; for h in $(GetAllServers); do h="$(RemoveDnsSuffix "$h")"; printf "$h: "; MdnsResolve $h.local; done; }

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

# NginxConfWatch CONF [PATTERN] - watch a configuration file for changes
NginxConfWatch() { cls; FileWatch "/etc/nginx/sites-available/$1.conf" "${2:-  server }"; }

# proxy server
alias ProxyEnable="ScriptEval network proxy vars --enable; network proxy vars --status"
alias ProxyDisable="ScriptEval network proxy vars --disable; network proxy vars --status"
alias ProxyStatus="network proxy --status"

# salt
RunAll() { a="$@"; sudoc salt '*' cmd.run "/usr/local/data/bin/RunScript $a"; }

# Squid Proxy Server
SquidLog="$HOME/Library/Logs/squid/squid-access.log"
SquidLog() { LogShow "$SquidLog"; }
SquidCheck() { IsAvailablePort proxy.butare.net 3128; }
SquidHits() { grep "HIER_NONE" "$SquidLog"; }
SquidRestart() { sudo /etc/init.d/ProxyServer.sh restart; }
SquidUtilization() { squidclient -h "${1:-127.0.0.1}" cache_object://localhost/ mgr:utilization; }
SquidInfo() { squidclient -h "$1" cache_object://localhost/ mgr:info; }

# sync files
alias slf='SyncLocalFiles sync'
alias FindSyncTxt='fa ".*_sync.txt"'
alias RemoveSyncTxt='FindSyncTxt | xargs rm'
alias HideSyncTxt="FindSyncTxt | xargs run.sh FileHide"

# TFTP
TftpConf() { sudoe "/etc/default/tftpd-hpa"; }
TftpRestart() { service restart tftpd-hpa; }
TftpLog() {	if IsPlatform qnap; then LogShow "/share/Logs/opentftpd.log"; else sudor RunScript LogShow "/var/log/syslog"; fi; }

# Virtual IP (VIP)
VipResolve() { local lb="${1:-lb}" mac; MacLookupInfo "$lb"; }

VipStatus()
{
	local lb="${1:-lb}" names; echo "Press any key to stop resolving load balancer ($lb)..."
	while true; do names="$(MacLookupName "$lb" | sed 's/\..*$//' | sort | NewlineToSpace)" && echo "$lb: $names"; ReadChars 1 1 && return; done
}

# web
awd() { ScriptCd apache dir web "$@" && ls; }		# Apache Web Dir
curle() { curl "$(urlencode "$1")" "${@:2}"; } 	# curl encode - encode spaces in the URL
HttpHeader() { curl --silent --show-error --location --dump-header - --output /dev/null "$1"; }
HttpServer() { HttpHeader "$1" | grep --ignore-case "X-Server" | cut -d: -f2 | RemoveCarriageReturn | RemoveSpaceTrim; }
HttpLbTest() { PiSsh 'curl --silent https://web.butare.net/info.php | grep NOMAD_HOST= | cut -d= -f2 | cut -d\< -f1'; } # test the HTTP load balancer from all Rasberry Pi servers

CheckAll()
{
	local service="${1:-web}" port="${2:-80}" urlPath="$3"

	for host in $(hashi resolve name --all "$service"); do
		local url="http://$host:$port/$urlPath"
		hilight "Checking $url..."
		curl --silent --location "$url" | head -10 || return
	done
}

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
slp() { power sleep "$@"; local result="$?"; (( $# == 0 )) && cls; return "$result"; }
reb() { power reboot "$@"; }

logoff()
{
	local user="${${1}:-$USER}"

	if IsSsh; then exit
	elif IsPlatform win; then logoff.exe
	elif IsPlatform ubuntu; then gnome-session-quit --no-prompt
	elif IsPlatform mac; then sudoc launchctl bootout "user/$(id -u "$user")"
	else EchoErr "logoff: logoff not supported"; return 1;
	fi		
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

# NetConsole

LogNetConsole() { sudov && netconsole -l -u $(GetIpAddress) 6666 | sudo tee /var/log/netconsole.log; }

NetConsoleEnable() # HOST
{
	local host="$1"
	[[ ! $host ]] && { MissingOperand "host" "NetConsoleEnable"; return 1; }

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
pscountm() { while true; do printf "process count: "; pscount; sleep 1; done; }

#
# python
#

alias py='python3'
alias pip='py -m pip'
alias FixPythonPackage='sudo -H pip3 install --ignore-installed' # if get distutils error

PyInfo() { pip show "$@"; }
PyLocation() { python3 -c "import $1 as _; print(_.__file__)"; } ; # PyLocation MODULE - location of specified module, i.e. PyLocation 'pip._internal.cli.main'
PySite() { py -m site; }

#
# Raspberry Pi
#

PiHosts() { GetAllServers; }
PiHostsOn() { consul members | grep " alive " | tr -s " " | cut -d" " -f1 | sort -V; } # PiHostsOn - show all pi hosts that are on
PiHostsOff() { consul members | grep " left " | tr -s " " | cut -d" " -f1 | sort -V; } # PiHostsOff - show all pi hosts that are off
PiImageLite() { pi image "$(i dir)/platform/linux/Raspberry Pi/Raspberry Pi OS/2020-05-27-raspios-buster-lite-armhf.zip"; }
PiShell() { sx --host=all "$@"; } 																			# PiShell - run a shell on all servers
PiSsh() { sx --host=all --errors --function --pseudo-terminal "$@"; } 	# PiSsh COMMAND - run a command on all servers

#
# Scheduled Tasks
#

alias lst='ListScheduledTasks'

ListScheduledTasks()
{
	! IsPlatform win && return
	schtasks.exe /Query /xml
}

#
# scripts
#

mint() { e "$ccode/bash/template/min" "$ccode/bash/template/app"; } # bash min template
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

cred() { credential "$@"; }
cms() { credental manager status "$@"; }
1conf() { ScriptEval 1PasswordHelper unlock "$@" && 1PasswordHelper status; }
cconf() { CredentialConf --unlock "$@" && credential manager status; }
cm() { cred manager "$@"; }
cms() { cred manager status "$@"; }

CertGetDates() { local c; for c in "$@"; do echo "$c:"; openssl x509 -in "$c" -text | grep "Not "; done; }
CertGetPublicKey() { openssl x509 -noout -pubkey -in "$1"; }
CertKeyGetPublicKey() { openssl pkey -pubout -in "$1"; }
CertVerifyKey() { [[ "$(CertGetPublicKey "$1")" == "$(CertKeyGetPublicKey "$2")" ]]; } # CertVerify CERT KEY - validate the private key if for the certificate
CertVerifyChain() { openssl verify -verbose -CAfile <(cat "${@:2}") "$1";  } # CertVerifyChain CERT CA...
SwitchUser() { local user="$1"; cd ~$user; sudo --user=$user --set-home --shell bash -il; }

#
# SSH
#

sconf() { SshAgentConf "$@" && SshAgent status; }

alias s=sx													# connect with ssh
alias hvs="hyperv connect ssh" 			# connect to a Hyper-V host with ssh
alias sshconfig='e ~/.ssh/config'
alias sshkh='e ~/.ssh/known_hosts'

# information
sshs() { IsSsh && echo "Logged in from $(RemoteServerName)" || echo "Not using ssh"; } # ssh status

# connect
sm() { SshHelper connect --mosh "$@"; } # mosh
ssht() { ssh -t "$@"; } 								# allocate a pseudo-tty for screen based programs like sudo, i.e. ssht sudo ls /
sx() { SshAgentConf --quiet && HashiConf --quiet && SshHelper connect --x-forwarding --hashi "$@"; } # sx - X forwarding and supply passwords where possible

# connect with additional startup scripts
sshfull() { ssh -t $1 ". /etc/profile; ${@:2}";  } # full environment
sshalias() { ssh -t $1 "bash -li -c \"${@:2}\""; } # ssh with aliases available, i.e. sshalias pi3 dirss

# run applications
sterm() { sx -f $1 -t 'bash -l -c terminator'; } # sterminator HOST - start terminator on host, -f enables X11, bash -l forces a login shell

#
# sound
#

alias sound='os sound'
alias TestSound='playsound "$data/setup/test.wav"'

playsound()
{ 
	InPath play && { play "$@"; return; } # requires sox
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
UnsetVars() { eval unset \${\!$1*}; }

#
# Virtual Machine
#

# chroot
alias cr="ChrootHelper"
alias crdown="schroot --all-sessions --end-session"

# docker
alias dk='docker'
alias dki='docker images'
alias dks='docker service'
alias dkrm='docker rm'
alias dkl='docker logs'
alias dklf='docker logs -f'
alias dkflush='docker rm `docker ps --no-trunc -aq`'
alias dkflush2='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias dkt='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'
alias dkps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"

# hyper-v
alias hv="hyperv"
hvc() { hv console  "$1"; } 								# console
hvoc() { hv on "$1" && hv console  "$1"; } 	# on-console
hvct() { hv create --type "$@" --start; } 	# create-type
hvcl() { hvct linux "$@"; }
hvcp() { hvct pxe "$@"; }
hvcrh() { hvct rh "$@"; }
hvcw() { hvct win "$@" ; }

# vmware
vm() { vmware IsInstalled && VMware start || hyperv start; }
vmon() { vmware -n "$1" run start; } # on (start)
vmoff() { vmware -n "$1" run suspend; } # off (suspend)

#
# Wiggin Network
#

sd="$UDATA/sync" 														# sync dir
sdn="$UDATA/sync/etc/nginx/sites-available" # sync dir Nginx

aconf() { hconf && echo && sconf && echo && cconf --unlock; } # all configure
aconfe() { aconf && exit; } 																	# all configure then exit the shell, useful with PiShell
vpn() { network vpn "$@"; }

# devices
cam() { wiggin device "$@" cam; }
wcore() { wiggin device "$@" core; }
wtest() { wiggin device "$@" test; }

# encrypted files
encm() { VeraCrypt mount "$cdata/VeraCrypt/personal.hc" p; } 	# mount encrypted file share on drive p
encum() { VeraCrypt unmount p; }															# unmount encrypted file share from drive p

# media
mcd() { cd "//nas3/data/media"; } # mcd - media CD

# files
hadcd() { cd "$(appdata "$1")/$2"; } # hadcd HOST DIR - host appdata cd to directory

# backup
bdir() { cd "$(appdata "$(network current server backup --service=smb)")/backup"; } # backup dir

# borg
alias bh='BorgHelper'
bconf() { BorgConf "$@" && BorgHelper status; }
borg() { [[ ! $BORG_REPO ]] && { BorgConf || return; }; command borg "$@"; }
bb() { BorgHelper backup "$@" --archive="$(RemoveTrailingSlash "$1" | GetFileName)"; } # borg backup
bcd() { hadcd "${1:-$HOSTNAME}" "borg"; } 								# borg cd [HOST]
bm() { ScriptCd BorgHelper mount "$@"; }									# borg mount
bs() { BorgHelper status "$@"; }													# borg status
bum() { BorgHelper unmount "$@"; }												# borg unmount
clipb() { BorgConf "$@" && clipw "$BORG_PASSPHRASE"; }

# bbh DIR HOSTS - borg backup hosts
bbh()
{
	local dir="$1" host hosts; StringToArray "$2" "," hosts; shift 2
	for host in "${hosts[@]}"; do bb "$dir" --host="$host" "$@" || return; done
} 

# network DNS and DHCP configuration
alias ne='wiggin network edit'										# network edit
alias nep='e $DATA/setup/ports'										# network edit poirt
alias nb='wiggin network backup all'							# network backup
alias nua='wiggin network update all'					# network update all
alias nud='wiggin network update dns'					# network update DNS
alias nudh='wiggin network update dhcp'				# network update DHCP

# QNAP
qr() { qnap cli run -- "$@"; } # qcli run - run a QNAP CLI command

# UniFi
alias uc='UniFiController'
SwitchPoeStatus() { ssh admin@$1 swctrl poe show; }

# update
u() { SshAgentConf && HostUpdate "$@"; }

#
# windows
#

SetTitle() { printf "\e]2;$*\a"; }

# Xpra
xprac() { if IsPlatform win; then "$P/Xpra/xpra_cmd.exe" "$@"; else xpra "$@"; fi; } # client

XpraConnect() { echo "ssh://$USER@$(os name "$1")/$2"; }
XpraCheck() { plink.exe "$USER@$(os name "$1")"; } # store SSH key in cache

XpraConf() { RunPlatform XpraConf "$@"; }
XpraConfMac() { "$P/Xpra.app/Contents/Helpers/Config_info" "$@"; }
XpraConfWin() { "$P/Xpra/Config_info.exe" "$@"; }

XpraPaths() { RunPlatform XpraPaths "$@"; }
XpraPathsMac() { "$P/Xpra.app/Contents/Helpers/Path_info" "$@"; }
XpraPathsWin() { "$P/Xpra/Path_info.exe" "$@"; }

xpraa() { xprac attach "$(XpraConnect "$@")/$2"; } 						# attach
xprad() { xprac detach "$(XpraConnect "$@")/$2"; } 						# detatch
xprae() { xprac exit "$(XpraConnect "$@")/$2"; } 							# exit
xpral() { s "$1" -- xpra list; } 															# list
xpras() { xprac start "$(XpraConnect "$@")" --start "$2"; } 				# start
xprat() { xprac start "$(XpraConnect "$@")" --start terminator; } 	# terminator
ln1t() { xprat ln1; } 																							# ln1 terminator

#
# xml
#

alias XmlValue='xml sel -t -v'
alias XmlShow='xml sel -t -c'

#
# final
#

# SSH Agent environment
[[ ! $SSH_AUTH_SOCK || $force ]] && ScriptEval SshAgent environment --quiet

# network
[[ ! $NETWORK_CHECKED || $force ]] && { ScriptEval network vars; NETWORK_CHECKED="true"; }

# credential manager environment
[[ ! $CREDENTIAL_MANAGER_CHECKED || $force ]] && CredentialConf $verbose $force --quiet

# platform specific .bashrc
SourceIfExistsPlatform "$UBIN/.bashrc." ".sh" || return

# McFly - initialie last since
# - must be after after set prompt as this modifies the bash prompt
# - sometimes it prevents the rest of the script from running
if InPath mcfly && [[ "$__MCFLY_LOADED" != "loaded" ]] && [[ "$TERM_PROGRAM" != @(vscode) ]]; then
	eval "$(mcfly init "$PLATFORM_SHELL")"
fi

return 0