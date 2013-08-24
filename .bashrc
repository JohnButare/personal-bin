# interactive shell intialization, from /etc/defaults/etc/skel/.bashrc, 
# non-interactive setup for "mintty" and "ssh <script>" 

#[[ "$-" == *i* ]] && echo "Running ~/.bashrc..."

#
# debug
#

#export BASH_DEBUG="yes"
[[ "$-" != *i* && $BASH_DEBUG ]] && echo 'BASH_DEBUG: in  ~/.bashrc'

#
# Global Variables (available from child processes and scripts)
#

set -a
[[ -d "/cygdrive/d/users" ]] && USERS="/cygdrive/d/users" || USERS="/cygdrive/c/users"
PUB="$USERS/Public"
BIN="$PUB/Documents/data/bin"
P32="/cygdrive/c/Program Files (x86)"
P64="/cygdrive/c/Program Files"
P="$P64"
DOC="$HOME/Documents"
set +a

#
# TEMP Directory
#

# Set temp directory to correct format for unix (TMP/TEMP) or Windows (tmp/temp).  

if [[ "$TMP" != "/tmp"  ]]; then
	export tmp=$(cygpath -w "$TMP" 2> /dev/null)
	export temp=$(cygpath -w "$TEMP" 2> /dev/null)
	export TMP="/tmp"
	export TEMP="/tmp"
	export appdata="$APPDATA"
	export APPDATA=$(cygpath -u "$appdata" 2> /dev/null)
fi;

#
# Path
#

PathAdd() # PathAdd <path> [front], front adds to front and drops duplicates in middle
{
	if [[ "$2" == "front" ]]; then
		PATH=$1:${PATH//:$1:/:}
	elif [[ ! $PATH =~ (^|:)$1(:|$) ]]; then
    PATH+=:$1
  fi
}

# /usr/bin and /usr/local/bin must be first in the path so Cygwin utilities are used
# before Microsoft utilities, /etc/profile adds them first, but profile is not
# called by "ssh <script>.sh
PathAdd "/usr/bin" "front"
PathAdd "/usr/local/bin" "front"

ManPathAdd() # ManPathAdd <path> [front], front adds to front and drops duplicates in middle
{
	if [[ "$2" == "front" ]]; then
		MANPATH=$1:${MANPATH//:$1:/:}
	elif [[ ! $MANPATH =~ (^|:)$1(:|$) ]]; then
    MANPATH+=:$1
  fi
}

ManPathAdd "$PUB/documents/data/man"

#
# Interactive Shell Initialization
#

# Return if not interactive - remainder not avalable to child processes or scripts
[[ "$-" != *i* ]] && return

[[ $BASH_DEBUG ]] && BASH_STATUS_INTERACTIVE_SHELL="true"

GREP_OPTIONS='--color=auto'
HISTCONTROL=erasedups
shopt -s autocd cdspell cdable_vars extglob

# functions
[[ -n "$BIN" && -f "$BIN/function.sh" ]] && . "$BIN/function.sh"

#
# locations - cd'able variables ($<var><return or tab>) 
#

# system
bin="$BIN"
i="$PUB/Documents/data/install"
p="$P"
p64="$P64"
p32="$P32"
#wintmp="$(wtu $tmp)" # problem: tmp not defined in ssh

# public
pub="$PUB"
pdata="$pub/Documents/data"
psm="$ProgramData\Microsoft\Windows\Start Menu" # PublicStartMenu
pp="$psm\Programs" # PublicPrograms

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
# Process
#
ParentProcessName() {  cat /proc/$PPID/status | head -1 | cut -f2; }

#
# SSH
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

SetPrompt
[[ "$PWD" == "/cygdrive/c" ]] && cd ~

#
# aliases
#

alias cf='tc CleanupFiles.btm'
alias cls=clear
alias e='TextEdit'
alias EnableCompletion='source /etc/bash_completion; SetPrompt'
function FileInfo() { file $1; tc FileInfo.btm $1; }
alias i='tc install.btm'
alias llv='declare -p | egrep -v "\-x"' # ListLocalVars
alias lev='export' # ListExportVars
alias os='tc os'
alias slf='tcc /c SyncLocalFiles.btm'
alias t='time pause'
alias te='TextEdit'
alias telnet='putty'
alias update='tc os.btm update'
alias unexport='unset'
alias unfunction='unset -f'
alias update='tc os update'

#
# applications
#

alias AutoItDoc="start $pdata/doc/AutoIt.chm"
alias bc='tc BeyondCompare'
alias chrome='tc chrome' # /opt/google/chrome/google-chrome
alias ew='tc expression web'
alias f='tc firefox'
alias ie='tc InternetExplorer'
alias m='tc merge.btm'
alias rdesk='cygstart mstsc /f /v:'
alias vm='tc VMware.btm'
alias wmp='tc WindowsMediaPlayer'
alias wmc='tc WindowsMediaCenter'

#
# media
#

alias gp='tc media.btm get'
alias ms='tc media.btm sync'

#
# portable and backup
#

alias b='tc sudo WigginBackup'
alias be='tc WigginBackup eject'

alias sp='tc portable sync'
alias mp='tc portable merge'
alias ep='tc portable eject'

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

ecd() { eval "$("$@")"; } # EvaluateCd <script> - run a script and change to the directory it outputs 
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cc='cd ~; cls'
alias del='rm'
#fpc() { [[ $# == 0 ]] && arg="$PWD" || arg="$(realpath $1)"; echo "$arg"; clipw "$arg"; }
fpc() { [[ $# == 0 ]] && arg="$PWD" || arg="$(realpath $1)"; echo "$(utw "$arg")"; utw "$arg" > /dev/clipboard; }
alias md='MkDir'
alias rd='RmDir'

# explorer
alias l='explorer .'
alias l32='tc explorer 32  /e,/root,/select,"$(utw $PWD)"'
alias l64='tc explorer 64  /e,/root,/select,"$(utw $PWD)"'

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
alias d='tc drive'
alias de='tc drive eject'
alias dl='tc drive list'
alias dr='tc drive list | egrep -i removable'

# disk usage
alias duh='du --human-readable'
alias ds='tc DirSize m'
alias dsu='tc DiskSpaceUsage'
alias dus='tc DiskUsage summary'

#
# edit
#

alias se='tc ShellEdit' # ShellEdit
alias ei='te $BIN/win32/install.btm' # $BIN/install.sh 
alias esetup='te $BIN/win32/setup.btm' # $BIN/setup.sh 
alias ehp='se $(utw "$udata/replicate/default.htm")'

# Bash
alias sa='. ~/.bashrc'
alias ea='te $ubin/.bashrc'

alias sf='. ~/.bashrc'
alias ef='te $BIN/function.sh'

alias bstart='source ~/.bash_profile; bind -f ~/.inputrc;'
alias estart='te /etc/profile /etc/bash.bashrc $ubin/.bash_profile $ubin/.bashrc'

alias ebo='te $ubin/.minttyrc $ubin/.inputrc /etc/bash.bash_logout $ubin/.bash_logout'

alias e4a='te $ubin/alias.tc'
alias e4f='te $bin/win32/function.tc'

# Autohotkey
alias ek='te $ubin/keys.ahk'
alias sk='tc AutoHotKey.btm restart'

# Startup
alias st='startup'
alias es='te $BIN/startup.sh'

# host file
alias ehosts='tc host file edit'
alias uhosts='tc host file update'

#
# scripts
#

alias bfind="file * | egrep \"Bourne-Again shell script|.sh:\" | cut -d: -f1 | xargs egrep -i"
bfindl() { bfind --color=always "$1" | less -R; }
bcommit() { pushd "$bin"; git status; git add -u; git commit -m "script changes"; git push; popd; pushd "$ubin"; git status; git add -u; git commit -m "script changes"; git push; popd; }

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

alias boot='tc host boot'
alias bw='tc host boot wait'
alias hib='tc power hibernate'
alias down='tc power shutdown'
alias reb='tc power reboot'
alias slp='tc power sleep'

#
# network
#

alias ipc='tc network ipc'
alias SshKey='ssh-add ~/.ssh/id_dsa'
alias sk='SshKey'
alias rs='RemoteServer'

alias slf='tc SyncLocalFiles'
alias SlfSo='slf SrcOlder'
alias SlfSoNb='slf SrcOlder NoBak'
alias SlfDo='slf DestOlder'
alias SlfDoNb='slf DestOlder NoBak'

#
# windows
#

alias cm='tc os ComputerManagement'
alias dm='tc os DeviceManager'
alias prog='tc os programs'
alias prop='tc os SystemProperties'
alias ResourceMonitor='tc os ResourceMonitor'
alias SystemRestore='tc vss'

alias ws='wscript /nologo'
alias cs='cscript /nologo'

#
# sound
#

playsound() { cat "$1" > /dev/dsp; }
alias sound='tc os sound'
alias ts='playsound "$ubin/test/test.wav"'

#
# wiggin
#

opub="//oversoul/Public"
ohome="//oversoul/John"
odl="$ohome/Documents/data/download"

alias wn='start "$cloud/Systems/Wiggin Network Notes.docx"'
alias house='start "$cloud/House/House Notes.docx"'
alias w='start "$cloud/other/wedding/Wedding Notes.docx"'

NasDrive='//butare.net@ssl@5006/DavWWWRoot'
NasDrive() { net use n: '\\butare.net@ssl@5006\DavWWWRoot' /user:jjbutare; }

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

alias ss='tc SqlServer'
alias ssp='tc SqlServer profiler express'

#
# JAVA Development
#

alias j='tc JavaUtil'
alias jd='j decompile'
alias jdp='j decompile progress'
alias jrun='j run'

alias ec='tc eclipse'

#
# Android Development
#

alias as='tc AndroidUtil.btm sdk'
alias ab='as adb'

#
# .NET Development
#

alias n='tc .net.btm'
build() { n MsBuild /verbosity:minimal /m "$(utw $code/$1)"; }
BuildClean() { n MsBuild /t:Clean /m "$(utw $code/$1)"; }
alias vs='tc VisualStudio.btm'

#
# Source Control
# 

gt="$code/test/git" # GitTest

alias tsvn='tc TortoiseSVN.btm'
alias svn='tsvn svn'
alias svnu='tsvn code update'
alias svnsw='tsvn code switch'
alias svnl='tsvn code log'
alias svnc='tsvn code commit'
alias svns='tsvn code status'

alias g='git'
alias gith='tc GitHelper.btm'
#alias git='gith git'
alias ge='gith extensions'
alias gi='{ ! IsFunction __git_ps1; } && source /etc/bash_completion && SetPrompt'

alias gg='tc GitHelper gui'
alias ggc='tc GitHelper gui commit'

#
# Intel
#

# phone
alias pb="tc lync PersonalBridge"

# locations
ihome="//jjbutare-mobl/john/documents"
ss="$ihome/group/Software\ Solutions"
SsSoftware="//VMSPFSFSCH09/DEV_RNDAZ/Software"

# primary laptop
alias MoblBoot="tc host boot jjbutare-mobl"
alias MoblConnect="tc host connect jjbutare-mobl"
alias MoblSleep="slp jjbutare-mobl"
alias MoblSync="slf jjbutare-mobl"
mdl="//jjbutare-mobl/John/Documents/data/download"

# vpn
alias vpn="tc intel vpn"
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

s()
{
	echo ${#1}
	echo "1=$1"
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
#AntidoteSetup call sudo.btm \\azscsisweb998\f$\Software\AntidoteSetup\AntidoteSetup.cmd
#AntidoteUpdate call sudo.btm copy "C:\Projects\Antidote\Antidote\bin\Debug\*" "C:\Program Files\Antidote"

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

#ssl call explorer.btm "\\%1\d$\Program Files\Scada\ScadaService\log"
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