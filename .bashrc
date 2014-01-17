# ~/.bashrc, user specific interactive intialization, and non-interactive ("mintty" and "ssh <script>")

# sytem-wide configuration - if not done in /etc/bash.bashrc
if [[ ! $BIN ]]; then
	echo ".bashrc: system configuration was not set in /etc/bash.bashrc" > /dev/stderr
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

# completion
[[ -e /etc/bash_completion ]] && ! IsFunction __git_ps1 && source /etc/bash_completion # win
[[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]] && ! IsFunction __git_ps1 && . /usr/local/etc/bash_completion.d/git-prompt.sh # mac
complete -r cd >& /dev/null # cd should not complete variables without a leading $

#
# locations - lower case (not exported), for cd'able variables ($<var><return or tab>) 
#

# system
p="$P"
p64="$P64"
p32="$P32"
win="$data/platform/win"

# public
sys="/cygdrive/c"
pub="$PUB"
bin="$BIN"
data="$DATA"
psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" # PublicStartMenu
pp="$psm/Programs" # PublicPrograms
pd="$pub/Desktop" # PublicDesktop
i="$data/install" # install
v="/Volumes"

# user

home="$HOME"
doc="$DOC"
udoc="$DOC"
udata="$udoc/data"

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

alias p='"$p"' p32='"$p32"' p64='"$p64"' pp='"$pp"' up='"$up"'

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
alias update='os update'

#
# archive
#
alias fm='start "$p/7-Zip/7zFM.exe"'
7bak() { [[ $# == 1  ]] && 7z a -m1=LZMA2 "$1.7z" "$1" || 7z a -m1=LZMA2 "$1" "${@:2}"; }
alias untar='tar -v -x --atime-preserve <'
zbak() { [[ $# == 1  ]] && 7z a "$1.zip" "$1" || 7z a "$1" "${@:2}"; }
alias zrest='7z.exe x'
alias zls='7z.exe l'
alias zll='7z.exe l -slt'

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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cc='cd ~; cls'
alias del='rm'
alias md='MkDir'
alias rd='RmDir'
alias wln='start --direct "$BIN/win/ln.exe"' # Windows ln

# other
alias inf="FileInfo"
alias l='start explorer "$PWD"'
alias rc='CopyDir'

# list
alias ls=$G'ls -Q --color'	# list 
alias la='ls -Al'							# list all
alias ll='ls -l'							# list long
alias llh='ll -d .*'					# list long hidden
alias lh='ls -d .*' 					# list hiden
alias lt='ls -Ah --full-time'	# list time

alias dir='cmd /c dir'
alias dirss="ls -1s --sort=size --reverse --human-readable -l" # sort by size
alias dirst='ls -l --sort=time --reverse' # sort by last modification time
alias dirsct='ls -l --time=ctime --sort=time --reverse' # sort by creation  time
 #-l | awk '{ print \$5 \"\t\" \$9 }'

# find
alias fa='FindAll'
alias fcd='FindCd'
fclip() { file=$(FindAll $1 | head -1) && clipw "$file"; } # FindClip
fe() { file=$(FindAll $1 | head -1) && TextEdit "$file"; } # FindEdit
ft() { grep --color -i -r -e "$1" --include=$2 ${@:3}; } # FindText <text to find> '<file pattern>'

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
alias duh='du --human-readable'
alias ds='DirSize m'
alias dsu='DiskSpaceUsage'
alias dus='DiskUsage summary'

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
alias spi='merge "$data/install" "/cygdrive/k/data/install"' # SyncPortableInstall
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
SshFix() { SshAgent cleanup || return; SshAgent startup || return; ScriptEval SshAgent initialize; }

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

SetPrompt() 
{
	local cyan='\[\e[36m\]'
	local clear='\[\e[0m\]'
	local green='\[\e[32m\]'
	local red='\[\e[31m\]'
	local yellow='\[\e[33m\]'

	local dir='\w' user='\u' userAtHost='\u@\h'
	
	unset GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWUNTRACKEDFILES GIT_PS1_SHOWUPSTREAM
	GIT_PS1_SHOWUPSTREAM="auto verbose"; # GIT_PS1_SHOWDIRTYSTATE="true"; GIT_PS1_SHOWSTASHSTATE="true"; GIT_PS1_SHOWUNTRACKEDFILES="true";
	local git=''; IsFunction __git_ps1 && git='$(__git_ps1 " (%s)")'
	local gitColor=''; [[ $git ]]	&& gitColor='$( git status --porcelain 2> /dev/null | egrep .+ > /dev/null && echo -ne "'$red'")'

	local elevated=''; IsElevated && elevated='*'

	# compact
	# dir='$(GetPrompt)'; user=''; [[ "$(id -un)" != "jjbutare" ]] && user='\u '
	# userAtHost="${user}"; IsSsh && host="${user/ls/[[:space:]]/}@\h "
	# PS1="${elevated}${green}${host}${yellow}${dir}${clear}${cyan}${gitColor}${git}${clear}\$ "

	# multi-line
	PS1="\[\e]0;\w\a\]\n${green}${userAtHost}${red}${elevated} ${yellow}${dir}${clear}${cyan}${gitColor}${git}\n${clear}\$ "

	# share history with other shells when the prompt changes
	PROMPT_COMMAND='history -a; history -r'
}

[[ "$PS1" != *git_ps1* ]] && SetPrompt
[[ "$PWD" == "/cygdrive/c" ]] && cd ~

#
# Source Control
# 

gt="$code/test/git" # GitTest

alias cdc='code commit --gui'
alias cdl='code log'
alias cdr='code revert --gui'
alias cds='code status'
alias cdco='code checkout'
alias cdu='code update'

#alias git='ge' 
alias g='git'
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
sup() { gu "$bin" "script changes" || return; echo; gu "$ubin" "script changes"; }
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

playsound() { cat "$1" > /dev/dsp; }
alias sound='os sound'
alias ts='playsound "$ubin/test/test.wav"'

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

alias IntelSync='m7s; m install-CsisBuild; m install-dfs; m install-cr; slf -do CsisBuild.intel.com; slf -do -nb dfs; slf -do -nb cr'
alias HomeSync='m install-oversoul-CsisBuild; slf nas; slf -do CsisBuild.intel.com;'
alias is=IntelSync hs=HomeSync

# locations
ihome="//jjbutare-mobl/john/documents"
ss="$ihome/group/Software\ Solutions"
SsSoftware="//VMSPFSFSCH09/DEV_RNDAZ/Software"

# laptop
SetMobileAliases() 
{
	local m="$1" h="$1"; (( h == 1 )) && h=""
	alias m${m}b="HostUtil boot jjbutare-mobl${h}"
	alias m${m}c="HostUtil connect jjbutare-mobl${h}"
	alias m${m}slf="slf jjbutare-mobl${h}"
	alias m${m}slp="slp jjbutare-mobl${h}"
	eval "m${m}s() { HostUtil available jjbutare-mobl${h} && { m m${m}s; m${m}slf; }; }"	
	eval m${m}dl='//jjbutare-mobl${h}/c$/Users/jjbutare/Documents/data/download'
}
SetMobileAliases 1; SetMobileAliases 7; SetMobileAliases 9;

PrepKey() { local k="/cygdrive/e/mobl"; mkdir -p "$k/bin" "$k/doc"; }
SyncKey() { local k="/cygdrive/e/mobl" f="/filters=-.*_sync.txt"; m "$bin" "$k/bin" "$f"; m "$udoc" "$k/doc" "/filters=-data\\VMware\\;-data\\mail\\"; }

# vpn
alias vpn="intel vpn"
alias von="vpn on"
alias voff="vpn off"

# Source Control
alias ssu='mu;au;fru;spu;inu'
alias ssc='mc;ac;frc;spc;inc'

# Profile Manager
profiles="$P/ITBAS/Profiles"
alias profiles='"$profiles"'
alias pm='ProfileManager'
alias pcd='"$profiles"'
alias ProfileManagerConfig='TextEdit C:\winnt\system32\ProfileManager.xml'

ProfileManager() 
{
	local p="$P/ITBAS/ProfileManager/ProfileManager.exe"
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

alias aum='pushd .; mb && { "$ac/SolutionItems/Libraries/UpdateMagellan.cmd" && ab; }; popd'
alias aup='sudo cp "$code/Antidote/Antidote/bin/Debug/*" "$P/Antidote"' # Antidote Update ProgramFiles
alias aub='CopyDir "$code/Antidote/Antidote/bin/Debug" "//vmspwbld001/d$/Program Files/Antidote"; aubmq' # Antidote Update BuildServer
alias aul='CopyDir "$code/Antidote/Antidote/bin/Debug" "$P/Antidote"' # Antidote Update LocalServer
alias aubmq='CopyDir "$code/Antidote/Tools/MessageQueueCheck/bin/Debug" "//vmspwbld001/d$/Projects/Antidote/Tools/MessageQueueCheck/bin/Debug"'

#
# Magellan
#

mc="$code/Magellan"

alias mu='cdu Magellan'
alias mc='cdc Magellan'
alias mst='cds Magellan'
alias mr='cdr Magellan'

alias mb='build Magellan/Source/Magellan.sln'
alias mbc='BuildClean Magellan/Source/Magellan.sln'
alias mlb='antidote App=Magellan BuildType=LocalBuild CacheBrokerAddress=@DatabaseServer@'

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

alias spu='cdu ScadaPortal'
alias spc='cdc ScadaPortal'
alias sps='cds ScadaPortal'
alias spr='cdr ScadaPortal'
alias spco='cdco ScadaPortal'

alias spb='build ScadaPortal/Source/ScadaPortal.sln'
alias spbc='BuildClean ScadaPortal/Source/ScadaPortal.sln'

alias spua='ab && { start "$sp/Libraries/UpdateAntidote.cmd" && spb; }'
alias spum='mb && { start "$sp/Libraries/UpdateMagellan.cmd" && spb; }'

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
deploy() { pushd $spc/Setup/Deploy/Deploy/bin/Debug > /dev/null; start --direct ./deploy.exe "$@"; popd > /dev/null; }
alias DeployLocal='deploy LogDirectory="$(utw "$sys/temp/ScadaPortalDeployment/log")"'

# deploy log
alias dlog='deploy log'
alias dll='DeployLocal log'
alias dlt='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Test.Log.vmspwbld001.txt'
alias dlpp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/PreProduction.Log.vmspwbld001.txt'
alias dlp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Production.Log.vmspwbld001.txt'

# deploy - test CI
alias dpmTestAll='dpmp test=true force=false'
alias dpmTest='dpmp Servers=RAC2FMSF-CIM;RAC2FMSC-CIM;RAPB1FMSAA-CIM test=true force=true'

# deploy to test
alias dra='DeployLocal RelayAgent force=true'
alias dss='DeployLocal ScadaService force=true'
alias dhdb='DeployLocal HistorianDb force=true DeployClr=true NoSecondary=false'
alias ddl='DeployLocal DataLogger force=true InstallDataLogger=false ConfigureDataLogger=true PopPoints=true'
alias dac='DeployLocal AlertChecker force=true'
alias dpm='DeployLocal PointManagement force=true'
alias dw='DeployLocal Web force=true'

# deploy to pre-production
alias draPP='DeployLocal RelayAgent force=true environment=PreProduction'
alias dwPP='DeployLocal web force=true environment=PreProduction'
alias dacPP='DeployLocal AlertChecker force=true environment=PreProduction'
alias dssPP='DeployLocal ScadaService force=true environment=PreProduction'
alias dhdbPP='DeployLocal HistorianDb force=true environment=PreProduction'

# deploy to pilot
alias dwPILOT='DeployLocal web force=true environment=Production servers=ORPRSPS'

# deploy production
alias drap='deploy deploy Environment=Production force=true'
alias draRA='drap SqlServers=RASBK1SQLS,3180:CB3'
alias draRR='drap SqlServers=RRSBK1SQLS,3180:CUB'

alias dpmp='deploy PointManagement Environment=Production DeployOutsideFirewall=false'
alias dpmAL='dpmp SqlServers=ALSBK1SQLS,3180:AFO'
alias dpmHD='dpmp SqlServers=HDSBK1SQLS,3180:F17_FMS'
alias dpmJR='dpmp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ'
alias dpmLC='dpmp SqlServers=LCSBK1SQLS,3180:EPMS'
alias dpmOC='dpmp SqlServers=OCSBK1SQLS,3180:F22_HPM'
alias dpmRA='dpmp SqlServers=RASBK1SQLS,3180:CB3'
alias dpmRR='dpmp SqlServers=RRSBK1SQLS,3180:CUB'
alias dpmIR='dpmp SqlServers=IRsbk1sqls,3180:F10'

alias dssp='deploy ScadaService Environment=Production DeployOutsideFirewall=false'
alias dssJR='dssp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ'
alias dssRA='dssp SqlServers=RASBK1SQLS,3180:CB3 servers=RAsbk1sqls;RAspr1sqls'
alias dssRR='dssp SqlServers=RRSBK1SQLS,3180:F11X servers=RRsbk1sqls;RRspr1sqls '
alias dssIR='dss Environment=PreProduction SqlServers=IRsbk1sqls,3180:F10 servers=IRsbk1sqls;IRspr1sqls'

alias dacp='deploy AlertChecker Environment=Production DeployOutsideFirewall=false'
alias DacRA='dacp SqlServers=RASBK1SQLS,3180:CB3 Servers=rasD1Bprcimf'
alias DacRR='dacp SqlServers=RRsbk1sqls,3180:CUB'

alias ddlp='deploy DataLogger Environment=Production InstallDataLogger=false DeployOutsideFirewall=false'
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
