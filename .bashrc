# user specific interactive shell intialization, from /etc/defaults/etc/skel/.bashrc, 
# non-interactive setup for "mintty" and "ssh <script>" 

# sytem-wide configuration - if not done in /etc/bash.bashrc
if [[ ! $BIN ]]; then
	echo "System configuration was not set in /etc/bash.bashrc" > /dev/stderr
	[[ -d "/cygdrive/d/users" ]] && export USERS="/cygdrive/d/users" || export USERS="/cygdrive/c/users"
	[[ -f "$USERS/Public/Documents/data/bin/bash.bashrc" ]] && . "$USERS/Public/Documents/data/bin/bash.bashrc"
fi

# non-interactive initialization (available from child processes and scripts)
set -a
GREP_OPTIONS='--color=auto'
LESS='-R'
LESSOPEN='|~/.lessfilter %s'
set +a

# interactive initialization - remainder not needed in child processes or scripts
[[ "$-" != *i* ]] && return

HISTCONTROL=erasedups
shopt -s autocd cdspell cdable_vars

# ssh
[[ -f "~/.ssh/environment" ]] && . "~/.ssh/environment"

# common functions
[[ -n "$BIN" && -f "$BIN/function.sh" ]] && . "$BIN/function.sh"

#
# locations - lower case (not exported), for cd'able variables ($<var><return or tab>) 
#

# system
p="$P"
p64="$P64"
p32="$P32"

# public
pub="$PUB"
bin="$BIN"
data="$pub/Documents/data"
psm="$PROGRAMDATA/Microsoft/Windows/Start Menu" # PublicStartMenu
pp="$psm/Programs" # PublicPrograms
pd="$pub/Desktop" # PublicDesktop
i="$PUB/Documents/data/install"

# user
home="$HOME"
doc="$DOC"
udoc="$DOC"
udata="$udoc/data"
cloud="$home/Dropbox"
code="$CODE"
dl="$udata/download"
ubin="$udata/bin"
usm="$APPDATA/Microsoft/Windows/Start Menu" #UserStartMenu
up="$usm/Programs" # UserPrograms
ud="$home/Desktop" # UserDesktop

# shortcuts
alias p='"$p"'
alias p32='"$p32"'
alias p64='"$p64"'
alias pp='"$pp"'
alias up='"$up"'

#
# temporary
#

a="$PUB/Documents/data/archive"
alias eoi='te "$a/install.btm"'

#
# process
#
ParentProcessName() {  cat /proc/$PPID/status | head -1 | cut -f2; }

#
# ssh
#

RemoteServer() { who am i | cut -f2  -d\( | cut -f1 -d\); }
IsSsh() { [ -n "$SSH_TTY" ] || [ "$(RemoteServer)" != "" ]; }
ShowSsh() { IsSsh && echo "Logged in from $(RemoteServer)" || echo "Not using ssh";}
[[ -f "$HOME/.ssh/environment" ]] && . "$HOME/.ssh/environment"

#
# prompt
#

GetPrompt()
{
	if [[ "$PWD" == "$HOME" ]]; then
		echo '~'
	elif [[ ${#PWD} > 20 ]]; then
		local tmp=${PWD%/*/*};
		[ ${#tmp} -gt 0 -a "$tmp" != "$PWD" ] && echo ${PWD:${#tmp}+1} || echo $PWD;
	else
		echo $PWD
	fi;
}

SetPrompt() 
{
	local green='\[\e]0;\w\a\]\[\e[32m\]'
	local yellow='\[\e[33m\]'
	local clear='\[\e[0m\]'
	local dir='$(GetPrompt)'
	#local dir='\[\e[33m\]\w\[\e[0m\]'
	local user=''; [[ "$(id -un)" != "jjbutare" ]] && user='\u '
	local host="${user}"; IsSsh && host="${user//[[:space:]]/}@\h "
	local git=''; IsFunction __git_ps1 && git='$(__git_ps1 " (%s)")'
	local elevated=''; IsElevated && elevated='*'

	PS1="${elevated}${green}${host}${yellow}${dir}${clear}${git}\$ "
}

[[ "$PS1" != *GetPrompt* ]] && SetPrompt
[[ "$PWD" == "/cygdrive/c" ]] && cd ~

#
# aliases
#

alias cf='CleanupFiles'
alias cls=clear
alias e='TextEdit'
alias c='EnableCompletion'; 
alias EnableCompletion='source /etc/bash_completion; SetPrompt'
function FileInfo() { file $1; FileInfo "$1"; }
i() { [[ $# == 0 ]] && { ScriptCd inst cd "$@"; return; } || inst "$@"; }
alias llv='declare -p | egrep -v "\-x"' # ListLocalVars
alias lev='export' # ListExportVars
alias t='time pause'
alias te='TextEdit'
alias telnet='putty'
alias update='os update'
alias unexport='unset'
alias unfunction='unset -f'
alias update='os update'

#
# applications
#

alias s="start"
alias AutoItDoc="start $pdata/doc/AutoIt.chm"
alias bc='BeyondCompare'
alias chrome='chrome' # /opt/google/chrome/google-chrome
alias ew='expression web'
alias f='firefox'
alias ie='InternetExplorer'
alias m='merge'
alias rdesk='cygstart mstsc /f /v:'
alias vm='VMware'
alias wmp='WindowsMediaPlayer'
alias wmc='WindowsMediaCenter'
alias wmic="$WINDIR/system32/wbem/WMIC.exe"

#
# media
#

alias gp='media get'
alias ms='media sync'
alias si='merge "$pdoc/data/install" "//nas/public/documents/data/install"'
alias sk='SyncKey'

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
# file management
#

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cc='cd ~; cls'
alias del='rm'
fpc() { [[ $# == 0 ]] && arg="$PWD" || arg="$(realpath "$1")"; echo "$arg"; clipw "$arg"; }
wfpc() { [[ $# == 0 ]] && arg="$PWD" || arg="$(realpath "$1")"; echo "$(utw "$arg")"; utw "$arg" > /dev/clipboard; }
alias md='MkDir'
alias rd='RmDir'
alias wln='start --direct "$BIN/win/ln.exe"' # Windows ln

# explorer
alias l='start explorer "$PWD"'

# list
alias ls='ls -Q --color'
alias la='ls -Al'
alias ll='ls -l'
alias llh='ll -d .*'
alias lh='ls -d .*'
alias lt='ls -Ah --full-time'

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

# copy
alias CopyAll='xcopy /e /v /k /r /h /x /o /c'
RoboCopyAll() { RoboCopy /z /ndl /e /w:3 /r:3 "$(utw $1)" "$(utw $2)"; }
RoboCopyDir() { RoboCopyAll "$1" "$2/$(basename "$1")"; }
alias rc='RoboCopyAll'
alias rcd='RoboCopyDir'

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
alias ehp='se $(utw "$udata/replicate/default.htm")'

# Bash (aliases, functions, startup, other)
alias sa='. ~/.bashrc'
alias ea='te $ubin/.bashrc'

alias ef='te $bin/function.sh'
alias sf='. function.sh'

alias bstart='source "$bin/bash.bashrc"; source ~/.bash_profile; bind -f ~/.inputrc;'
alias estart='te /etc/profile /etc/bash.bashrc "$bin/bash.bashrc" "$ubin/.bash_profile" "$ubin/.bashrc"'

alias ebo='te $ubin/.minttyrc $ubin/.inputrc /etc/bash.bash_logout $ubin/.bash_logout'

# Autohotkey
alias EditKey='te $ubin/keys.ahk'
alias SetKey='AutoHotKey restart'

# Startup
alias st='startup'
alias es='te $ubin/startup.sh'

# host file
alias ehosts='host file edit'
alias uhosts='host file update'

#
# scripts
#

alias scd='ScriptCd'
alias se='ScriptEval'

alias slist='file * | egrep "Bourne-Again shell script|.sh:" | cut -d: -f1'
alias sfind='slist | xargs egrep'
sfindl() { sfind --color=always "$1" | less -R; }
alias sedit='slist | xargs RunFunction.sh TextEdit'
alias slistapp='slist | xargs egrep -i "IsInstalledCommand\(\)" | cut -d: -f1'
alias seditapp='slistapp | xargs RunFunction.sh TextEdit'

scommit() { pushd "$bin"; git status; git add -u; git commit -m "script changes"; git push; popd; pushd "$ubin"; git status; git add -u; git commit -m "script changes"; git push; popd; }

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
# power management
#

alias boot='host boot'
alias bw='host boot wait'
alias connect='host connect'
alias hib='power hibernate'
alias down='power shutdown'
alias reb='power reboot'
alias slp='power sleep'

#
# network
#

alias ipc='network ipc'
alias SshKey='ssh-add ~/.ssh/id_dsa'
alias rs='RemoteServer'
alias slf='SyncLocalFiles'

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
# sound
#

playsound() { cat "$1" > /dev/dsp; }
alias sound='os sound'
alias ts='playsound "$ubin/test/test.wav"'

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

nas='//nas/public'
ni="$nas/documents/data/install"
nr='//butare.net@ssl@5006/DavWWWRoot'
NasDrive() { net use n: "$(utw "$nr")" /user:jjbutare "$@"; }

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
# Source Control
# 

gt="$code/test/git" # GitTest

alias tsvn='TortoiseSVN'
alias svn='tsvn svn'
alias code='tsvn code'
alias svnc='tsvn code commit'
alias svnl='tsvn code log'
alias svnr='tsvn code revert'
alias svns='tsvn code status'
alias svnsw='tsvn code switch'
alias svnu='tsvn code update'

alias g='git'
alias gh='GitHelper'
alias ghgit='gith git'
alias ge='gith extensions'
alias gi='{ ! IsFunction __git_ps1; } && source /etc/bash_completion && SetPrompt'

alias gg='GitHelper gui'
alias ggc='GitHelper gui commit'

#
# Intel
#

# phone
alias pb="lync PersonalBridge"

# locations
ihome="//jjbutare-mobl/john/documents"
ss="$ihome/group/Software\ Solutions"
SsSoftware="//VMSPFSFSCH09/DEV_RNDAZ/Software"

# laptop
alias m1b="host boot jjbutare-mobl"
alias m1c="host connect jjbutare-mobl"
alias m1slf="slf jjbutare-mobl"
alias m1slp="slp jjbutare-mobl"
m1dl="//jjbutare-mobl/John/Documents/data/download"

alias m7b="host boot jjbutare-mobl7"
alias m7c="host connect jjbutare-mobl7"
alias m7slf="slf jjbutare-mobl7"
alias m7slp="slp jjbutare-mobl7"
m7s() { m7slf || return; m m7s; }
m7dl="//jjbutare-mobl7/John/Documents/data/download"

PrepKey() { local k="/cygdrive/e/mobl"; mkdir -p "$k/bin" "$k/doc"; }
SyncKey() { local k="/cygdrive/e/mobl" f="/filters=-.*_sync.txt"; m "$bin" "$k/bin" "$f"; m "$udoc" "$k/doc" "/filters=-data\\VMware\\;-data\\mail\\"; }

# vpn
alias vpn="intel vpn"
alias von="vpn on"
alias voff="vpn off"

# Source Control
alias ssu='mu;au;fru;spu;'
alias ssc='mc;ac;frc;spu;'

# Profile Manager
profiles="$P/ITBAS/Profiles"
alias profiles='"$profiles"'
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

alias pm='ProfileManager'
alias ProfileManagerConfig='TextEdit C:\winnt\system32\ProfileManager.xml'

#
# Tablet POC
#

alias albert='rdesk asmadrid-mobl2'

#
# Magellan
#

mc="$code/Magellan"
alias mu='svnu Magellan'
alias mc='svnc Magellan'
alias mb='build Magellan/Source/Magellan.sln'
alias mst='svns Magellan'

#
# Antidote
#

ac="$code/Antidote"
as="$ac/SolutionItems/DataScripts/MigrationScripts"

alias au='svnu Antidote'
alias ac='svnc Antidote'
alias as='svns Antidote'
alias ar='svnr Antidote'

alias ab='build Antidote/Antidote.sln'
alias abc='BuildClean Antidote/Antidote.sln'
alias alb='"$ac/SolutionItems/BuildConfiguration/RunLocalBuild.cmd"'

alias ap='ProfileManager Antidote'

alias aum='pushd .; mb && { "$ac/SolutionItems/Libraries/UpdateMagellan.cmd" && ab; }; popd'
alias aup='sudo cp "$code/Antidote/Antidote/bin/Debug/*" "$P/Antidote"'

#
# FaSTr
#

fr="$code/RPIAD"
frc="$fr/Source"
frs="$fr/DataScripts"

alias fru='svnu RPIAD'
alias frc='svnc RPIAD'
alias frs='svns RPIAD'
alias frr='svnr RPIAD'
alias frsw='svnsw RPIAD'

alias frb='build RPIAD/Source/RPIAD.sln'
alias frbc='BuildClean RPIAD/Source/RPIAD.sln'
alias frlb='sudo antidote App=Rpiad BuildType=LocalBuild'

alias frp="ProfileManager Rpiad"
alias frpu='cp "$fr/Profiles/Rpiad.profile" "$profiles/Rpiad.profile"'
alias frput='cp "$fr/Profiles/DevProfiles/Test/Rpiad.profile" "$profiles"'
alias frpc='cp "$profiles/Rpiad.profile" "$fr/Profiles"'

alias frt='$frc/Test/WebServiceTest/bin/Debug/WebServiceTest.exe'

#
# SCADA Portal
#

sp="$code/ScadaPortal"
sps="$sp/DataScripts"
spc="$sp/Source"

alias spu='svnu ScadaPortal'
alias spc='svnc ScadaPortal'
alias sps='svns ScadaPortal'
alias spr='svnr ScadaPortal'
alias spsw='svnsw ScadaPortal'

alias spb='build ScadaPortal/Source/ScadaPortal.sln'
alias spbc='BuildClean ScadaPortal/Source/ScadaPortal.sln'

alias spua='pushd .; ab && { "$sp/Libraries/UpdateAntidote.cmd" && spb; }; popd'
alias spum='pushd .; mb && { "$ac/SolutionItems/Libraries/UpdateMagellan.cmd" && spb; }; popd'

alias pmu='pushd "$spc/PointManagementUtility/PointManagement/bin/Debug" > /dev/null; start PointManagement.exe; popd > /dev/null'

# logs
ssl() { start explorer "//$1/d$/Program Files/Scada/ScadaService/log"; }
alias sslSiPr='ssl rasSI1prsqls'
alias sslSiBk='ssl rasSI1bksqls'
alias sslPpPr='ssl rasPPprsqls'
alias sslPpBk='ssl rasPPbksqls'

# deployment
deploy() { pushd $spc/Setup/Deploy/Deploy/bin/Debug > /dev/null; start --direct ./deploy.exe "$@"; popd > /dev/null; }
alias DeployLocal='deploy LogDirectory=/tmp/ScadaPortalDeployment/log'

# deployment log
alias dlog='deploy log'
alias dll='DeployLocal log'
alias dlt='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Test.Log.vmspwbld001.txt'
alias dlpp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/PreProduction.Log.vmspwbld001.txt'
alias dlp='TextEdit //vmspwbld001/d$/temp/ScadaPortalDeployment/log/Production.Log.vmspwbld001.txt'

# deployment test CI
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