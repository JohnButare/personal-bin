
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
wsld="$DATA/appdataw/wsl" # dir

wsld() { wsl.exe --shutdown; }

wn() { echo "$(wsl name) (WSL $WSL)"; } 							# name of current distribution
wv() { echo "WSL $(wsl version)" | figlet | lolcat; } # version of current distribution
w1() { wsl run1; }																		# run the first WSL 1 distribution
w2() { wsl run2; }																		# run the first WSL 2 distribution

wsldown() { sync; wsl.exe --shutdown; } # shutdown all distributions, sync prevents file corruption, ~/.zsh_history is likely to corrupt
wslimage() { i info >& /dev/null; "$INSTALL_DIR/LINUX/wsl/image/ubuntu"; } # image directory
wslr() { wsl delete "$1" "$@"; wsl restore "$1" "$2" "${3:-2}"; wsl init "$1"; } # reset DIST SRC

# test1 distribution
wslTestDist="test1"
wtinit() { wt2 --no-prompt; }
wt1() { wslr $wslTestDist ubuntu-bionic 1 "$@"; } # reset test distribution to Ubuntu-Bionic (18.04) WSL 1 image
wt2() { wslr $wslTestDist ubuntu-focal 2 "$@"; } 	# reset test distribution to Ubuntu-Focal (20.04) WSL 2 image
wtb() { wsl init $wslTestDist "$@"; } 						# initialize test distribution by running bootstrap-init
wt() { wsl run test1 "$@"; } 											# run test distruvtion
