
# applications
alias ahkr="ahk /restart \"$DOC/data/bin/keys.ahk\""  # AutoHotKey Restart
alias cmd="cmd.exe"
alias autoruns='start --elevate autoruns.exe'
alias winget='cmd.exe /c winget.exe'
alias wmic="$WINDIR/system32/wbem/WMIC.exe"

ahk() { start "$P/AutoHotkey/AutoHotkeyU64.exe" "$@"; } # AutoHotKey
rdesk() { ( mstsc.exe '/f' '/v:'"${@}" & ) }

# credentials
WinCredList() {  wincred.exe list '*' | sort | grep -v '^secret-' | RemoveCarriageReturn; }

# monitor
alias monden='monprofile den'
alias monstudy='monprofile study'
alias moninfo='cs $win/UltraMon.js info'
monprofile() { start "$cloud/data/UltraMon/$1.umprofile"; }

# network
alias NetConfig='control.exe netconnections'
alias ewhosts='elevate RunScript TextEdit /mnt/c/Windows/System32/drivers/etc/hosts' # edit windows hosts file

# operating system
alias cm='start CompMgmt.msc'
alias credm='start control /name Microsoft.CredentialManager'
alias dm='start DevMgmt.msc'
alias prog='product gui'
alias vss='vss.exe'
alias wh="$WIN_HOME"

# VBA
alias ws='start wscript.exe /nologo'
alias cs='start cscript.exe /nologo'

# utilities
alias ffw='elevate powershell FlipFlopWheel.ps1'
z7bak() { [[ $# == 1  ]] && 7z a -m1=LZMA2 "$1.7z" "$1" || 7z a -m1=LZMA2 "$1" "${@:2}"; }

# wsl
wcd() { cd "$(wsl get dir)/image"; }									# cd
wcdi() { cd "$(wsl get ImageDir)"; }									# cd image
wn() { wsl get name; }																# name
wr() { wsl dist run "$@"; }														# run DIST
wsld() { wsl shutdown; }															# shutdown WSL
wslr() { wsl dist restore "$@" && wsl install "$1"; } # reset DIST SRC

# test1 distribution
wslTestDist="test1"
wt() { wsl dist run test1 "$@"; } 														# run test distribution
wtr() { wslr "$wslTestDist" ubuntu-focal --no-prompt "$@"; } 	# reset test distribution
wti() { wsl install "$wslTestDist" "$@"; } 										# install test distribution
