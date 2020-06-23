
# applications
alias cmd="cmd.exe"
alias autoruns='start --elevate autoruns.exe'
alias wmic="$WINDIR/system32/wbem/WMIC.exe"
alias ahkr="ahk /restart \"$DOC/data/bin/keys.ahk\""  # AutoHotKey Restart

ahk() { start "$P/AutoHotkey/AutoHotkeyU64.exe" "$@"; } # AutoHotKey
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

wn() { echo "$(wsl name) (WSL $WSL)"; } 							# name of current distribution
wv() { echo "WSL $(wsl version)" | figlet | lolcat; } # version of current distribution
w2() { wsl run2; }																		# run the first WSL 2 distribution

wsldown() { wsl.exe --shutdown; } # shutdown all distributions
wslimage() { i info >& /dev/null; "$INSTALL_DIR/LINUX/wsl/image/ubuntu"; } # image directory
wslr() { wsl delete "$1" "$@"; wsl restore "$1" "$2" "${3:-2}"; wsl init "$1"; } # reset DIST SRC

# test1 distribution
wslTestDist="test1"
wt() { wt2 --no-prompt; }
wt1() { wslr $wslTestDist ubuntu-bionic 1 "$@"; } # reset test distribution to Ubuntu-Bionic (18.04) WSL 1 image
wt2() { wslr $wslTestDist ubuntu-focal 2 "$@"; } 	# reset test distribution to Ubuntu-Focal (20.04) WSL 2 image
wi() { wsl init $wslTestDist "$@"; } 							# initialize test distribution by running bootstrap-init
wr() { wsl run test1 "$@"; } 											# run test distruvtion
