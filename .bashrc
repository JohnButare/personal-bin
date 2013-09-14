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
psm="$ProgramData\Microsoft\Windows\Start Menu" # PublicStartMenu
pp="$psm\Programs" # PublicPrograms
i="$PUB/Documents/data/install"

# user
home="$HOME"
doc="$DOC"
udata="$doc/data"
cloud="$home/Dropbox"
code="/cygdrive/c/Projects"
dl="$udata/download"
ubin="$udata/bin"
usm="$APPDATA\Microsoft\Windows\Start Menu" #UserStartMenu
up="$usm\Programs" #UserPrograms

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
alias i='install'
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

FindAll()
{
	[[ $# == 0 ]] && { echo No file specified; return; }
	find . -iname $*
}

FindCd()
{
	local dir=$(FindAll $* | head -1)

	if [ -z "$dir" ]; then
		echo Could not find $*
	else
		"$dir"
	fi;
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cc='cd ~; cls'
alias del='rm'
fpc() { [[ $# == 0 ]] && arg="$PWD" || arg="$(realpath $1)"; echo "$arg"; clipw "$arg"; }
wfpc() { [[ $# == 0 ]] && arg="$PWD" || arg="$(realpath $1)"; echo "$(utw "$arg")"; utw "$arg" > /dev/clipboard; }
alias md='MkDir'
alias rd='RmDir'

# explorer
alias l='explorer .'
#alias l32='explorer 32  /e,/root,/select,"$(utw $PWD)"'
#alias l64='explorer 64  /e,/root,/select,"$(utw $PWD)"'

# list
alias la='ls -QAl'
alias ll='ls -Ql'
alias ls='ls -Q --color'
alias lt='ls -QAh --full-time'
alias lsh='file * | egrep "Bourne-Again shell script"'

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

alias se='ShellEdit'
alias ei='te $bin/install'
alias esetup='te $bin/setup'
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
alias ek='te $ubin/keys.ahk'
alias sk='AutoHotKey restart'

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
alias hib='power hibernate'
alias down='power shutdown'
alias reb='power reboot'
alias slp='power sleep'

#
# network
#

alias ipc='network ipc'
alias SshKey='ssh-add ~/.ssh/id_dsa'
alias sk='SshKey'
alias rs='RemoteServer'
alias slf='SyncLocalFiles'
alias slfdo='SyncLocalFiles -do'
alias slfdonb='SyncLocalFiles -do -nb'

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
nasr='//butare.net@ssl@5006/DavWWWRoot'
NasDrive() { net use n: "$(utw $nasr)" /user:jjbutare "$@"; }

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

alias as='AndroidUtil sdk'
alias ab='as adb'

#
# .NET Development
#

alias n='.net'
build() { n MsBuild /verbosity:minimal /m "$(utw $code/$1)"; }
BuildClean() { n MsBuild /t:Clean /m "$(utw $code/$1)"; }
alias vs='VisualStudio'

#
# Source Control
# 

gt="$code/test/git" # GitTest

alias tsvn='TortoiseSVN'
alias svn='tsvn svn'
alias svnu='tsvn code update'
alias svnsw='tsvn code switch'
alias svnl='tsvn code log'
alias svnc='tsvn code commit'
alias svns='tsvn code status'

alias g='git'
alias gith='GitHelper'
#alias git='gith git'
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

# primary laptop
alias MoblBoot="host boot jjbutare-mobl"
alias MoblConnect="host connect jjbutare-mobl"
alias MoblSleep="slp jjbutare-mobl"
alias MoblSync="slf jjbutare-mobl"
mdl="//jjbutare-mobl/John/Documents/data/download"

# vpn
alias vpn="intel vpn"
alias von="vpn on"
alias voff="vpn off"

# Source Control
alias ssu='mu;au;fru;'
alias ssc='mc;ac;frc;'

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

alias au='svnu Antidote'
alias ac='svnc Antidote'

#antidote "C:\Projects\Antidote\Antidote\bin\Debug\Antidote.exe"
#AntidoteSetup call sudo \\azscsisweb998\f$\Software\AntidoteSetup\AntidoteSetup.cmd
#AntidoteUpdate call sudo copy "C:\Projects\Antidote\Antidote\bin\Debug\*" "C:\Program Files\Antidote"

#ac: code:\Antidote
#as: ac:\SolutionItems\DataScripts\MigrationScripts
#ap ProfileManager Antidote
#alb ac:\SolutionItems\BuildConfiguration\RunLocalBuild.cmd
#ab build Antidote\Antidote.sln
#ast svns Antidote

#auf `pushd & ac:\SolutionItems\Libraries\UpdateFramework.cmd & ab & popd`
#aum `pushd & ac:\SolutionItems\Libraries\UpdateMagellan.cmd & ab & popd`

#
# FaSTr
#

alias fru='svnu RPIAD'
alias frc='svnc RPIAD'

#fr: code:\RPIAD
#frc: fr:\Source
#frs: fr:\DataScripts

#frlb call sudo antidote `App=Rpiad` `BuildType=LocalBuild`
#frb build RPIAD\Source\RPIAD.sln
#frbc BuildClean RPIAD\Source\RPIAD.sln
#frs svns RPIAD
#frc svnc RPIAD
#frr svnr RPIAD
#frsw svnsw RPIAD

#fru svnu RPIAD
#frum `pushd & mb & if %? == 0 fr:\Libraries\UpdateMagellan.cmd & if %? == 0 frb & popd`

#frp ProfileManager Rpiad
#frpu copy fr:\Profiles\Rpiad.profile profiles:\Rpiad.profile
#frput copy fr:\Profiles\DevProfiles\Test\Rpiad.profile profiles:
#frpc copy profiles:\Rpiad.profile fr:\Profiles

#frt frc:\Test\WebServiceTest\bin\Debug\WebServiceTest.exe

#
# SCADA Portal
#

# code

#sp: code:\ScadaPortal
#sps: code:\ScadaPortal\DataScripts
#spc: code:\ScadaPortal\Source

#spb build ScadaPortal\Source\ScadaPortal.sln
#spbc BuildClean ScadaPortal\Source\ScadaPortal.sln
#sps svns ScadaPortal
#spc svnc ScadaPortal
#spr svnr ScadaPortal
#spsw svnsw ScadaPortal 

#spu svnu ScadaPortal
#spua `pushd & ab & if %? == 0 sp:\Libraries\UpdateAntidote.cmd & if %? == 0 spb & popd`
#spum `pushd & mb & if %? == 0 sp:\Libraries\UpdateMagellan.cmd & if %? == 0 spb & popd`

# programs

#pm `pushd spc:\PointManagementUtility\PointManagement\bin\Debug & PointManagement.exe & popd` # PointManagement
#sac `spc:\ScadaAlerts\ScadaAlertChecker\bin\Debug\ScadaAlertChecker.exe` # ScadaAlertChecker

# logs

#ssl call explorer "\\%1\d$\Program Files\Scada\ScadaService\log"
#SslSiPr ssl rasSI1prsqls
#SslSiBk ssl rasSI1bksqls
#SslPpPr ssl rasPPprsqls
#SslPpBk ssl rasPPbksqls

# deployment

#deploy `pushd C:\Projects\ScadaPortal\Source\Setup\Deploy\Deploy\bin\Debug && Deploy.exe %$ && popd`
#DeployLocal `deploy LogDirectory=c:\temp\ScadaPortalDeployment\log`

# deployment log
#dlog deploy log
#dll DeployLocal log
#dlt TextEdit \\vmspwbld001\d$\temp\ScadaPortalDeployment\log\Test.Log.vmspwbld001.txt
#dlpp TextEdit \\vmspwbld001\d$\temp\ScadaPortalDeployment\log\PreProduction.Log.vmspwbld001.txt
#dlp TextEdit \\vmspwbld001\d$\temp\ScadaPortalDeployment\log\Production.Log.vmspwbld001.txt

# deployment test CI
#DpmTestAll dpmp test=true force=false
#DpmTest dpmp Servers=RAC2FMSF-CIM;RAC2FMSC-CIM;RAPB1FMSAA-CIM test=true force=true

# deploy to test
#dra DeployLocal RelayAgent force=true
#dss DeployLocal ScadaService force=true
#dhdb DeployLocal HistorianDb force=true DeployClr=true NoSecondary=false
#ddl DeployLocal DataLogger force=true InstallDataLogger=false ConfigureDataLogger=true PopPoints=true
#dac DeployLocal AlertChecker force=true
#dpm DeployLocal PointManagement force=true
#dw DeployLocal Web force=true

# deploy to pre-production
#drapp DeployLocal RelayAgent force=true environment=PreProduction
#dwpp DeployLocal web force=true environment=PreProduction
#dacpp DeployLocal AlertChecker force=true environment=PreProduction
#dsspp DeployLocal ScadaService force=true environment=PreProduction
#dhdbpp DeployLocal HistorianDb force=true environment=PreProduction

# deploy production
#drap deploy deploy Environment=Production force=true
#DraRa drap SqlServers=RASBK1SQLS,3180:CB3
#DraRr drap SqlServers=RRSBK1SQLS,3180:CUB

#dpmp deploy PointManagement Environment=Production DeployOutsideFirewall=false
#DpmAl dpmp SqlServers=ALSBK1SQLS,3180:AFO
#DpmHd dpmp SqlServers=HDSBK1SQLS,3180:F17_FMS
#DpmJr dpmp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ
#DpmLc dpmp SqlServers=LCSBK1SQLS,3180:EPMS
#DpmOc dpmp SqlServers=OCSBK1SQLS,3180:F22_HPM
#DpmRa dpmp SqlServers=RASBK1SQLS,3180:CB3
#DpmRr dpmp SqlServers=RRSBK1SQLS,3180:CUB
#DpmIr dpmp SqlServers=IRsbk1sqls,3180:F10

#dssp deploy ScadaService Environment=Production DeployOutsideFirewall=false
#DssJr dssp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ
#DssRa dssp SqlServers=RASBK1SQLS,3180:CB3 servers=RAsbk1sqls;RAspr1sqls
#DssRr dssp SqlServers=RRSBK1SQLS,3180:F11X servers=RRsbk1sqls;RRspr1sqls 
#DssIr dss Environment=PreProduction SqlServers=IRsbk1sqls,3180:F10 servers=IRsbk1sqls;IRspr1sqls

#dacp deploy AlertChecker Environment=Production DeployOutsideFirewall=false
#DacRa dacp SqlServers=RASBK1SQLS,3180:CB3 Servers=rasD1Bprcimf
#DacRr dacp SqlServers=RRsbk1sqls,3180:CUB

#ddlp deploy DataLogger Environment=Production InstallDataLogger=false DeployOutsideFirewall=false
#DdlIr deploy DataLogger SqlServers=IRsbk1sqls,3180:F10 Environment=PreProduction InstallDataLogger=true ConfigureDataLogger=false PopPoints=false

#dhdbp deploy HistorianDb Environment=Production DeployClr=true
#dhdbIDPJ dhdbp SqlServers=JRSBK1SQLS.ger.corp.intel.com,3180:IDPJ;JRSPR1SQLS.ger.corp.intel.com,3180:IDPJ
#dhddLC dhdbp SqlServers=LCSBK1SQLS.ger.corp.intel.com,3180:EPMS;LCSBK1SQLS.ger.corp.intel.com,3180:F28;LCSBK1SQLS.ger.corp.intel.com,3180:LC12;LCSBK1SQLS.ger.corp.intel.com,3180:LCC2;LCSBK1SQLS.ger.corp.intel.com,3180:MBR
#dhdbD1D dhdbp SqlServers=RASBK1SQLS,3180:D1D
#dhdbTD1 dhdbp SqlServers=RASBK1SQLS,3180:TD1

#dwp deploy Web Environment=Production
#DwpDl dwp Servers=shsprsps