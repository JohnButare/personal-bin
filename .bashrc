# TimerOn

# ensure bash.bashrc and function.sh have been sourced
[[ ! $BIN || ! $FUNCTIONS ]] && { BASHRC="/usr/local/data/bin/bash.bashrc"; [[ -f "$BASHRC" ]] && . "$BASHRC"; }

# non-interactive initialization - available from child processes and scripts, i.e. ssh <script>
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# return if not interactive
[[ "$-" != *i* ]] && return

#
# Interactive Configuration
#

# arguments
quiet="--quiet"
#verbose=-vv verboseLevel=2
ScriptOptForce "$@" || return
ScriptOptVerbose "$@" || return
[[ $verbose ]] && unset quiet

export TIMEFORMAT='%R seconds elapsed'
alias tc='TimeCommand'

# ensure DISPLAY is set first
InitializeXServer || return

# fix locale error
IsPlatform wsl2 && { LANG="C.UTF-8"; }

# keyboard
IsZsh && bindkey "^H" backward-kill-word

# options
IsBash && shopt -s autocd cdspell cdable_vars dirspell histappend direxpand globstar

if IsZsh; then
	setopt no_beep

	# help
	unalias run-help >& /dev/null; autoload run-help
	HELPDIR=/usr/share/zsh/"${ZSH_VERSION}"/help
	alias help=run-help
fi

#
# Application Configuration
#

[[ ! $ASDF_DIR && ! $force ]] && { SourceIfExists "$HOME/.asdf/asdf.sh" || return; } 	# ASDF
SourceIfExists "$HOME/.config/broot/launcher/bash/br" || return 											# broot
[[ -d "/usr/games" ]] && PathAdd "/usr/games" 																				# games on Ubuntu 19.04+
[[ -d "$HOME/go/bin" ]] && PathAdd "$HOME/go/bin"																			# Go
SourceIfExists "$HOME/.ghcup/env" || return																						# Haskell
IsiTerm && { SourceIfExists "$HOME/.iterm2_shell_integration.zsh" || return; }				# iTerm
PathAdd front "/opt/local/bin" "/opt/local/sbin" 																			# Mac Ports
SourceIfExists "$HOME/.rvm/scripts/rvm" || return  																		# Ruby Version Manager
[[ -d "$HOME/.cargo/bin" ]] && PathAdd "$HOME/.cargo/bin" 														# Rust
export BROWSER="firefox" 																															# sensible-browser
PathAdd "/opt/X11/bin" 																																# XQuartz

# Homebrew
if ! IsPlatform mac && [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
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
[[ -d "$PUSER/Microsoft VS Code/bin" ]] && PathAdd "$PUSER/Microsoft VS Code/bin"

#
# locations
#

adata="$DATA/appdata" adataw="$DATA/appdataw" b="$BIN" bin="$BIN" data="$DATA" p="$P" pd="$PUB/Desktop" pub="$PUB" tmp="/tmp" root="/" win="$DATA/platform/win" 	# system
doc="$DOC" dl="$HOME/Downloads" code="$CODE" home="$HOME" ubin="$HOME/data/bin" ud="$HOME/Desktop" udata="$HOME/data"  																						# user

if IsPlatform win; then
	p32="$P32" psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" wr="$WIN_ROOT" wtmp="$WIN_ROOT/temp"; pp="$psm/Programs" 			# system
	usm="$UADATA/../Roaming/Microsoft/Windows/Start Menu" wcode="$WIN_CODE" wh="$WIN_HOME" ; up="$usm/Programs"								# user
else
	wcode="$CODE" wh="$HOME" wtmp="$TMP"
fi

alias wcode="$wcode"

# Dropbox
if [[ -d "$home/Dropbox" ]]; then
	cr="$HOME/Juntos Holdings Dropbox"; IsPlatform  mac && cr="$HOME/Library/CloudStorage/Dropbox-JuntosHoldings" # cloud root
	cc="$cr/Company" cf="$cr/Family" 
	cloud="$home/Dropbox"; c="$cloud"; cdata="$c/data"; cdl="$cdata/download" ccode="$c/code"

	ncd="$cloud/network"; alias ncd="$ncd" # network configuration directory
	scd="$ncd/system"	
fi

alias cdv="cd ~/Volumes"

# application data and configuration directories
aconf() { AppDirGet "$ACONF" "$@"; } 	# ACONF [w] [n] [host]
adata() { AppDirGet "$ADATA" "$@"; } 			# adata [w] [n] [host]
acd() { ScriptCd adata "$@"; }
acdw() { ScriptCd adata "w" "$@"; }

# AppDirGet BASE_DIR [n] [w] [host]
AppDirGet()
{
	local baseDir="$1"; shift
	local w; [[ "$(LowerCase "$1")" == "w" ]] && { w="$1"; shift; }	
	local n; IsInteger "$1" && { n="$1"; shift; [[ "$n" == "1" ]] && n=""; }
	IsLocalHost "$1" && echo "${ADATA}$n$w" || echo "//$1/admin$ADATA"; 
}

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

appc() { header "Checking Applications"; inst check "$@"; }	# check app versions
appd() { inst check | awk '{ if ($3 == "") print $1; }'; } 				# check app downloads

alias choco='choco.exe'
alias f='firefox'
alias grep='command grep --color=auto'
alias m='merge'
alias pref='os preferences'

bcat() { InPath batcat && batcat "$@" || command cat "$@"; }
code() { VisualStudioCodeHelper "$@"; }
e() { TextEdit "$@"; }
figlet() { pyfiglet "$@"; }
terminator() { coproc /usr/bin/terminator "$@"; }

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
alias sa='. ~/.bashrc "$@"' ea="e ~/.bashrc" sz=". ~/.zshrc" ez="e ~/.zshrc" sf=". $BIN/function.sh" ef="e $BIN/function.sh"; # set aliases
alias s10k="sz" e10k="e ~/.p10k.zsh"

# edit/set all
eaa() { local files; GetPlatformFiles "$UBIN/.bashrc." ".sh" || return 0; TextEdit "${files[@]}" ~/.bashrc; }
saa() { local file files; GetPlatformFiles "$UBIN/.bashrc." ".sh" || return 0; .  ~/.bashrc && for file in "${files[@]}"; do . "$file" || return; done; }

efa() { local files; GetPlatformFiles "$bin/function." ".sh" || return 0; TextEdit "${files[@]}" "$bin/function.sh"; }
sfa() { local file files; GetPlatformFiles "$UBIN/function." ".sh" || return 0; . "$bin/function.sh" && for file in "${files[@]}"; do . "$file" || return; done; }

alias estart="e /etc/environment /etc/profile /etc/bash.bashrc $BIN/bash.bashrc $UBIN/.profile $UBIN/.bash_profile $UBIN/.zlogin $UBIN/.p10k.zsh $UBIN/.zshrc $UBIN/.bashrc"
alias kstart='bind -f ~/.inputrc' ek='e ~/.inputrc'
alias ebo='e ~/.inputrc /etc/bash.bash_logout ~/.bash_logout'

# set full
sfull()
{
	declare {PLATFORM_OS,PLATFORM_LIKE,PLATFORM_ID}=""	# bash.bashrc
	declare {CHROOT_CHECKED,CREDENTIAL_MANAGER_CHECKED,DOTNET_CHECKED,GIT_ANNEX_CHECKED,EDITOR,VM_TYPE_CHECKED,HASHI_CHECKED,MCFLY_PATH,NETWORK_CHECKED,NODE_CHECKED,PYTHON_CHECKED,PYTHON_ROOT_CHECKED,X_SERVER_CHECKED}=""	# function.sh

	. "$bin/bash.bashrc" "$@"
	. "$bin/function.sh" "$@"
	IsZsh && { . ~/.zshrc; } || { kstart; . ~/.bash_profile; }
}

#
# completion
#

if IsBash; then

	#  hosts
	HOSTFILE=$DATA/setup/hosts
	complete -A hostname -o default curl dig host mosh netcat nslookup on off ping telnet

	# git
	
	case "$PLATFORM_OS" in
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

	# completion
	complete -r cd >& /dev/null # cd should not complete variables without a leading $
	complete -o default -o nospace -F _git g 

	# HashiCorp
	InPath consul && complete -C /usr/local/bin/consul consul
	InPath nomad && complete -C /usr/local/bin/nomad nomad
	InPath vault && complete -C /usr/local/bin/vault vault
fi

#
# Data Types
#

DumpBytes() { GetArgs; echo -n -e "$@" | ${G}od --address-radix d -t x1 -t c -t a; } # echo -en "01\\n" | DumpBytes

# date/time
clock() { ClockHelper $@; }
alias clk="clock"

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
build() { n build /verbosity:minimal /m "$code/$1"; }
BuildClean() { n build /t:Clean /m "$code/$1"; }

# GO
[[ -d "/usr/local/go/bin" ]] && { PathAdd "/usr/local/go/bin"; GOPATH=$HOME/go; }

# JavaScript
alias tsr='npx esrun'

# Node.js
alias node='\node --use-strict'
alias npmls='npm ls --depth=0'
alias npmi='sudo npm install -g' # npm install
alias npmu='sudo npm uninstall -g' # npm uninstall

# NodeSwitch - emulate n syntax using nvm
NodeSwitch()
{
	IsNumeric "$1" && { nvm use "$1"; return; }
	[[ "$1" == "lts" ]] && { nvm use --lts; return; }
	[[ "$1" == @(default|stable|system) ]] && { nvm use "$@"; return; }
	nvm "$@"
}

! InPath n && alias n="NodeSwitch"

nlts() { nvm use --lts "$@"; }
nlts() { nvm use --lts "$@"; }

alias nodew='start "$P/nodejs/node.exe"'
alias npmw='$P/nodejs/npm'
alias ngw='start "$UADATA/../Roaming/npm/ng.cmd"'

# React
cra() { npx create-react-app --template typescript "$@"; }
yd() { yarn dev "$@"; }
ys() { yarn start "$@"; }

#
# directory management
#

[[ ! $LS_COLORS && -f "$ubin/default.dircolors" ]] && InPath dircolors && eval "$(dircolors "$ubin/default.dircolors")"

alias cd='DoCd'

alias ls='DoLs'
alias lsc='DoLs'											# list with 
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
	builtin cd "$@" && NodeConf && PythonConf
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
	else
		command ${G}ls --hide="desktop.ini" -F --group-directories-first --color "$@"
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

# information
ShowFortune() { ! InPath cowsay fortune lolcat && return; cowsay "$(fortune --all)" | lolcat; return 0; }
ShowHost() { ! InPath pyfiglet lolcat && return; pyfiglet --justify=center --width=$COLUMNS "$(hostname)" | lolcat; }

# clear
c() { cls; } 											# clear screen
ca() { builtin cd ~; cls; } 			# clear all - cd and clear screen
ch() { ca; ClearRun ShowHost; } 	# clear host - cd, clear screen, host

# ClearRun - clear screen and run a command, Warp requires command be run in background to see it's output
ClearRun()
{ 
	cls; [[ ! $@ ]] && return
	! IsWarp && { "$@"; return; }
	[[ $1 ]] && "$@" & # must be on separate line for Bash
	disown
}

alias ddm='DellDisplayManager'
FullWakeup() { ssh "$1" caffeinate  -u -w 10; }
sw() { ddm switch "$@"; } # switch monitor

mp()
{
	local dir="$UADATA/../Roaming/Realtime Soft/UltraMon/3.4.1/Profiles"
	local cdir="$cloud/data/UltraMon"

	if [[ -f "$dir/$1.umprofile" ]]; then start "$dir/$1.umprofile"
	elif [[ -f "$dir/study/$1.umprofile" ]]; then start "$dir/study/$1.umprofile"
	elif [[ -f "$cdir/$1.umprofile" ]]; then start "$cdir/$1.umprofile"
	else ScriptErr "mon" "'$1' is not a valid monitor profile"
	fi
}

mpl() { tree "$UADATA/../Roaming/Realtime Soft/UltraMon/3.4.1/Profiles"	"$cloud/data/UltraMon"; }

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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias del='rm'
alias md='mkdir'
alias rd='rmdir'

alias inf="FileInfo"
alias l='explore'
alias rc='CopyDir'

lcf() { local f="$1"; mv "$f" "${f,,}.hold" || return; mv "${f,,}.hold" "${f,,}" || return; } # lower case file

FileTypes() { file * | sort -k 2; }

# UnisonClean FILE - remove the specified file from the Unison root directory for the platform
alias uclean='UnisonClean' ucleanr='UnisonCleanRoot'
UnisonClean() { rm "$(UnisonConfDir)/$1"; }
UnisonCleanRoot() { sudoc rm "$(UnisonRootConfDir)/$1"; }

#
# DriveTime
#

dtc="$c/group/DriveTime" # DriveTime Cloud personal files
vsne() { hstart64.exe /NOCONSOLE /NONELEVATED "$(utw "$P/Microsoft Visual Studio/2022/Professional/Common7/IDE/devenv.exe")"; } # Visual Studio Not Elevated

# aliases
alias ah='AzureHelper'
alias dtc="$dtc"; alias dtcp="$dtc/projects"
alias dt-setsub-dev='az account set --subscription 8bc2fde5-e1ad-4bc0-9287-85957096f0b4'
alias dt-setsub-prod='az account set --subscription a1eab4f0-e17c-4e70-ab04-833c063dc515'
alias dt-get-cred='az aks get-credentials -g dtwt-aks-devops-rg -n dtwt-aks-devops01-k8'
alias dt-get-cred-devtest='az aks get-credentials -g dtwt-aks-devtest-rg -n dtwt-aks-devtest01-k8'
alias dt-get-cred-prodw='az aks get-credentials -g dtwt-aks-prod-rg -n dtwt-aks-prod01-k8'
alias dt-get-cred-prode='az aks get-credentials -g dtwt-aks-prod-rg -n dtet-aks-prod01-k8'
alias dt-new-token='az login --scope https://management.core.windows.net//.default'

# domain run
dedge() { dtRun "$P32/Microsoft/Edge/Application/msedge.exe" --profile-directory=Default; } # domain edge
dff() { dtRun "$P/Mozilla Firefox/firefox.exe"; }																						# domain Firefox
dssms() { dtRun "$P32/Microsoft SQL Server Management Studio 18/Common7/IDE/Ssms.exe"; }		# domain ssms
dvs() { dtRun "$P/Microsoft Visual Studio/2022/Preview/Common7/IDE/devenv.exe"; }						# domain Visual Studio
dvsp() { dtRun "$P/Microsoft Visual Studio/2022/Preview/Common7/IDE/devenv.exe"; }					# domain Visual Studio Preview

# Pitstop

alias backstage='yarn backstage-cli' bs='backstage'
backs="$CODE/pitstop/backstage"; backsc() {  code "$backs"; } 		# Backstage code

pits="$CODE/pitstop/cx.ui.pitstop.web"
pits() { cd "$pits"; }
pitsc() { ProxyDisable; code "$pits"; } # Pitstop code
pss() { cd "$pits" && yarn dev; } # Pitstop Start

alias pda='PitstopDockerBuild && PitstopDockerClean && PitstopDockerRun'
alias pdb='PitstopDockerBuild'
alias pdc='PitstopDockerClean'
alias pdr='PitstopDockerRun'
alias pds='PitstopDockerStop'

PitstopDockerBuild()
{
	# install packages and compile
	{ yarn install --frozen-lockfile && yarn tsc; } || return

	# build backend
	gsed -z -i 's/},*\n  "devDependencies": {/,/g' packages/backend/package.json || return	# no dev dependencies
	gsed -z -i 's/7007/3000/g' app-config.yaml || return																		# use port 3000
	yarn build:backend --config ../../app-config.yaml || return 														# outputs packages/app/dist/static

	# build Docker container with local configuration files 
	gsed -i 's/*.local.yaml//g' .dockerignore || return							# do not ignore app-config.local.yaml
	gsed -i 's/app-config//g' packages/backend/Dockerfile || return	# copy all configuration yaml files
	echo "EXPOSE 3000/tcp" >> packages/backend/Dockerfile || return	#	expose port 3000
	gsed -z -i 's/7007/3000/g' app-config.local.yaml || return			# use port 3000
	docker build -t pitstop -f "packages/backend/Dockerfile" . || return
}

PitstopDockerClean()
{
	git checkout HEAD -- .dockerignore app-config.yaml packages/backend/Dockerfile packages/backend/package.json 	# reset git files
	gsed -z -i 's/3000/7007/2;s/port: 3000/port: 7007/3' app-config.local.yaml 																# fix backen baseUrl and port
}

PitstopDockerRun()
{
	export LAUNCHDARKLY_CLIENT_ID="$(grep "launchDarklyClientId:" app-config.local.yaml | cut -d: -f2 | cut -d" " -f2)"
	docker run --publish 3000:3000/tcp --env NODE_ENV=local --env LAUNCHDARKLY_CLIENT_ID="$LAUNCHDARKLY_CLIENT_ID" pitstop
}

PitstopDockerStop() { docker stop "$(docker ps | grep pitstop | tail -1 | cut -d" " -f1)"; }

#
# find
#

alias fa='FindAll'
alias fai='FindAllIgnore'
alias fcd='FindCd'
alias fclip='FindClip'
alias fs='FindStart'
alias ft='FindText'
alias ftf='FindTextFile'

FindAll() {	fd "$@" --one-file-system; }																											# FindAll PATTERN - find all files that match the pattern from the current directory
FindAllIgnore() {	fd --no-ignore "$@" --one-file-system; }																		# FindAllIgnore PATTERN - ignore files ignored by .gitignore 
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

export GIT_EDITOR="TextEdit -w"

alias gax='git annex'
alias gah='GitAnnexHelper'

g() { local git=git; InPath "git.exe" && drive IsWin . && git="git.exe"; SshAgentConf && $git "$@"; }
gcd() { ScriptCd GitHelper github dir "$@"; }
gcdw() { ScriptCd GitHelper github dir --windows "$@"; }
ghlp() { SshAgentConf && GitHelper "$@"; }
ghc() { GitClone "$@"; }
ghcw() { GitClone --windows "$@"; }
gg() { SshAgentConf && GitHelper gui "$@"; }
gpull() { ghlp pull origin gh wiggin "$@"; }
gpush() { ghlp push origin gh wiggin "$@"; }

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
alias grf='g rf' 								# create a rebase fixup commit with staged files
alias grfc='g rfc' 							# create a rebase fixup commit with changed files
alias grs='g rsq' 							# create a rebase squash commit
alias gmt='g mergetool'
alias gpf='g push --force'			# push force
alias ge='g status --porcelain=2 | cut -f9 -d" " | xargs edit' # git edit modified files
alias eg='GitHelper edit'
alias lg='lazygit'

# gfix - git fix, combine modified files with last commit and force push
alias gfix='grfc && gria && gpush --force'

# gdir SERVER - change to the git directory on SERVER for repo creation
gdir() { cd "$(GitHelper remote dir "$@")"; }

# Git Headquarters (ghq)
ghqg() { local url="$1"; ghq get "$1"; url="$(echo "$url" | cut -d/ -f3-)"; cd "$(ghq root)/$(ghq list | grep "$url")"; } # get REPO

# git-annex

GitAnnexConf()
{
	local force forceLevel; ScriptOptForce "$@"
	local verbose verboseLevel; ScriptOptVerbose "$@"

	# return if configuration is set
	[[ ! $force && $GIT_ANNEX_CHECKED ]] && return

	# configure
	(( verboseLevel > 1 )) && header "GitAnnex Configuration"
	GitAnnexHelper IsInstalled && ! GitAnnexHelper IsRunning && GitAnnexHelper startup --quiet
	GIT_ANNEX_CHECKED="true"
}

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

HISTFILE="$HOME/.${PLATFORM_SHELL}_history" # GitKraken shell changes the history file
HISTSIZE=5000
HISTFILESIZE=10000
IsBash && HISTCONTROL=ignoreboth
IsZsh && setopt SHARE_HISTORY HIST_IGNORE_DUPS

HistoryClear() { IsBash && cat /dev/null > $HISTFILE; history -c; }

#
# HashiCorp
#

alias h="hashi" hconf="HashiConfStatus"
hcd() { cd "$ncd/system/hashi/$1"; }

hct() { HashiConf --config-prefix=test "$@" && hashi status; } # hct - hashi config test
hr() { hashi resolve "$@"; }	# hr SERVER - resolve a consul service address
hstat() { hashi status; }
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

# HashiCorp - Vagrant
vagrant() { "$wr/HashiCorp/Vagrant/bin/vagrant.exe" "$@"; }
vcd() { cd "$wh/data/app/vagrant"; }

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
alias hssh="sudoc cp ~/.ssh/config ~/.ssh/known_hosts ~homebridge/.ssh && sudo chown homebridge ~homebridge/.ssh/config ~homebridge/.ssh/known_hosts" # update SSH configuration 
alias hrestart="service restart homebridge"
alias hstart='sudoc hb-service start'
alias hstop='sudoc hb-service stop'
alias hlog='sudoc hb-service logs'
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
		case "$PLATFORM_OS" in
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

	ScriptErr "no system monitor installed" "sysmon"
	return 1
}

# time
alias t='TimeCommand'
alias ton='TimerOn'
alias toff='TimerOff'
alias tsplit='TimerSplit'
alias twait='TimerOn && pause && TimerOff' # timer wait

# disk
alias TestDisk='sudo bench32.exe'
DiskTestCopy() { tar cf - "$1" | pv | (cd "${2:-.}"; tar xf -); }
DiskTestGui() { start --elevate ATTODiskBenchmark.exe; }
DiskTestAll() { bonnie++ | tee >> "$(os name)_performance_$(GetDateStamp).txt"; }

# DiskTestRead [DEVICE](di first)
DiskTestRead()
{ 
	local device="${1:-$(di | head -2 | tail -1 | cut -d" " -f1)}"
	sudo hdparm -t "$device"; 
} 

# DiskTestWrite [DEST](disktest) [COUNT] - # use smaller count for Pi and other lower performance disks
DiskTestWrite() 
{
	local file="$1"; [[ ! $file ]] && file="disktest"
	local count="$2"; [[ ! $count ]] && count="1024" 
	
	sync
	${G}dd if=/dev/zero of="$file" bs=1M count="$count"
	sync
	rm "$file"
} 

DiskTestFio()
{
	local dir="${1:-/tmp}" sudo; InPath sudo && sudo="sudoc"
	[[ ! -d "$dir" ]] && { ScriptErr "Directory '$dir' does not exist"; return 1; }
	dir+="/FioTest"; $sudo mkdir -p "$dir" || return

	# write throughput
	$sudo fio --name=write_throughput --directory="$dir" --numjobs=8 \
	--size=10G --time_based --runtime=60s --ramp_time=2s --ioengine=libaio \
	--direct=1 --verify=0 --bs=1M --iodepth=64 --rw=write \
	--group_reporting=1

	# read throughput
	$sudo fio --name=read_throughput --directory="$dir" --numjobs=8 \
	--size=10G --time_based --runtime=60s --ramp_time=2s --ioengine=libaio \
	--direct=1 --verify=0 --bs=1M --iodepth=64 --rw=read \
	--group_reporting=1

	# cleanup
	$sudo rm -fr "$dir"
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

alias nconf="NetworkConf"
alias tf="TftpHelper"
clf() { CloudFlare "$@"; }
ncg() {	network current all; } # network current get
ncu() {	NetworkCurrentUpdate "$@"; }
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
DnsLog() { service log named; }
DnsRestart() { service restart named; }
alias NamedLog='DnsLog'

# DHCP
DhcpMonitor() {	IsPlatform win && { dhcptest.exe "$@"; return; }; }
DhcpOptions()
{ 
	IsPlatform win && { pushd $win > /dev/null; powershell ./DhcpOptions.ps1; popd > /dev/null; return; }
	[[ -f "/var/lib/dhcp/dhclient.leases" ]] && cat "/var/lib/dhcp/dhclient.leases"
}

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
NginxConfWatch() { FileWatch "/etc/nginx/sites-available/$1.conf" "${2:-  server }"; }

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
alias FindSyncTxt='fa --hidden '\..*_sync.txt''
alias RemoveSyncTxt='FindSyncTxt | xargs rm'
alias HideSyncTxt="FileHide .*_sync.txt"

# Virtual IP (VIP) - keepalived load balancer
VipStatus() { local lb="${1:-lb}" mac; MacLookup --detail "$lb"; }
VipMonitor() { MacLookup --monitor "${1:-lb}"; }

# web
awd() { ScriptCd apache dir web "$@" && ls; }		# Apache Web Dir
curle() { curl "$(UrlEncode "$1")" "${@:2}"; } 	# curl encode - encode spaces in the URL
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

GitPromptBash()
{
	local red='\e[31m'
	unset GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWUNTRACKEDFILES GIT_PS1_SHOWUPSTREAM

	GIT_PS1_SHOWUPSTREAM="auto verbose"; # = at origin, < behind,  > ahead, <> diverged
	GIT_PS1_SHOWDIRTYSTATE="true" # shows *
	GIT_PS1_SHOWSTASHSTATE="true"	 # shows $
	GIT_PS1_SHOWUNTRACKEDFILES="true" # shows %

	drive IsWin . && . "$bin/git-sh-prompt-win.sh"
	__git_ps1 " (%s)"
}

SetPromptBash() 
{
	local blue='\[\e[34m\]'
	local cyan='\[\e[36m\]'
	local clear='\[\e[0m\]'
	local green='\[\e[32m\]'
	local red='\[\e[31m\]'
	local yellow='\[\e[33m\]'

	local dir='${green}\w${clear}'
	local git; #IsFunction __git_ps1 && git='${cyan}$(GitPromptBash)${clear}'
	local user; [[ "$USER" != "jjbutare" ]] && user="\u"
	local elevated; IsPlatform win && IsElevated && elevated+="${red}-elevated${clear}"
	local root; IsRoot && root+="${red}-root${clear}"

	local host="${HOSTNAME#$USER-}"; host="${host#$SUDO_USER-}"; # remove the username from the hostname to shorten it
	host="${host%%.*}" # remove DNS suffix

	local title="\[\e]0;terminal $host $dir\a\]"; # forces the title bar to update

	[[ $user ]] && user="@${user}"

 	PS1="${title}${green}${host}${user}${root}${elevated}${git} ${blue}$dir${clear} \$ "

	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -r;' 
}

if [[ ! $SET_PROMPT_CHECK ]]; then
	SET_PROMPT_CHECK="true"
	IsBash && SetPromptBash # slow .1s
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
	else ScriptErr "logoff not supported", "logoff"; return 1;
	fi		
}

NumProcessors() { cat /proc/cpuinfo | grep processor | wc -l; }

#
# media
#

alias gp="media get" # get pictures
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

alias pconf="PythonConf"
alias peconf="PyEnvConf"

alias py='python3'
alias pip='py -m pip'
alias pec='PyEnvCreate'

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
PiVerifyCert() { PiSsh -- 'openssl x509 -in "'${1:-/opt/nomad/cert/nomad-client.pem}'" -text | grep "Not After"'; }

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

mint() { e "$ccode/bash/template/app" "$ccode/bash/template/min"; } # bash min template
alias scd='ScriptCd'
alias se='ScriptEval'
alias slist='file * .* | FilterShellScript | cut -d: -f1'
alias sfind='slist | xargs grep'
sfindl() { sfind --color=always "$1" | less -R; }
alias sedit='slist | xargs RunFunction.sh TextEdit'
alias slistapp='slist | xargs grep -iE "IsInstalledCommand\(\)" | cut -d: -f1'
alias seditapp='slistapp | xargs RunFunction.sh TextEdit'

fuh() { HeaderBig "$@ Usages" && fu "$@"; } # FindUsageHeader
fuf() { fu -l "$@" | sort | uniq; } 				# FindUsagesFiles - find all script names that use the specified TEXT
fue() { fuf "$@" | xargs sublime; } 				# FindUsagesEdit - edit all script names that use the specified TEXT

# FindUsages TEXT - find all script usages of specified TEXT, fu1 Find Usages 1 line
fu() { rg "$@" "$BIN" "$UBIN" --trim --hidden --smart-case -g="!.git" -g="!.p10k.zsh" -g="!git-sh-prompt-win.sh"; } 
fu1() { grep --color -ire "$1" --include="*" --exclude-dir=".git" --exclude=".p10k.zsh" --exclude="git-sh-prompt-win.sh" "$BIN" "$UBIN"; }

#
# security
#

alias cconf="CredentialConfStatus"

cred() { credential "$@"; }
1conf() { ScriptEval 1PasswordHelper unlock "$@" && 1PasswordHelper status; }

CertGetDates() { local c; for c in "$@"; do echo "$c:"; openssl x509 -in "$c" -text | grep "Not "; done; }
CertGetPublicKey() { openssl x509 -noout -pubkey -in "$1"; }
CertKeyGetPublicKey() { openssl pkey -pubout -in "$1"; }
CertVerifyKey() { [[ "$(CertGetPublicKey "$1")" == "$(CertKeyGetPublicKey "$2")" ]]; } # CertVerify CERT KEY - validate the private key if for the certificate
CertVerifyChain() { openssl verify -verbose -CAfile <(cat "${@:2}") "$1";  } # CertVerifyChain CERT CA...
SwitchUser() { local user="$1"; cd ~$user; sudo --user=$user --set-home --shell bash -il; }

#
# SSH
#

alias sconf="SshAgentConfStatus"

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
	ScriptErr "no audio program was found" "playsoud"; return 1
}

#
# text
#

rgh() { HeaderBig "$1" && rg "$@"; } # ripgrep header

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

aconf() { hconf "$@" && cconf "$@" && nconf "$@" && sconf "$@"; }	# all configure, i.e. aconf -a=pi1 -f
unlock() { wiggin host credential -H=locked; }
vpn() { network vpn "$@"; }

# apps
alias wsa='WigginServerApps' wsc='WigginServerCount' 
WigginServerApps() { hashi app node status --active; }
WigginServerCount() { hashi nomad node allocs --numeric -H=active; }


# devices
cam() { wiggin device "$@" cam; }
wcore() { wiggin device "$@" core; }
wtest() { wiggin device "$@" test; }

# encrypted files
encm() { encrypt mount "$cdata/app/CryFS/personal" "$@"; }
encum() { encrypt unmount "personal" "$@"; }

# files
hadcd() { cd "$(appdata "$1")/$2"; } # hadcd HOST DIR - host appdata cd to directory

# media
mcd() { cd "//nas3/data/media"; } # mcd - media CD

# backup
bdir() { cd "$(AppGetBackupDir)"; } # backup dir

# borg
alias bh='BorgHelper'
bconf() { BorgConf "$@" && BorgHelper status; }
borg() { [[ ! $BORG_REPO ]] && { BorgConf || return; }; command borg "$@"; }
bb() { BorgHelper backup "$@" --archive="$(RemoveTrailingSlash "$1" | GetFileName)"; } # borg backup
bcd() { hadcd "${1:-$HOSTNAME}" "borg"; } 								# borg cd [HOST]
bm() { ScriptCd BorgHelper mount "$@"; }									# borg mount
bum() { BorgHelper unmount "$@"; }												# borg unmount
clipb() { BorgConf "$@" && clipw "$BORG_PASSPHRASE"; }

# bbh DIR HOSTS - borg backup hosts
bbh()
{
	local dir="$1" host hosts; StringToArray "$2" "," hosts; shift 2
	for host in "${hosts[@]}"; do bb "$dir" --host="$host" "$@" || return; done
} 

# network DNS and DHCP configuration
alias ne='wiggin network edit'								# network edit
alias nep='e $DATA/setup/ports'								# network edit poirt
alias nb='wiggin network backup all'					# network backup
alias nua='wiggin network update all'					# network update all
alias nud='wiggin network update dns'					# network update DNS
alias nudh='wiggin network update dhcp'				# network update DHCP

DownInfo()
{
	local sep=","
	{
		hilight "name${sep}mac"
		DomotzHelper down || return
	} | column -c $(tput cols -T "$TERM") -t -s"${sep}"
}

DownFix() { wiggin host network fix -H=down --errors --wait "$@"; }

# QNAP
qr() { qnap cli run -- "$@"; } # qcli run - run a QNAP CLI command

# servers
alias sls='ServerLs' sns='ServerNodeStatus'
ServerLs() { wiggin host ls -H="$1" "${@:2}"; } # ServerLs all|down|hashi-prod|hashi-test|locked|important|network|reboot|restart|unlock|web
ServerNodeStatus() { hashi app node status --active "$@"; }

# UniFi
alias uc='UniFiController'
SwitchPoeStatus() { ssh admin@$1 swctrl poe show; }

# update client
alias u='update' ua="UpdateAll" ud="UpdateDownload" uf='UpdateFile'
update() { HostUpdate "$@"; }
UpdateAll() { header "file" && slf "$@" && header "download" && UpdateDownload "$@" && wiggin sync public --no-prompt "$@" && header "update" && HostUpdate "$@"; }
UpdateDownload() { HostUpdate -w=download "$@"; }
UpdateFile() { slf "$@"; }

# update servers
alias us='UpdateServer' usa="UpdateServerAll" usc="UpdateServerCredentials" usf="UpdateServerFile" usff="UpdateServerFileFast" usrb="UpdateServerReboot" usrs="UpdateServerRestart" usr="UpdateServerRoot"
UpdateServer() { wiggin host update --errors --dest-older "$@"; }
UpdateServerAll() { UpdateServerFile "$@" && UpdateServer "$@" && wiggin host credential -H=locked; }
UpdateServerCredentials() { wiggin host credential -H=locked "$@"; }
UpdateServerFile() { wiggin host sync files --errors --dest-older "$@"; }
UpdateServerFileFast() { wiggin host sync files --errors --dest-older "$@" -- --no-platform ; }
UpdateServerReboot() { wiggin host update reboot "$@"; }
UpdateServerRestart() { wiggin host update restart "$@"; }
UpdateServerRoot() { wiggin host sync root "$@"; }

#
# windows
#

SetTitle() { printf "\e]2;$*\a"; }
stopx() { gnome-session-quit --no-prompt; } # startx|stopx

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
# platform
#

SourceIfExistsPlatform "$UBIN/.bashrc." ".sh" || return

#
# configuration - items that can take time
#

# run first - used by CredentialConf
DbusConf || return
NetworkConf $force $quiet $verbose || return
SshAgentEnvConf $force $quiet $verbose  # ignore errors

# run next
CredentialConf $force $quiet $verbose 	# ignore errors

# run last - depends on CredentialConf
HashiConf  $force $quiet $verbose || return

# other
DotNetConf $force $quiet $verbose || return
GitAnnexConf $force $quiet $verbose || return
McflyConf $force $quiet $verbose || return
NodeConf $force $quiet $verbose || return
PythonConf $force $quiet $verbose || return
SetTextEditor $force $quiet $verbose || return

# logging
if [[ $verbose ]]; then
	hilight "SSH Agent"; SshAgent status
	hilight "Credential Manager"; credential manager status
	hilight "Network"; network current status	
fi

unset -v force quiet verbose
# TimerOff

return 0