
# applications
alias cmd="cmd.exe"
alias autoruns='start --elevate autoruns.exe'
alias powershell="$WINDIR/system32/WindowsPowerShell/v1.0/powershell.exe"
alias wmic="$WINDIR/system32/wbem/WMIC.exe"
rdesk() { ( mstsc.exe '/f' '/v:'"${@}" & ) }

# monitor
alias monden='monprofile den'
alias monstudy='monprofile study'
alias moninfo='cs $win/UltraMon.js info'
monprofile() { start "$cloud/data/UltraMon/$1.umprofile"; }

# network
alias NetConfig='control.exe netconnections'

# operating system
alias cm='start CompMgmt.msc'
alias credm='start control /name Microsoft.CredentialManager'
alias dm='start DevMgmt.msc'
alias ev='start eventvwr.msc'
alias ipconfig='ipconfig.exe'
alias prog='product gui'
alias vss='vss.exe'
alias wh="$WIN_HOME"
alias WindowSpy="start Au3Info.exe"

# VBA
alias ws='start wscript.exe /nologo'
alias cs='start cscript.exe /nologo'

# utilities
alias ffw='elevate powershell FlipFlopWheel.ps1'
z7bak() { [[ $# == 1  ]] && 7z a -m1=LZMA2 "$1.7z" "$1" || 7z a -m1=LZMA2 "$1" "${@:2}"; }

# wsl
wsld="$DATAD/data/wsl" # dir

# test1 distribution
alias wt="wreset2"
wreset1() { wslr test1 ubuntu-bionic 1 "$@"; } 	# reset as Ubuntu-Bionic (18.04) WSL 1
wreset2() { wslr test1 ubuntu-focal 2 "$@"; } 	# reset as Ubuntu-Focal (20.04) WSL 2
wi() { wsl init test1 "$@"; } 									# initialize test1 - run bootstrap-init
wr() { wsl run test1 "$@"; } 										# run test1

wn() { echo "$(wsl name) (WSL $WSL)"; } 							# name of current distribution
wv() { echo "WSL $(wsl version)" | figlet | lolcat; } # version of current distribution

wsldown() { wsl.exe --shutdown; } 										# shutdown all distributions
wslr() { wsl delete "$1" "$@"; wsl restore "$1" "$2" "${3:-2}"; wsl init "$1"; } # reset DIST SRC
