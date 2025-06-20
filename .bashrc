# TimerOn
[[ $timerOn ]] && TimerOn

# source function.sh if needed - don't depend on BIN variable
{ [[ ! $FUNCTIONS ]] || ! declare -f "IsFunction" >& /dev/null; } && { . "/usr/local/data/bin/function.sh" "" || return; }

# non-interactive initialization - available from child processes and scripts, i.e. ssh <script>
export LESS='-R'

# return if not interactive
[[ "$-" != *i* ]] && return

#
# Interactive Configuration
#

# arguments
quiet="--quiet"
# verbose=-vvv verboseLevel=3
ScriptOptForce "$@" || return
ScriptOptVerbose "$@" || return
[[ $verbose ]] && unset quiet

export TIMEFORMAT='%R seconds elapsed'
alias tc='TimeCommand'

# ensure DISPLAY is set first
InitializeXServer || return

# WSL 2 - fix locale error and umask (WSL does not respect USERGROUPS_ENAB)
IsPlatform wsl2 && { LANG="C.UTF-8"; umask 002; }

# Mac - fix umask
IsPlatform mac && { umask 002; }

# keyboard
if IsZsh; then
	bindkey "^H" backward-kill-word
	bindkey "^[[1;2D" emacs-backward-word
	bindkey "^[[1;2C" emacs-forward-word
fi

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

alias ns="NixHelper start"

[[ ! $ASDF_DIR && ! $force ]] && { SourceIfExists "$HOME/.asdf/asdf.sh" || return; } 	# ASDF
SourceIfExists "$HOME/.config/broot/launcher/bash/br" || return 											# broot
[[ -d "/usr/games" ]] && PathAdd "/usr/games" 																				# games on Ubuntu 19.04+
[[ -d "$HOME/go/bin" ]] && PathAdd "$HOME/go/bin"																			# Go
SourceIfExists "$HOME/.ghcup/env" || return																						# Haskell
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

# iTerm
if IsiTerm; then
	SourceIfExists "$HOME/.iterm2_shell_integration.$PLATFORM_SHELL" || return

	# if IsPlatform mac; then

		# set dyname user variables, get with it2getvar "user.date"
		function iterm2_print_user_vars() {
		  iterm2_set_user_var test "success"
		  iterm2_set_user_var date "$(date)"
		  ~/.iterm2/it2git
		}

		# badge
		printf "\e]1337;SetBadgeFormat=%s\a" \
	  	"$(echo -n "\(session.autoName)\n\(user.gitBranch) \(user.gitDirty) \(user.gitPushCount) \(user.gitPullCount)" | base64)"

  # fi
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
	usm="$UADATA/../Roaming/Microsoft/Windows/Start Menu" wcode="$WIN_HOME/code" wh="$WIN_HOME" ; up="$usm/Programs"								# user
else
	wcode="$CODE" wh="$HOME" wtmp="$TMP"
fi

alias cdv="cd ~/Volumes"
alias wcode="$wcode"

# cloud files
if CloudConf --quiet; then

	# common
	c="$CLOUD" cr="$CLOUD_ROOT" cdata="$CLOUD/data" cdl="$cdata/download" ccode="$CLOUD/code"
	ncd="$c/network"; alias ncd="$ncd" # network configuration directory
	ccd() { cd "$c"; } 				# cloud cd
	crcd() { cd "$cr"; } 			# cloud root cd	

	# Dropbox
	if [[ "$CLOUD" =~ Dropbox ]]; then
		dbsa() { dropbox search --open "@"; }
		dbs() { dropbox search  --open --recent --word "$@"; }
	elif [[ "$CLOUD" =~ OneDrive ]]; then
		:
	fi

fi

# application data and configuration directories
appconf() { AppDirGet "$ACONF" "$@"; } 	# appconf [w] [n] [host]
adata() { AppDirGet "$ADATA" "$@"; } 		# adata [w] [n] [host]
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

cls() { clear; }																	# clear
ei() { TextEdit $bin/inst; }											# edit inst
ehp() { start "$udata/replicate/default.htm"; }		# edit home page
st() { startup --no-pause "$@"; }									# startup

#
# applications
#

alias choco='choco.exe'
alias code='vsc'
alias f='firefox'
alias grep='command grep --color=auto'
alias m='merge'
alias pref='os preferences'
alias usb="AnyplaceUSB"

bcat() { InPath batcat && batcat "$@" || command cat "$@"; }
vsc() { VisualStudioCodeHelper "$@"; }
e() { TextEdit "$@"; }
figlet() { pyfiglet "$@"; }
KarabinerCd() { ScriptCd KarabinerElements dir; }
qr() { qnap cli run -- "$@"; } # qcli run - run a QNAP CLI command
rdcman() { start RDCMan.exe "$CLOUD/data/app/Remote Desktop Connection Manager/default.rdg"; }

terminator() { coproc /usr/bin/terminator "$@"; }

# application installation
appd() { inst check | awk '{ if ($3 == "") print $1; }'; } 						# check app downloads
appv() { inst version "$@"; }

# appc [all|app] - check app versions
appc()
{
	local arg args=() hasArg
	for arg in "$@"; do ! IsOption "$arg" && hasArg="true" && break; done
	[[ ! $hasArg ]] && args+=(--update)
	[[ "$1" == "all" ]] && shift
	header "Checking Applications"; inst check "${args[@]}" "$@"; 
}

#
# archive
#

alias fm='start "$p/7-Zip/7zFM.exe"'
zrest() { unzip "${@}"; }
zls() { unzip -l "${@}"; }
zll() { unzip -ll "${@}"; }

tls() { tar --list --gunzip --verbose --file="$1"; }
tbak() { tar --create --preserve-permissions --numeric-owner --verbose --gzip --file="${2:-$1.tar.gz}" "$1"; } # tak DIR [FILE]
trest() { local dir; [[ $2 ]] && dir=( --directory "$2" ); sudo tar --extract --preserve-permissions --verbose --gunzip --file="$1" "${dir[@]}"; }

untar() { local args=(); ! IsPlatform mac && args+=(--atime-preserve);  tar --gzip -v -x "${args[@]}" < "$@"; }
untarbz() { local args=(); ! IsPlatform mac && args+=(--atime-preserve);  tar --bzip2 -v -x "${args[@]}" < "$@"; }

# zbak DIR [FILE] [-a|--all] - backup directory to file
# -a|--all - backup link target not just the link
zbak()
{
	# arguments
	local dir file recursive="-r" symlinks="--symlinks"

	while (( $# != 0 )); do
		case "$1" in "") : ;;
			-a|--all) unset symlinks;;
			*)
				if [[ ! $dir ]]; then dir="$1"
				elif [[ ! $file ]]; then file="$1"
				else UnknownOption "$1" "zbak"; return; fi
		esac
		shift
	done

	[[ ! $dir ]] && { MissingOperand "dir" "zbak"; return; }
	[[ ! $file ]] && file="$(GetFileName "$dir")"


	local exclude=(--exclude '*/.*_sync.txt')
	zip $recursive $symlinks "$file" "$dir" "${exclude[@]}"
} 

#
# Bash
#

alias bashl="EnvClean -- "$SHELL_DIR/bash" -l"

#
# configuration
#

# edit/set 
alias sa='. ~/.bashrc "$@"' ea="e ~/.bashrc" sz=". ~/.zshrc" ez="e ~/.zshrc" sf=". $BIN/function.sh \"\"" ef="e $BIN/function.sh" # set aliases

# edit/set all
eaa() { local files; GetPlatformFiles "$UBIN/.bashrc." ".sh" || return 0; TextEdit "${files[@]}" ~/.bashrc; }
saa() { local file files; GetPlatformFiles "$UBIN/.bashrc." ".sh" || return 0; .  ~/.bashrc && for file in "${files[@]}"; do . "$file" || return; done; }

efa() { local files; GetPlatformFiles "$bin/function." ".sh" || return 0; TextEdit "${files[@]}" "$bin/function.sh"; }
sfa() { local file files; GetPlatformFiles "$UBIN/function." ".sh" || return 0; . "$bin/function.sh" "" && for file in "${files[@]}"; do . "$file" || return; done; }

alias estart="e /etc/environment /etc/profile /etc/bash.bashrc $BIN/bash.bashrc $UBIN/.profile $UBIN/.bash_profile $UBIN/.zlogin $UBIN/.p10k.zsh $UBIN/.zshrc $UBIN/.bashrc"
alias kstart='bind -f ~/.inputrc' ek='e ~/.inputrc'
alias ebo='e ~/.inputrc /etc/bash.bash_logout ~/.bash_logout'

# set full
sfull()
{
	declare {PLATFORM_OS,PLATFORM_ID_MAIN,PLATFORM_ID_LIKE}=""	# bash.bashrc
	declare {CHROOT_CHECKED,COLORS_CHECKED,CREDENTIAL_MANAGER_CHECKED,DOTNET_CHECKED,GIT_ANNEX_CHECKED,EDITOR,VM_TYPE_CHECKED,HASHI_CHECKED,MCFLY_CHECKED,NETWORK_CHECKED,NODE_CHECKED,PYTHON_CHECKED,PYTHON_ROOT_CHECKED,X_SERVER_CHECKED}=""	# function.sh

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

# from https://github.com/trapd00r/LS_COLORS - https://raw.githubusercontent.com/trapd00r/LS_COLORS/refs/heads/master/LS_COLORS
[[ $force || ! $COLORS_CHECKED ]] && [[ -f "$ubin/default.dircolors" ]] && InPath ${G}dircolors && eval "$(${G}dircolors "$ubin/default.dircolors")"
InPath exa && export EXA_COLORS="$LS_COLORS:da=1;34" # https://the.exa.website/docs/colour-themes
InPath eza && export EZA_COLORS="$LS_COLORS:da=1;34" # https://github.com/eza-community/eza-themes

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
dirss() { DoLs -l --sort=size "$@"; } 	# sort by size
dirst() { DoLs -l --sort=time "$@"; } 	# sort by last modification time
dirsct() { local args=(--time=ctime); DoLsExtended && args+=(--time=created); DoLs -l --time=ctime --sort=time "${args[@]}" "$@"; } 	# sort by creation time

DoCd()
{
	IsUncPath "$1" && { ScriptCd unc mount "$1"; return; }	
	if IsDefined __zoxide_z; then 	__zoxide_z "$@" || return
	else builtin cd "$@" || return
	fi
}

DoLs()
{
	local unc="${@: -1}" # last argument
	
	if IsUncPath "$unc"; then
		local dir; dir="$(unc mount "$unc")" || return	
		set -- "${@:1:(( $# - 1 ))}" "$dir"
	fi

	if InPath eza; then
		eza --ignore-glob "desktop.ini" --classify --group-directories-first "$@"
	elif InPath exa; then
		exa --ignore-glob "desktop.ini" --classify --group-directories-first "$@"
	else
		command ${G}ls --hide="desktop.ini" -F --group-directories-first --color "$@"
	fi
}

# DoLsExtended - return true if extended ls arguments are supported using exa (Mac) or eza
DoLsExtended() { InPath eza || InPath exa; }

#
# disk
#

alias duh='${G}du --human-readable' # disk usage human readable
alias dsu='DiskSpaceUsage'					# disk space usage
tdug() { sudoc ncdu --color=dark -x /; } 							# total disk usage graphical
tdu() { di -d m | head -2 | ${G}tail --lines=-1 | tr -s " " | cut -d" " -f4; } # total disk usage in MB
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
ShowHost() { HeaderFancy "$HOSTNAME"; }

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
	local cdir="$CLOUD/data/UltraMon"

	if [[ -f "$dir/$1.umprofile" ]]; then start "$dir/$1.umprofile"
	elif [[ -f "$dir/study/$1.umprofile" ]]; then start "$dir/study/$1.umprofile"
	elif [[ -f "$cdir/$1.umprofile" ]]; then start "$cdir/$1.umprofile"
	else ScriptErr "mon" "'$1' is not a valid monitor profile"
	fi
}

mpl() { tree "$UADATA/../Roaming/Realtime Soft/UltraMon/3.4.1/Profiles"	"$CLOUD/data/UltraMon"; }

# swe - switch monitor to ender
swe()
{
	[[ "$HOSTNAME" == "ender" ]] && return
	FullWakeup ender &
	ddm switch
}

#
# Dropbox
#

function dbdup() { fd ' conflicted copy'; } # Dropbox Duplicates

# DropboxMerge - merge and remove conflicting files
function DropboxMerge()
{
	{ [[ $CLOUD_ROOT ]] && cd "$CLOUD_ROOT"; } || return

	# get and fix conflicting files		
	local file files; files=(); IFS=$'\n' ArrayMake files "$(dbdup)"
	for file in "${files[@]}"; do
		local original="$(echo "$file" | sed 's/ (.* conflicted copy .*)//')"
		ConflictFix "$original" "$file" || return
	done

	echo "All conflicting files have been merged."
}

# ConflictFix FILE CONFLICT - merge orginal and conflict then remote conflict
function ConflictFix()
{
	local file="$1" conflict="$2"
	local fileDesc="$(FileToDesc "$file")" conflictDesc="$(FileToDesc "$conflict")"
	
	[[ "$file" == "$conflcit" ]] && return

	echo "Comparing '$fileDesc' to '$conflictDesc'..."	
	while [[ -f "$file" && -f "$conflict" ]] && ! cmp -s "$file" "$conflict"; do		
		echo "Merging $file..."; m --wait "$file" "$conflict"
	done
	[[ -f "$conflict" ]] && ask "Conflict '$conflict' is identical, do you want to remove it" && { rm "$conflict" || return; }	
  return
}

#
# file management
#

# cleanup aliases in ~/.oh-my-zsh/lib/directories.zsh (md, rd)
unalias md rd >& /dev/null

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias inf="FileInfo"
alias l='explore'
alias rc='CopyDir'

del() { ${G}rm "$@"; }
lcf() { local f="$1"; mv "$f" "${f,,}.hold" || return; mv "${f,,}.hold" "${f,,}" || return; } # lower case file
md() { ${G}mkdir "$@"; }
rd() { ${G}rmdir "$@"; }

FileTypes() { file * | sort -k 2; }

# FileCheck|FixRw - return files that do not have user or group rw
alias fcrw="FileCheckRw"
alias ffrw="FileCheckRw | xargs --no-run-if-empty chmod ug+rw"

FileCheckRw()
{
	command ls -1al --almost-all |
	  ${G}grep -vE -e "^total" -e "^[-d]rw.?rw.?" |
 		${G}awk '{ print $NF}'
}
	
# UnisonClean FILE - remove the specified file from the Unison root directory for the platform
alias uclean='UnisonClean' ucleanr='UnisonCleanRoot'
UnisonClean() { rm "$(UnisonConfDir)/$1"; }
UnisonCleanRoot() { sudoc rm "$(UnisonRootConfDir)/$1"; }

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
msqlv() { fsqlv | cut -f 2 -d : | cut -f 3 -d ' ' | grep -Eiv "deploy|skip|ignore|NonVersioned" | sort | ${G}tail --lines=-1; } # MaxSqlVersion

eai() { fte "0.0.0.0" "VersionInfo.cs"; } # EditAssemblyInfo that are set to deploy (v0.0.0.0)

FindCd()
{
	local dir="$(FindAll "$@" | head -1 | GetFilePath)"
	[ ! -d "$dir" ] && { ScriptErr "Could not find a directory matching '$@'"; return 1; }
	cd "$dir"
}

#
# functions
#

IsZsh && def() { whence -f "$1"; } || def() { type "$1"; }
alias unexport='unset'
alias unfunction='unset -f'

TestFunction() { HeaderBig "Bash" && bash -c ". TestFunction.sh $@" && HeaderBig "Zsh" && zsh -c ". TestFunction.sh $@"; }
#
# git
#

export GIT_EDITOR="TextEdit -w"

alias gax='git annex'
alias gah='GitAnnexHelper'

gcd() { ScriptCd GitHelper github dir "$@"; }
gcdw() { ScriptCd GitHelper github dir --windows "$@"; }
ghlp() { SshAgentConf && GitHelper "$@"; }
ghc() { GitClone "$@"; }
ghcw() { GitClone --windows "$@"; }
gg() { SshAgentConf && GitHelper gui "$@"; }
gpull() { ghlp pull origin gh gitlab wiggin "$@"; }
gpush() { ghlp push origin gh gitlab wiggin "$@"; }

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

# g - git
g() { local git=git; InPath "$P/Git/bin/git.exe" && drive IsWin . && git="$P/Git/bin/git.exe"; SshAgentConf && $git "$@"; }
gw() { "$P/Git/bin/git.exe" "$@"; }

# gfix - git fix, combine modified files with last commit and force push
gfix() { grfc && gria && gpush --force --quiet; }

# gdir SERVER - change to the git directory on SERVER for repo creation
gdir() { cd "$(GitHelper remote dir "$@")"; }

# Git Headquarters (ghq)
ghqg() { local url="$1"; ghq get "$1"; url="$(echo "$url" | cut -d/ -f3-)"; cd "$(ghq root)/$(ghq list | grep "$url")"; } # get REPO

# git-annex

GitAnnexConf()
{
	local force forceLevel forceLess; ScriptOptForce "$@"
	local verbose verboseLevel verboseLess; ScriptOptVerbose "$@"

	# return if needed
	[[ ! $force && $GIT_ANNEX_CHECKED ]] && return
	{ ! InPath git-annex || ! GitAnnexHelper IsInstalled; } && { GIT_ANNEX_CHECKED="true"; return; }

	# configure	
	(( verboseLevel > 1 )) && header "GitAnnex Configuration"
	! GitAnnexHelper IsRunning && GitAnnexHelper startup --quiet
	GIT_ANNEX_CHECKED="true"
}

# GitLab
glc() { sudoedit /etc/gitlab/gitlab.rb; } # GitLab configuration
glr() { sudoc gitlab-ctl reconfigure; } # GitLab reconfigure

glb() 
{ 
	sudoc gitlab-rake gitlab:backup:create STRATEGY=copy
	local dir="$(unc mount //oversoul/drop)" || return
	${G}mkdir --parents "$dir/gitlab" || return
	sudo rsync --info=progress2 --archive --recursive --delete "/var/opt/gitlab/backups" "$dir/gitlab"
	unc unmount //oversoul/drop || return
}

#
# history
#

HISTFILE="$HOME/.${PLATFORM_SHELL}_history" # GitKraken shell changes the history file
HISTSIZE=5000
HISTFILESIZE=10000
HISTIGNORE='history*' # troubleshooting
IsBash && { HISTCONTROL=ignoreboth; }
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
hass-config() { sudoe ~homeassistant/.homeassistant/configuration.yaml && yamllint ~homeassistant/.homeassistant/configuration.yaml; }
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
alias hbakall='hbak pi5'
alias hconfig="e $HOME/.homebridge/config.json" 						# edit configuration
alias hcconfig="e $ncd/system/homebridge/config/config.json" # edit cloud configuration
alias hlog='sudoc hb-service logs'
alias hloge='e /var/lib/homebridge/homebridge.log' # log edit
alias hlogclean="sudoc rm /var/lib/homebridge/homebridge.log"
alias hrestart="service restart homebridge"
alias hssh="sudoc cp ~/.ssh/config ~/.ssh/known_hosts ~homebridge/.ssh && sudo chown homebridge ~homebridge/.ssh/config ~homebridge/.ssh/known_hosts" # update SSH configuration 
alias hstart='sudoc hb-service start'
alias hstop='sudoc hb-service stop'
alias hshell='sudoc hb-service shell'
alias hupdate='sudoc hb-service update-node'

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
# less
#

# LESSOPEN
if [[ -f "/opt/homebrew/bin/lesspipe.sh" ]]; then
	export LESSOPEN="|/opt/homebrew/bin/lesspipe.sh %s"
	PathAdd front "/opt/homebrew/opt/gawk/libexec/gnubin" # gawk
elif InPath lesspipe.sh; then export LESSOPEN="|lesspipe.sh %s"
elif [[ -f "$HOME/.lessfilter" ]]; then export LESSOPEN='|~/.lessfilter %s'
fi

# colorful man pages
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

#
# Obsidian
#

po="$$WIN_HOME/data/app/Obsidian/personal" # Personal Obsidian
IsDomainRestricted && po="$CLOUD/data/app/Obsidian/personal" 

alias obm="ObsidianMerge"
alias obmp="ObsidianMergePlugins"
alias obmpa="ObsidianMergePluginsAll"

function obdup() { fd '\-s'; } 				 # Obsidian Duplicates by S#

# ObsidianMerge - merge and remove conflicting files
function ObsidianMerge()
{
	# check if current folder has Markdown files
	! FileExists *.md && { ScriptErr "the current directory does not contain Markdown files" "obm"; return 1; }

	# get and fix conflicting files		
	local file files; files=(); IFS=$'\n' ArrayMake files "$(obdup)"
	for file in "${files[@]}"; do
		local original="$(echo "$file" | sed 's/-[Ss].*\./\./')"
		ConflictFix "$original" "$file" || return
	done

	echo "All conflicting files have been merged."
}

# ObsidianSyncPlugins DIR DIR - merge Obsidian plugins in the configuration directories
function ObsidianMergePlugins()
{
	local src="$1/plugins" dest="$2/plugins"
	[[ ! -d "$src" ]] && { ScriptErr "Source directory '$src' does not exist"; return; }
	[[ ! -d "$2" ]] && { ScriptErr "Destination directory '$2' does not exist"; return; }
	[[ ! -d "$dest" ]] && { ${G}mkdir "$dest" || return; }
	m --wait "$src" "$dest"
}

# ObsidianSyncPlugins DIR DIR - merge Obsidian plugins in the configuration directories
function ObsidianMergePluginsAll()
{
	local src="$po/.s1113731" dest

	# Obsidian directories
	local dir dirs=("$po" "$ptco" "$solo")
	for dir in "${dirs[@]}"; do

		# Obsidian hosts
		local hosts=(s1113731 s1114928 s1081454)
		for host in "${hosts[@]}"; do
			dest="$dir/.$host"
			[[ ! -d "$dest" ]] && { echo "$(os name alias "$host") is not configured for '$(FileToDesc "$dir")'"; continue; }
			[[ "$src" == "$dest" ]] && continue
			ObsidianMergePlugins "$src" "$dest" || return
		done

	done
}

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
			win) start taskmgr.exe; return;; 
		esac
	fi
	
	InPath glances && { glances; return; }
	InPath htop && { htop; return; }
	InPath top && { top; return; }

	ScriptErr "no system monitor installed" "sysmon"
	return 1
}

glances()
{
	local args=(); [[ "$HOSTNAME" == @(vast) ]] && args=(--disable-plugin sensors)
	command glances "${args[@]}"
}

# time
alias t='TimeCommand'
alias ton='TimerOn'
alias toff='TimerOff'
alias tsplit='TimerSplit'
alias twait='TimerOn && pause && TimerOff' # timer wait

# disk
DiskTestCopy() { tar cf - "$1" | pv | (cd "${2:-.}"; tar xf -); } # DiskTestCopy FILE
DiskTestAll() { bonnie++ | tee >> "$(os name)_performance_$(GetDateStamp).txt"; }

# DiskTestGui
DiskTestGui()
{
	! IsPlatform win && return

	local file
	if file="$P/CrystalDiskMark8/DiskMark64A.exe" && [[ -f "$file" ]]; then start --elevate "$file"
	else start --elevate ATTODiskBenchmark.exe;
	fi
}

# DiskTestRead [DEVICE](di first)
DiskTestRead()
{ 
	local device="${1:-$(di | head -2 | ${G}tail --lines=-1 | cut -d" " -f1)}"
	sudo hdparm -t "$device"; 
} 

# DiskTestWrite [DEST](/tmp) [COUNT] - # use smaller count for Pi and other lower performance disks
DiskTestWrite() 
{
	local dir="${1:-.}"
	local count="$2"; [[ ! $count ]] && count="1024" 

	[[ ! -d "$dir" ]] && { ScriptErr "Directory '$dir' does not exist"; return 1; }
	local file="$dir/DiskTestWrite"
	echo "Testing directory '$dir'..."

	# test write
	${G}dd if=/dev/zero of="$file" bs=1M count="$count" oflag=direct # conv=fdatasync

	# cleanup
	rm "$file"
} 

# DiskTestFio [DEST](/tmp)
DiskTestFioBig() { DiskTestFio "$1" 8 10G 60s; }
DiskTestFioSmall() { DiskTestFio "$1" 1 1G 10s; }

# DiskTestFio [DEST](/tmp) [JOBS](1) [SIZE](1G) [RUNTIME](10s)
DiskTestFio()
{
	! InPath fio && { package fio || return; }

	local dirOrig="${1:-.}"; [[ ! -d "$dirOrig" ]] && { ScriptErr "Directory '$dirOrig' does not exist"; return 1; }
	local jobs="${2:-1}" size="${3:-1G}" runtime="${4:-10s}"

	local sudo; InPath sudo && sudo="sudoc"
	local dir="$dirOrig/FioTest"; $sudo ${G}mkdir -p "$dir" || return
	local output; output="$(mktemp)" || return
	local engine="libaio"; IsPlatform mac && engine="posixaio"
	
	# read throughput
	hilight "Testing read in '$dirOrig'..."
	$sudo fio --name=read_throughput --directory="$dir" --numjobs=$jobs \
	--size=$size --time_based --runtime=$runtime --ramp_time=2s --ioengine=$engine \
	--direct=1 --verify=0 --bs=1M --iodepth=64 --rw=read \
	--group_reporting=1 --output "$output" || return
	local read; read="$(${G}grep "READ" "$output" | cut -d'(' -f2 | cut -d')' -f1)" || return
	echo

	# write throughput
	hilight "Testing write in '$dirOrig'..."
	$sudo fio --name=write_throughput --directory="$dir" --numjobs=$jobs \
	--size=$size --time_based --runtime=$runtime --ramp_time=2s --ioengine=$engine \
	--direct=1 --verify=0 --bs=1M --iodepth=64 --rw=write \
	--group_reporting=1 --output "$output" || return
	local write; write="$(${G}grep "WRITE" "$output" | cut -d'(' -f2 | cut -d')' -f1)" || return
	echo

	# display results
	hilight "Results..."
	echo "read=$read write=$write"

	# cleanup
	$sudo rm -fr "$dir" "$output"
}

# network
iperfs() { echo iPerf3 server is running on $(hostname); iperf3 -s -p 5002 "$@"; } # server
iperfc() { iperf3 -c $1 -p 5002 "$@"; } # client

#
# platform
#

alias hc='HostCleanup'

#
# Postgres
#

pg() { PostgresHelper "$@"; }

#
# projects
#

# PTC
ptc="$CLOUD/project/PTC" 				# PTC Root
ptcs="$ptc/shared/technical" 		# PTC Shared
ptco="$ptcs/Documentation/PTC"	# PTC Obsidian

# System Administration
sa="$CLOUD/project/System Administration" 			# System Administration Root
sas="$sa/shared/technical" 											# System Administration Shared
sao="$sas/Documentation/System Administration" 	# System Administration Obsidian

# Solumina
sol="$CLOUD/project/Solumina" 			# Solumina Root
sols="$sol/shared/technical" 				# Solumina Shared
solo="$sols/Documentation/Solumina" # Solumina Obsidian

#
# network
#

alias gma="GetMacAddress"
alias nconf="NetworkConf"
alias tf="TftpHelper"
alias wfn='WaitForNetwork'

clf() { CloudFlare "$@"; }
ncg() {	network current all; } 					# network current get
ncu() {	NetworkCurrentUpdate "$@"; }		# network current update
ncut() { ncu --force --timeout=1000; } 	# network current update with forst and higher timeout 
PingFix() { sudoc chmod u+s "$(FindInPath ping)" || return; }

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

DhcpServersWin()
{
	! IsPlatform win && return 1
	dhcptest.exe --query --wait --timeout ${1:-2} |& grep "Received packet from 1" | cut -d" " -f4 | cut -d":" -f1 | grep -v '^10.10.100.1$' | DnsResolveBatch | sort | uniq
}

# DhcpValidateReservation [server] - validate the current systems DHCP reservation on the specied DHCP server
DhcpValidateReservation()
{
	local verbose verboseLevel verboseLess; ScriptOptVerbose "$@"; [[ $verbose ]] && shift
	local server="$1"; [[ ! $server ]] && { server="$(GetServers dhcp | head -1)" || return; }
	
	local dhcpIp; dhcpIp="$(nmapp --sudo -sU -p67 --script dhcp-discover "$server" --script-args='dhcp-discover.dhcptype=DHCPREQUEST,dhcp-discover.mac=native' | grep "IP Offered" | RemoveCarriageReturn | cut -d":" -f2 | RemoveSpaceTrim)" || return
	log1 "dhcpIp=$dhcpIp" "DhcpValidateReservation"

	local ip; ip="$(GetIpAddress -4)" || return
	log1 "ip=$ip" "DhcpValidateReservation"

	[[ "$ip" == "$dhcpIp" ]]
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
SquidLog() { LogShow "$(SquidLogFile)"; }
SquidLogFile() { local file="/var/log/squid/access.log"; IsPlatform mac && file="$HOME/Library/Logs/squid/squid-access.log"; echo "$file"; }
SquidCheck() { IsAvailablePort "${1:-"proxy.butare.net"}" 3128; }
SquidHits() { grep "HIER_NONE" "$(SquidLogFile)"; }
SquidRestart() { sudo /etc/init.d/ProxyServer.sh restart; }
SquidUtilization() { squidclient -h "${1:-127.0.0.1}" cache_object://localhost/ mgr:utilization; }
SquidInfo() { squidclient -h "$1" cache_object://localhost/ mgr:info; }
ProxyCheck4() { local server="${1:-proxy.butare.net:3128}"; curl --silent --proxy "http://$server" "http://www.msftconnecttest.com/connecttest.txt"; }
ProxyCheck6() {	local server="${1:-proxy.butare.net:3128}"; curl --silent --proxy "http://$server" "http://ipv6.msftncsi.com/connecttest.txt"; }

# sync files
alias slf='SyncLocalFiles'
alias FindSyncTxt='fa --hidden --no-ignore '\..*_sync.txt''
alias RemoveSyncTxt='FindSyncTxt | xargs rm'; alias rst=RemoveSyncTxt
alias HideSyncTxt="FileHide .*_sync.txt"

# Virtual IP (VIP) - keepalived load balancer
VipStatus() { local vip="${1:-vip}" mac; MacLookup --detail "$vip"; }
VipMonitor() { MacLookup --monitor "${1:-vip}"; }
VipConnect() { [[ ! $1 ]] && set -- "vip"; SshHelper connect --trust "$@"; }

# web
awd() { ScriptCd apache dir web "$@" && ls; }		# Apache Web Dir
curle() { curl "$(UrlEncode "$1")" "${@:2}"; } 	# curl encode - encode spaces in the URL
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

# vpn - remove route which makes WSL network fail when connected to VPN
VpnFix()
{
	# validate
	network adapter exists vpn --quiet || { ScriptErr "not connected to VPN" "VpnFix"; return 1; }

	# network adapter vars - network adapter vars show 
	local name description linkSpeed ifIndex status cidr ip mask network broadcast defaultGateway mac
	
	# get VPN info
	ScriptEval network adapter vars vpn || return
	local vpnIp="$ip"
	local vpnIfIndex="$ifIndex"

	# get WSL info
	ScriptEval network adapter vars 'vEthernet (WSL (Hyper-V firewall))'
	echo "vpnIp=$vpnIp vpnIfIndex=$vpnIfIndex network=$network mask=$mask"

	# check for route to delete - may need to do this multiple times
	while route.exe print -4 | tr -s " " | qgrep"^ $network $mask On-link $vpnIp";  do
		elevate route.exe delete "$network" mask "$mask" 0.0.0.0 IF "$vpnIfIndex"
		sleep 1
	done

	# update the network configuration
	NetworkCurrentUpdate || return	
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

 	PS1="${title}${green}${host}${user}${root}${elevated}${git} ${cyan}$dir${clear} \$ "

	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -n;' 
	# PROMPT_COMMAND='history -a; history -r;' 
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

# logoff [USER](current)
logoff()
{
	local user="${${1}:-$USER}"

	if IsSsh; then exit
	elif IsPlatform win; then logoff.exe
	elif IsPlatform ubuntu; then gnome-session-quit --no-prompt
	elif IsPlatform mac; then
		[[ "$user" != "$USER" ]] && { sudoc launchctl bootout "user/$(${G}id -u "$user")"; return; } # does not prompt to re-open windows, login screen comes up quickly
		printf 'tell application "loginwindow" to \xc2\xabevent aevtrlgo\xc2\xbb' | osascript
	else ScriptErr "logoff not supported", "logoff"; return 1;
	fi		
}

NumProcessors() { cat /proc/cpuinfo | grep processor | wc -l; }

#
# media
#

alias gp="media get" # get pictures
alias mg="media get"

# Spotify
alias sp='SpotifyToggle'
SpotifyStart() { ! IsPlatform mac && return; start Spotify; }
SpotifyPlay() { ! IsPlatform mac && return; osascript -e 'tell application "Spotify" to play'; }
SpotifyPause() { ! IsPlatform mac && return; osascript -e 'tell application "Spotify" to pause'; }
SpotifyToggle() { ! IsPlatform mac && return; osascript -e 'tell application "Spotify" to playpause'; }

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
	echo "options netconsole netconsole=6666@$(GetIpAddress)/$(GetAdapterName),6666@$(GetIpAddress "$host")/$(GetMacAddress "$host")" | sudo tee "/etc/modprobe.d/netconsole.conf"
}

NetConsoleDisable()
{
	sudo sed -i "/^netconsole/d" "/etc/modules" || return
	sudo rm -f "/etc/modprobe.d/netconsole.conf"
}

#
# process
#

EnvClean() { env -u FUNCTIONS "$@"; }
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

fuh() { HeaderBig "$@ Usages" && fu "$@"; } 				# FindUsageHeader
fuf() { fu "$@" | cut -d":" -f1 | sort | uniq; } 		# FindUsagesFiles - find all script names that use the specified TEXT
fue() { fuf "$@" | xargs sublime; } 								# FindUsagesEdit - edit all script names that use the specified TEXT

# FindUsages TEXT - find all script usages of specified TEXT, fu1 Find Usages 1 line
fu() { ! InPath rg && { fug "$@"; return; }; rg "$@" "$BIN" "$UBIN" --trim --hidden --smart-case -g="!.git" -g="!.p10k.zsh" -g="!git-sh-prompt-win.sh"; } 
fug() { grep --color -ire "$1" --include="*" --exclude-dir=".git" --exclude=".p10k.zsh" --exclude="git-sh-prompt-win.sh" "$BIN" "$UBIN"; }

#
# security
#

alias cconf="CredentialConfStatus"
csd() { clipw $(cred get secure default); } # clip secure default

cred() { credential "$@"; }
1conf() { ScriptEval 1PasswordHelper unlock "$@" && 1PasswordHelper status; }

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
	if InPath play; then play "$@" # requires sox
	elif IsPlatform mac; then  afplay "$@"
	elif IsPlatform win; then
		powershell -c "$(cat <<-EOF
			(New-Object Media.SoundPlayer "$(utw "$@")").PlaySync();
		EOF
		)"
	else ScriptErr "no audio program was found" "playsoud"; return
	fi
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

if IsZsh; then
	ListAllVars() { comm  -2 -3 <(typeset + | rev | cut -d" " -f1 | rev | ${G}sort) <(ListSpecialVars); }
	ListVars() { comm  -2 -3 <(ListAllVars) <(ListExportVars); }	
	ListExportVars() { typeset -x -t + | ${G}sort; }
	ListFunctions() { typeset +f | ${G}sort; }
	ListSpecialVars() { typeset -h | ${G}sort; }
else
	ListAllVars() { declare -p | cut -d" " -f3 | cut -d"=" -f1 | ${G}sort; }
	ListVars() { declare -p | ${G}grep -v "^declare -x " | cut -d" " -f3 | cut -d"=" -f1 | ${G}sort; }
	ListExportVars() { declare -p | ${G}grep "^declare -x " | cut -d" " -f3 | cut -d"=" -f1 | ${G}sort; }
	ListFunctions() { declare -F | cut -d" " -f3 | ${G}sort; }
fi

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
# ZSH
#

alias zshl="EnvClean -- "$SHELL_DIR/zsh" -l"

#
# Butare Network
#

aconf() { nconf "$@" && hconf "$@" && cconf "$@" && sconf "$@"; }	# all configure, i.e. aconf -a=pi1 -f
bpull() { ( header "bin pull" && cd "$bin" && gpull "$@" ) && ( header "ubin pull" && cd "$ubin" && gpull "$@"); }																	# bin pull
bpullr() { ( header "bin pull reset" && cd "$bin" && g rbo && gpull "$@" ) && ( header "ubin pull reset" && cd "$ubin" && g rbo && gpull "$@"); }		# bin pull reset
bpush() { ( header "bin push" && cd "$bin" && gpush "$@" ) && ( header "ubin push" && cd "$ubin" && gpush "$@" ); }																	# bin push
config() { wiggin config change "$@" && ScriptEval network vars; }
unlock() { wiggin host credential -H=locked; }
vpn() { network vpn "$@"; }

# server
alias wsa='WigginServerApps' wsc='WigginServerCount'
WigginServerApps() { hashi app node status --active "$@"; }
WigginServerCount() { hashi nomad node allocs --numeric -H=active "$@"; }

# sync
sd="$UDATA/sync" 														# sync dir
sdn="$UDATA/sync/etc/nginx/sites-available" # sync dir Nginx

# SyncBin - create or merge bin and user bin directories using the cloud download directory
SyncBin()
{
	local dir="$dl"; IsInDomain sandia && dir="$cdl" 
	local exclude=('.git/*' '*.*_sync.txt')

	# bin
	if [[ -f "$dir/pbin.zip" ]]; then
		( cd "$TMP" && unzip "$dir/pbin.zip" -d "pbin" && merge --wait "pbin" "$bin" && rm -fr "pbin" "$dir/pbin.zip"; ) || return
	else
		( cd "$bin" && zip "$dir/pbin.zip" . -r --exclude "${exclude[@]}"; ) || return
	fi
	
	# ubin
	if [[ -f "$dir/ubin.zip" ]]; then
		( cd "$TMP" && unzip "$dir/ubin.zip" -d "ubin" && merge --wait "ubin" "$ubin" && rm -fr "ubin" "$dir/ubin.zip"; ) || return
	else
		( cd "$ubin" && zip "$dir/ubin.zip" . -r --exclude "${exclude[@]}"; ) || return
	fi
}

# SyncPlatform - create or merge the platform directory using the cloud download directory
SyncPlatform()
{
	local dir="$dl"; IsInDomain sandia && dir="$cdl" 
	local exclude=('.git/*' '*.*_sync.txt')

	if [[ -f "$dir/platform.zip" ]]; then
		( cd "$TMP" && unzip "$dir/platform.zip" -d "platform.bak" && merge --wait "platform.bak" "$DATA/platform" && rm -fr "platform.bak" "$dir/platform.zip"; ) || return
		return
	fi

	(
		# copy platform directory
		cd "$DATA" || return
		cp -rpL platform platform.bak || return

		# cleanup win directory
		cd "platform.bak/win" || return
		eval eval rm -f "$(SyncLocalFiles exclude all)" || return

		# compress platform directory
		cd "$DATA/platform.bak" || return
		zip "$dir/platform.zip" . -r --exclude "${exclude[@]}"

		# cleanup
		cd "$DATA" || return
		rm -fr "platform.bak" || return
	)
}

# SyncInstall - create or merge the public install directory using the cloud download directory
SyncInstall()
{
	local dir="$dl"; IsInDomain sandia && dir="$cdl" 
	local exclude=('.git/*' '*.*_sync.txt')
	local installDir; installDir="$(FindInstallFile)" || return

	# bin
	if [[ -f "$dir/install.zip" ]]; then
		( cd "$TMP" && unzip "$dir/install.zip" -d "install" && merge --wait "install" "$installDir" && rm -fr "$TMP/install" "$dir/install.zip"; ) || return
	else
		( cd "$installDir" && zip "$dir/install.zip" . -r --exclude "${exclude[@]}"; ) || return
	fi
}

# SyncMd [HOST](bl4) - synchronize markdown classify in and out files from a Sandia computer to bc
SyncMd()
{
	SshAgentConf || return
	
	local localDir="$cdata/app/Obsidian/personal/other" remote="${1:-bc}" remoteDir="data/app/Obsidian/personal/Personal"
	local _platformTarget _platformLocal _platformOs _platformIdMain _platformIdLike _platformIdDetail _platformKernel _machine _data _root _media _public _users _user _home _protocol _busybox _chroot _wsl pd ud udoc uhome udata wroot psm pp ao whome usm up _minimalInstall
	ScriptEval HostGetInfo "$remote" --detail --local || return; remoteDir="${whome}/${remoteDir}" # Windows home directory

	# transfer "Classify Out" to remote "Classify In"
	local srcFile="$localDir/Classify Out.md"
	[[ ! -f "$srcFile" ]] && { ScriptErr "'$(FileToDesc "$srcFile")' does not exist"; return 1; }

	local size; size="$(GetFileSize "$srcFile")" || return
	if (( size > 0 )); then
		local destFile="$remoteDir/Classify In.md"
		echo "Copying '$(FileToDesc "$srcFile")' to '$remote:$destFile'..."
		{ { echo "# $(GetFileTimeStampPretty "$srcFile")"; cat "$srcFile"; echo; } | ssh "$remote" "cat - >> \"$destFile\"" || return; }
		: > "$srcFile" || return
	fi

	# transfer "Classify In" from remote "Classify Out"
	local tmpFile="/tmp/Classify In.md" src="$remote:$remoteDir/Classify\ Out.md"
	scp -p "$src" "$tmpFile" || return
	size="$(GetFileSize "$tmpFile")" || return
	if (( size > 0 )); then
		local destFile="$localDir/Classify In.md"
		echo "Copying '$src' to '$(FileToDesc "$destFile")'..."
		{ { echo "# $(GetFileTimeStampPretty "$tmpFile")"; cat "$tmpFile"; echo; } >> "$destFile" || return; }
		ssh "$remote" ": > \"$remoteDir/Classify\ Out.md\"" || return
	fi

	return 0
}

# gm - Good Morning
gm()
{
	cls; echo; echo; HeaderFancy "Good     Morning     John"
	SpotifyStart && SpotifyPlay && UpdateAll "$@"
}

# apps
alias adc="AlarmDotCom"
remmina() {  (nohup flatpak run --user org.remmina.Remmina >& /dev/null &); }

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

# devices
cam() { wiggin device "$@" cam; }
wcore() { wiggin device "$@" core; }
wtest() { wiggin device "$@" test; }

# directories
hadcd() { cd "$(appdata "$1")/$2"; } 	# hadcd HOST DIR - host appdata cd to directory
mcd() { cd "//nas3/data/media"; } 		# mcd - media CD
bdir() { cd "$(AppGetBackupDir)"; } 	# backup dir

# encrypted files
encm() { encrypt mount "$cdata/app/CryFS/personal" "$@"; }
encum() { encrypt unmount "personal" "$@"; }

# netbootxyz
alias nb='netbootxyz'
alias nbcd='cd $(netbootxyz dir conf)'													# netbootxyz cd
alias nbem='netbootxyz edit menu' 															# netbootxyz edit menu
alias nbda='netbootxyz deploy all'															# netbootxyz deploy all
alias nbt='hyperv create --type=win --start'										# netbootxyz test
alias nbwu='netbootxyz update win auto'													# netbootxyz win update
alias nbwv='cat "$(netbootxyz dir win-install)/releases.txt"'		# netbootxyz win versions

# network DNS and DHCP configuration
alias ne='wiggin network edit'								# network edit
alias nep='e $DATA/setup/ports'								# network edit ports
alias nua='wiggin network update all'					# network update all
alias nud='wiggin network update dns'					# network update DNS
alias nudh='wiggin network update dhcp'				# network update DHCP

DownFix() { wiggin host network fix -H=down --errors --wait "$@"; }

DownInfo()
{
	local sep=","
	{
		hilight "name${sep}mac"
		DomotzHelper down || return
	} | column -c $(tput cols -T "$TERM") -t -s"${sep}"
}

# servers
alias sls='ServerLs' sns='ServerNodeStatus'
ServerLs() { wiggin host ls -H="$1" "${@:2}"; } # ServerLs all|down|hashi-prod|hashi-test|locked|important|network|reboot|restart|unlock|web
ServerNodeStatus() { hashi app node status --active "$@"; }

# update
alias u='HostUpdate' uc='UpdateClient' ua="UpdateAll" us='UpdateServer'
UpdateAll() { HostUpdate all "$@"; }
UpdateClient() { HostUpdate -w=file "$@" && HostUpdate "$@"; }
UpdateServer() { HostUpdate --what=server "$@"; }
UpdateServerWhat() { local what="${1:-os}"; [[ "$1" ]] && shift; PiSsh -- HostUpdate --what="$what" --force "$@"; }

alias ud="UpdateDownload" uf='UpdateFile'
UpdateDownload() { HostUpdate -w=download "$@"; }
UpdateFile() { slf "$@"; }

alias usa="UpdateServerAll" usc="UpdateServerCleanup" use="UpdateServerEligibility" usfail="UpdateServerFailed"
alias usf="UpdateServerFile" usff="UpdateServerFileFast" usfu="UpdateServerFileUnison"
alias usp="UpdateServerProxy" usrb="UpdateServerReboot" usrs="UpdateServerRestart" usr="UpdateServerRoot" usw="UpdateServerWhat"

UpdateServerAll() { usf "$@" && us "$@" && usc "@" && usr "$@"; }
UpdateServerCleanup() { hashi vault unseal && UpdateServerCredentials "$@" && UpdateServerEligibility "$@" && UpdateServerFailed; }
UpdateServerCredentials() { HostUpdate --what=server-credential "$@"; }
UpdateServerEligibility() { HostUpdate --what=server-eligibility "$@"; }
UpdateServerFailed() { hashi consul remove failed; }
UpdateServerFile() { HostUpdate --what=files "$@"; }
UpdateServerFileUnison() { HostUpdate --what=files "$@" -- --unison; }
UpdateServerFileFast() { wiggin host sync files --errors --dest-older "$@" -- --no-platform ; }
UpdateServerProxy() { wiggin; }
UpdateServerReboot() { wiggin host update reboot "$@"; }
UpdateServerRestart() { wiggin host update restart "$@"; }
UpdateServerRoot() { HostUpdate --what=server-root-user "$@"; }

# UniFi
alias uc='UniFiController'
SwitchPoeStatus() { ssh admin@$1 swctrl poe show; }

#
# Sandia
#

if IsInDomain sandia; then
	vpnon() { vpn on && WaitForNetwork "sandia" && "$@"; }
	vpnoff() { vpn off && WaitForNetwork "butare" && "$@"; }
fi

#
# Final Configuration
#

# platform
SourceIfExistsPlatform "$UBIN/.bashrc." ".sh" || return

# other
RunFunctions DotNetConf GitAnnexConf McflyConf NodeConf PythonConf SetTextEditor ZoxideConf || return

# run last
RunFunctions DbusConf || return
RunFunctions --ignore-errors SshAgentEnvConf || return
RunFunctions NetworkConf || return # depends on CredentialConf
RunFunctions --ignore-errors CredentialConf || return # depends on NetworkConf if on Sandia network
! IsDomainRestricted && { RunFunctions HashiConf || return; } # depends on CredentialConf, NetworkConf

# logging
if [[ $verbose ]]; then
	hilight "SSH Agent"; SshAgent status
	hilight "Credential Manager"; credential manager status
	hilight "Network"; network current status	
fi

unset -v force quiet verbose
[[ $timerOn ]] && TimerOff

return 0