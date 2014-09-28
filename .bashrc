# ~/.bashrc, user specific interactive intialization, and non-interactive ("mintty" and "ssh <script>")

# sytem-wide configuration - if not done in /etc/bash.bashrc
if [[ ! $BIN ]]; then
	[[ "$-" == *i* ]] && echo ".bashrc: system configuration was not set in /etc/bash.bashrc" > /dev/stderr
	[[ -f /usr/local/data/bin/bash.bashrc ]] && . "/usr/local/data/bin/bash.bashrc"
fi

# non-interactive initialization (available from child processes and scripts)
set -a
GREP_OPTIONS='--color=auto'
LESS='-R'
LESSOPEN='|~/.lessfilter %s'
#IGNOREEOF=1
set +a

# interactive initialization - remainder not needed in child processes or scripts
[[ "$-" != *i* ]] && return

HISTCONTROL=erasedups
shopt -s autocd cdspell cdable_vars histappend

# completion - win
[[ -e /etc/bash_completion ]] && ! IsFunction __git_ps1 && { . /etc/bash_completion; . git-prompt.sh; }

# completion - mac
[[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]] && ! IsFunction __git_ps1 &&
	{ . /usr/local/etc/bash_completion.d/git-prompt.sh; . /usr/local/etc/bash_completion.d/git-completion.bash; }

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
code="$CODE"
dl="$HOME/Downloads"
ubin="$udata/bin"
usm="$APPDATA/Microsoft/Windows/Start Menu" #UserStartMenu
up="$usm/Programs" # UserPrograms
ud="$home/Desktop" # UserDesktop

cloud="$home/Dropbox"
cdata="$cloud/data"
cdl="$cdata/download"

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
alias ew='expression web'
alias f='firefox'
alias h='HostUtil'
alias ie='InternetExplorer'
alias m='merge'
alias npp='notepadpp start'
alias powershell="$WINDIR/system32/WindowsPowerShell/v1.0/powershell.exe"
alias rdesk='cygstart mstsc /f /v:'
alias vm='VMware'
alias wmp='WindowsMediaPlayer'
alias wmc='WindowsMediaCenter'
alias wmic="$WINDIR/system32/wbem/WMIC.exe"

#
# misc
#
alias cf='CleanupFiles'
alias cls=clear
alias telnet='putty'
alias u='os update'

#
# archive
#
alias fm='start "$p/7-Zip/7zFM.exe"'
7bak() { [[ $# == 1  ]] && 7z a -m1=LZMA2 "$1.7z" "$1" || 7z a -m1=LZMA2 "$1" "${@:2}"; }
alias untar='tar -v -x --atime-preserve <'
zbak() { local z="zip -r"; [[ "$PLATFORM" == "win" ]] && z="7z.exe a"
	[[ $# == 1  ]] && $z "$1.zip" "$1" || $z "$1" "${@:2}"; }
alias zrest='[[ "$PLATFORM" == "win" ]] && 7z.exe x || unzip'
alias zls='[[ "$PLATFORM" == "win" ]] && 7z.exe l || unzip -l'
alias zll='[[ "$PLATFORM" == "win" ]] && 7z.exe l -slt || unzip -ll'

#
# variables and functions
#
alias ListVars='declare -p | egrep -v "\-x"'
alias ListExportVars='export'
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
alias cc='builtin cd ~; cls'
alias del='rm'
alias md='MkDir'
alias rd='RmDir'
alias wln='start --direct "$BIN/win/ln.exe"' # Windows ln

UncCd()
{
	! IsUncPath "$1" && { builtin cd "$@"; return; }
	[[ ! "$(GetUncShare "$1")" ]] && { unc list "$1"; return; }
	ScriptCd unc mount "$1" || return
}

UncLs()
{
	local ls="${G}ls -Q --color" unc="${@: -1}"
	! IsUncPath "$unc" && { command $ls "$@"; return; }
	[[ ! "$(GetUncShare "$unc")" ]] && { unc list "$unc"; return; }
	local dir; dir="$(unc mount "$unc")" || return
	$ls "${@:1:$#-1}" "$dir"
}

#
# package management
#
alias choco='chocolatey'
alias cinst='chocolatey install'
alias clist='chocolatey list'
alias cpack='chocolatey pack'
alias cpush='chocolatey push'
alias cuninst='chocolatey uninstall'
alias cup='chocolatey update'
alias cver='chocolatey version'

# other
alias inf="FileInfo"
alias l='explore'
alias rc='CopyDir'

# list
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

# find
alias fa='FindAll'
alias fcd='FindCd'
fclip() { file=$(FindAll $1 | head -1) && clipw "$file"; } # FindClip
fe() { file=$(FindAll $1 | head -1) && TextEdit "$file"; } # FindEdit
ft() { local startDir="${@:3}"; grep --color -i -r -e "$1" --include=$2 "${startDir:-.}"; } # FindText TEXT FILE_PATTERN [START_DIR](.)

FindAll()
{
	[[ $# == 0 ]] && { echo "No file specified"; return; }
	find . -iname "$@"
}

FindCd()
{
	local dir="$(FindAll "$@" | head -1)"

	if [ -z "$dir" ]; then
		echo Could not find "$@"
	else
		"$dir"
	fi;
}

# drives
alias d='drive'
alias de='drive eject'
alias dl='drive list'
alias dr='drive list | egrep -i removable'

# disk usage
alias duh='${G}du --human-readable'
alias ds='DirSize m'
alias dsu='DiskSpaceUsage'
alias dus='${G}du --summarize --human-readable'
alias TestDisk='sudo bench32.exe'

#
# edit/set
#

alias ei='te $bin/inst'
alias ehp='edit "$udata/replicate/default.htm"'

# Bash (aliases, functions, startup, other)
alias sa='. ~/.bashrc'
alias ea='te $ubin/.bashrc'

alias ef='te $bin/function.sh'
alias sf='. function.sh'

alias kstart='bind -f ~/.inputrc'
alias ek='te ~/.inputrc'

alias bstart='. "$bin/bash.bashrc"; . ~/.bash_profile; kstart;'
alias estart='te /etc/profile /etc/bashrc /etc/bash.bashrc "$bin/bash.bashrc" "$ubin/.bash_profile" "$ubin/.bashrc"'

alias ebo='te $ubin/.minttyrc $ubin/.inputrc /etc/bash.bash_logout $ubin/.bash_logout'

# Autohotkey
alias EditKey='te $ubin/keys.ahk'
alias SetKey='AutoHotKey restart'

# Startup
alias st='startup'

# host file
alias ehosts='HostUtil file edit'
alias uhosts='HostUtil file update'

#
# media
#

alias gp='media get'
alias ms='media sync'
alias sm='merge "$pub/Music" "//nas/music"'
alias si='merge "$data/install" "//nas/public/documents/data/install"' # SyncInstall
alias sk='SyncKey'

alias et='exiftool'
alias etg='start exiftoolgui' # ExifToolGui

#
# network
#

ScriptEval SshAgent initialize

nu() { net use "$(ptw "$1")" "${@:2}"; } # NetUse
alias ipc='network ipc'
IsSsh() { [ -n "$SSH_TTY" ] || [ "$(RemoteServer)" != "" ]; }
RemoteServer() { who am i | cut -f2  -d\( | cut -f1 -d\); }
alias slf='SyncLocalFiles'
alias SshKey='ssh-add ~/.ssh/id_dsa'
SshShow() { IsSsh && echo "Logged in from $(RemoteServer)" || echo "Not using ssh";}
SshFix() { SshAgent fix || return; ScriptEval SshAgent initialize; }
alias sshf='SshFix'

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

GetPrompt()
{
	if [[ "$PWD" == "$HOME" ]]; then
		echo '~'
	elif (( ${#PWD} > 20 )); then
		local tmp="${PWD%/*/*}";
		(( ${#tmp} > 0 )) && [[ "$tmp" != "$PWD" ]] && echo "${PWD:${#tmp}+1}" || echo "$PWD";
	else
		echo "$PWD"
	fi;
}

GitPrompt()
{
	local gitColor red='\e[31m'

	unset GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWUNTRACKEDFILES GIT_PS1_SHOWUPSTREAM
	#if [[ -d .git ]]; then
		#gitColor="$(git status --porcelain 2> /dev/null | egrep .+ > /dev/null && echo -ne "$red")"
		GIT_PS1_SHOWUPSTREAM="auto verbose"; 
		#GIT_PS1_SHOWDIRTYSTATE="true" # shows *, slow
		#GIT_PS1_SHOWSTASHSTATE="true"	 # shows $
		#GIT_PS1_SHOWUNTRACKEDFILES="true" # shows %
	#fi
	__git_ps1 "$gitColor (%s)"
}

SetPrompt() 
{
	local cyan='\[\e[36m\]'
	local clear='\[\e[0m\]'
	local green='\[\e[32m\]'
	local red='\[\e[31m\]'
	local yellow='\[\e[33m\]'

	local dir='\w' user='\u' userAtHost='\u@\h'
	
	local git; IsFunction __git_ps1 && git='$(GitPrompt)'
	local elevated; IsElevated && elevated='*'

	# compact
	# dir='$(GetPrompt)'; user=''; [[ "$(id -un)" != "jjbutare" ]] && user='\u '
	# userAtHost="${user}"; IsSsh && host="${user/ls/[[:space:]]/}@\h "
	# PS1="${elevated}${green}${host}${yellow}${dir}${clear}${cyan}${gitColor}${git}${clear}\$ "

	# multi-line
	PS1="\[\e]0;\w\a\]\n${green}${userAtHost}${red}${elevated} ${yellow}${dir}${clear}${cyan}${git}\n${clear}\$ "

	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -r'
}

SetPrompt
[[ "$PWD" == @(/cygdrive/c|/usr/bin) ]] && cd ~

#
# Source Control
# 

# code

alias cdc='code commit --gui'
alias cdl='code log'
alias cdr='code revert --gui'
alias cds='code status'
alias cdco='code checkout'
alias cdu='code update'

# git

alias eg='te ~/.gitconfig'

alias g='git'
alias gl='g l'

complete -o default -o nospace -F _git g
alias gcy='/usr/bin/git' 			# Cygwin Git
alias ge='"$P32/Git/bin/git"' # Git Extensions Git
alias gg='GitHelper gui'
alias gh='GitHelper'
alias ghub='GitHelper hub'
alias tgg='GitHelper tgui'

alias gd='gh down'
alias gc='gg commit'
alias gu='gh up'
alias gb='gh browse'

# svn

alias svn='TortoiseSVN svn'
alias tsvn='TortoiseSVN'

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
sup() { local m="script changes from $COMPUTERNAME${1+: $1}"; gu "$bin" "$m" || return; gu "$ubin" "$m"; }
sdn() { gd "$bin"; gd "$ubin"; }
scm() { gc "$bin"; gc "$ubin"; }

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

#
# sound
#

playsound() { case "$PLATFORM" in win) cat "$1" > /dev/dsp;; mac) afplay "$1";; esac; }
alias sound='os sound'
alias ts='playsound "$data/setup/test.wav"'

#
# windows
#

alias cm='os ComputerManagement'
alias dm='os DeviceManager'
alias prog='product gui'
alias prop='os SystemProperties'
alias ResourceMonitor='os ResourceMonitor'
alias SystemRestore='vss'

alias ws='wscript /nologo'
alias cs='cscript /nologo'

#
# wiggin
#

alias BeanSync='sup; sdn; unc mount //nas/home && merge bean-udata; unc mount //nas/public/documents/data && merge bean-data'

opub="//oversoul/Public"
ohome="//oversoul/John"
oi="$opub/Documents/data/install"
odl="$ohome/Documents/data/download"

alias wn='start "$cloud/Systems/Wiggin Network Notes.docx"'
alias house='start "$cloud/House/House Notes.docx"'
alias w='start "$cloud/other/wedding/Wedding Notes.docx"'

nas='//nas'
ni="$nas/public/documents/data/install"
nr='//butare.net@ssl@5006/DavWWWRoot'
ng='git@butare.net:/volume1/git'
NasDrive() { net use n: "$(utw "$nr")" /user:jjbutare "$@"; }
alias nslf='slf nas'
alias nrslf='slf butare.net'

#
# XML
#

alias XmlValue='xml sel -t -v'
alias XmlShow='xml sel -t -c'

#
# Development
#

test="$code/test"
www="/cygdrive/c/inetpub/wwwroot"

alias ss='SqlServer'
alias sscd='ScriptCd SqlServer cd'
alias ssp='SqlServer profiler express'

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

alias n='DotNet'
alias ncd='scd DotNet cd'
alias gcd='scd DotNet GacCd'
build() { n build /verbosity:minimal /m "$code/$1"; }
BuildClean() { n build /t:Clean /m "$code/$1"; }
alias vs='VisualStudio'

#
# Intel
#

alias MoblSyncInstall='m install-nas-rrsprsps'
alias IntelSyncLocalFiles='slf CsisBuild-new.intel.com; slf CsisBuild-dr.intel.com' # slf -do -nb rrsprsps; slf -do -nb dfs; slf -do -nb cr
alias IntelSyncInstall='m install-CsisBuildNew; m install-CsisBuildDr; m install-dfs' # m install-cr
alias msi=MoblSyncInstall isi=IntelSyncInstall islf=IntelSyncLocalFiles
alias SetIntelProxy='se intel SetProxy'
export GITHUB_HOST=github.intel.com

# locations
s="$home/Syncplicity"
ihome="//jjbutare-mobl/john/documents"
ss="$ihome/group/Software\ Solutions"
SsSoftware="//VMSPFSFSCH09/DEV_RNDAZ/Software"

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

# Source Control
alias ssu='mu;au;spu'
alias ssc='mc;ac;spc'

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
# Antidote
#

ac="$code/Antidote"
as="$ac/SolutionItems/DataScripts/MigrationScripts"

alias au='cdu Antidote'
alias ac='cdc Antidote'
alias as='cds Antidote'
alias ar='cdr Antidote'

alias ab='build Antidote/Antidote.sln'
alias abc='BuildClean Antidote/Antidote.sln'
alias alb='antidote verbose App=Antidote BuildType=LocalBuild'

alias ap='ProfileManager Antidote'
alias apu='cp "$ac/SolutionItems/Profiles/"*.profile "$profiles"'

alias aum='start "$ac/SolutionItems/Libraries/UpdateMagellan.cmd"'
alias aup='sudo cp "$code/Antidote/Antidote/bin/Debug/*" "$P/Antidote"' # Antidote Update ProgramFiles
alias aub='CopyDir "$code/Antidote/Antidote/bin/Debug" "//CsisBuild-new.intel.com/d$/Program Files/Antidote"; aubmq' # Antidote Update BuildServer
alias aul='CopyDir "$code/Antidote/Antidote/bin/Debug" "$P/Antidote"' # Antidote Update LocalServer
alias aubmq='CopyDir "$code/Antidote/Tools/MessageQueueCheck/bin/Debug" "//CsisBuild-new.intel.com/d$/Projects/Antidote/Tools/MessageQueueCheck/bin/Debug"'

#
# Magellan
#

mc="$code/Magellan"
ms="$mc/Source"

alias mu='cdu Magellan'
alias mc='cdc Magellan'
alias mst='cds Magellan'
alias mr='cdr Magellan'

alias mb='build Magellan/Source/Magellan.sln'
alias mbc='BuildClean Magellan/Source/Magellan.sln'
alias mlb='antidote App=Magellan BuildType=LocalBuild CacheBrokerAddress=@DatabaseServer@'

alias mpu='cp "$mc/Profiles/"*.profile "$profiles"'

#
# FaSTr
#

fr="$code/RPIAD"
frc="$fr/Source"
frs="$fr/DataScripts"

alias fru='cdu RPIAD'
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

sp="$code/ScadaPortal"
sps="$sp/DataScripts"
spc="$sp/Source"

alias spic='g integrate Continuous'
alias spit='g integrate Test'
alias spipp='g integrate Pre-Production'

alias spu='cdu ScadaPortal'
alias spc='cdc ScadaPortal'
alias sps='cds ScadaPortal'
alias spr='cdr ScadaPortal'
alias spco='cdco ScadaPortal'

alias spb='build ScadaPortal/Source/ScadaPortal.sln'
alias spbc='BuildClean ScadaPortal/Source/ScadaPortal.sln'
alias splb='antidote App=ScadaPortal BuildType=LocalBuild'
alias sptb='antidote App=ScadaPortal BuildType=DeployToTest'

alias spua='start "$sp/Libraries/UpdateAntidote.cmd"'
alias spum='start "$sp/Libraries/UpdateMagellan.cmd"'

alias pmu='pushd "$spc/PointManagementUtility/PointManagement/bin/Debug" > /dev/null; start PointManagement.exe; popd > /dev/null'

# service
alias sstStop='service stop ScadaService RASSI1PRSQLS; service stop ScadaService RASSI1BKSQLS; echo "Disable AlertChecker to prevent automatic service start"'
alias sstStart='service start ScadaService RASSI1PRSQLS; service start ScadaService RASSI1BKSQLS;'
alias sstStatus='service status ScadaService RASSI1PRSQLS; service status ScadaService RASSI1BKSQLS;'

# logs
ssl() { start explorer "//$1/d$/Program Files/Scada/ScadaService/log"; }
alias ssll='start explorer "$P/Scada/ScadaService/Log"'
alias ssltpr='ssl rasSI1prsqls'
alias ssltbk='ssl rasSI1bksqls'
alias sslpppr='ssl rasPPprsqls'
alias sslppbk='ssl rasPPbksqls'

# deploy
deploy() { pushd $spc/Deploy/Deploy/bin/Debug > /dev/null; start --direct ./deploy.exe "$@"; popd > /dev/null; }

# deploy log
alias dlog='deploy log'
alias dll='deploy log'
alias dlt='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Test.Log.vmspwbld001.txt'
alias dlpp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/PreProduction.Log.vmspwbld001.txt'
alias dlp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Production.Log.vmspwbld001.txt'

# deploy - test CI
alias dpmTestAll='dpmp test=true force=false'
alias dpmTest='dpmp Servers=RAC2FMSF-CIM;RAC2FMSC-CIM;RAPB1FMSAA-CIM test=true force=true'

# deploy to test
alias dra='deploy RelayAgent force=true'
alias dss='deploy ScadaService force=true'
alias dhdb='deploy HistorianDb force=true DeployClr=true NoSecondary=false'
alias ddl='deploy DataLogger force=true InstallDataLogger=false ConfigureDataLogger=true PopPoints=true DeployScreens=true AddPoints=true'
alias dac='deploy AlertChecker force=true'
alias dpm='deploy PointManagement force=true'
alias dw='deploy Web force=true'

# deploy to pre-production
alias draPP='deploy RelayAgent force=true environment=PreProduction'
alias dwPP='deploy web force=true environment=PreProduction'
alias dacPP='deploy AlertChecker force=true environment=PreProduction'
alias dssPP='deploy ScadaService force=true environment=PreProduction'
alias dhdbPP='deploy HistorianDb force=true environment=PreProduction'

# deploy to pilot
alias dwPILOT='deploy web force=true environment=Production servers=ORPRSPS'

# deploy production
alias drap='deploy deploy Environment=Production force=true'
alias draRA='drap SqlServers=RASBK1SQLS,3180:CB3'
alias draRR='drap SqlServers=RRSBK1SQLS,3180:CUB'

alias dpmp='deploy PointManagement Environment=Production'
alias dpmAL='dpmp SqlServers=ALSBK1SQLS,3180:AFO'
alias dpmHD='dpmp SqlServers=HDSBK1SQLS,3180:F17_FMS'
alias dpmJR='dpmp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ'
alias dpmLC='dpmp SqlServers=LCSBK1SQLS,3180:EPMS'
alias dpmOC='dpmp SqlServers=OCSBK1SQLS,3180:F22_HPM'
alias dpmRA='dpmp SqlServers=RASBK1SQLS,3180:CB3'
alias dpmRR='dpmp SqlServers=RRSBK1SQLS,3180:CUB'
alias dpmIR='dpmp SqlServers=IRsbk1sqls,3180:F10'

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

#ccdir="$(wtu '\\csisbuild-new.intel.com\d$\Program Files (x86)\CruiseControl.NET\server')"
#ccdir="$(wtu '\\csisbuild.intel.com\d$\Program Files (x86)\CruiseControl.NET\server')"
#ccdir="$(wtu '\\csisbuild.intel.com\d$\Program Files (x86)\CruiseControl.NET - PreProd\server')"
ccdir="$(wtu '\\csisbuild.intel.com\d$\Program Files (x86)\CruiseControl.NET - Prod\server')"

ccpu()
{
	CopyDir "$code/CruiseControlPlugins/Source/ccnet.GitHub.plugin/bin/Debug" "$ccdir" /xf '*.pdb' '*.vshost.*' 'log4net.dll' 'NetReflector.dll' 'ThoughtWorks.*'
	CopyDir "$code/CruiseControlPlugins/Source/GitHubApi/bin/Debug" "$ccdir" /xf '*.pdb' '*.vshost.*'
}

ccts() { cctray close; cp "$APPDATA/cctray-settings-$1.xml"  "$APPDATA/cctray-settings.xml"; cctray startup; } # CruiseControlTraySettings
