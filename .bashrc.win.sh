# locations
alias wh="$WIN_HOME"
alias wr="$WIN_ROOT"

# applications
alias ahkr="ahk /restart \"$DOC/data/bin/keys.ahk\""  # AutoHotKey Restart
alias autoruns='start --elevate autoruns.exe'
alias dm='start DevMgmt.msc'
alias prog='product gui'
alias vss='vss.exe'
alias winget='cmd.exe /c winget.exe'
alias wmic="$WINDIR/system32/wbem/WMIC.exe"
alias wt='WindowsTerminal'

ahk() { AutoHotKey "$@"; } # AutoHotKey
FlipFlopWheel() { RunScript --functions --elevate -- powershell "$(utw "$win/FlipFlopWheel.ps1")"; }
PortForward() { RunScript --elevate -- powershell.exe WslPortForward.ps1; }
rdesk() { ( mstsc.exe '/f' '/v:'"${@}" & ) }
sqlcmd() { "$P/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/SQLCMD.EXE" "$@"; }

# credentials
WinCredList() {  wincred.exe list '*' | sort | grep -v '^secret-' | RemoveCarriageReturn; }

# network
alias NetConfig='control.exe netconnections'
alias ewhosts='elevate RunScript TextEdit /mnt/c/Windows/System32/drivers/etc/hosts' # edit windows hosts file

# process
procmon() { start --elevate procmon.exe; }

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
wslr() { wsl dist run "$@"; }													# run DIST
wsld() { wsl shutdown; }															# shutdown WSL
alias wslt=wsld																				# terminate WSL
wslr() { wsl dist restore "$@" && wsl install "$1"; } # reset DIST SRC

# test2 distribution
# wslTestDist="test2"
# wt() { wsl dist run "$wslTestDist" "$@"; } 										# run test distribution
# wtr() { wslr "$wslTestDist" ubuntu-focal --no-prompt "$@"; } 	# reset test distribution
# wti() { wsl install "$wslTestDist" "$@"; } 										# install test distribution
