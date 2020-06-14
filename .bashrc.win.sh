
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
wi() { wsl init test1 "$@"; } 					# Initialize
wt() { wslr test1 ubuntu-focal "$@"; } 	# reseT
wr() { wsl run test1 "$@"; } 						# Run

alias wsldown="wsl.exe --shutdown"
alias wv="wsl version"

wslr() { wsl delete "$1" "$@"; wsl restore "$1" "$2" 2; wsl init "$1"; } # reset DIST SRC