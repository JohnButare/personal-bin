# applications
alias autoruns='start autoruns.exe'
alias ahk='AutoHotkey'
alias ahkr='ahk restart'
alias AutoItDoc="start $pdata/doc/AutoIt.chm"
alias ie='InternetExplorer'
alias npp='notepadpp start'
alias powershell="$WINDIR/system32/WindowsPowerShell/v1.0/powershell.exe"
alias rdesk='cygstart mstsc /f /v:'
alias wmic="$WINDIR/system32/wbem/WMIC.exe"

# network
alias NetConfig='control netconnections'
alias NetStatus='ipconfig /all'

nu() { net use "$(ptw "$1")" "${@:2}"; } # NetUse

# operating system
alias apps='explorer shell:AppsFolder'
alias cm='start CompMgmt.msc'
alias credm='start control /name Microsoft.CredentialManager'
alias dm='start DevMgmt.msc'
alias ev='start eventvwr.msc'
alias prog='product gui'
alias prop='os SystemProperties'
alias SystemRestore='vss'
alias WindowSpy="start Au3Info.exe"

# VBA
alias ws='wscript /nologo'
alias cs='cscript /nologo'

# utilities
alias ffw='elevate powershell FlipFlopWheel.ps1'
alias wln='start --direct "$BIN/win/ln.exe"' # Windows ln
alias wh="$WIN_HOME"

z7bak() { [[ $# == 1  ]] && 7z a -m1=LZMA2 "$1.7z" "$1" || 7z a -m1=LZMA2 "$1" "${@:2}"; }

# wsl	
wslv() { cb; echo "WSL $(IsWsl2 && echo 2 || echo 1)" | figlet | lolcat; } 					# WSL version
wsll() { wsl.exe --list $(IsWsl2 && echo --verbose || echo ""); }; alias wl='wsll'; # list
wsllr() { wsl.exe --list --running;} 																								# list running
wsls() { wslm summary -n "$1"; } 																										# summary
wsldir() { [[ ! -d "$UDATA/wsl/$1" ]] && { md --parents "$UDATA/wsl/$1" || return; }; echo "$(utw "$(GetFullPath "$UDATA/wsl/$1")")"; }	# directory DIST

wslm() { LxRunOffline "$@"; }; alias wm='wslm'; 	# manage
wslr() { wslm r -n "$@"; }; alias wr='wslr'; 			# run
wslt() { wsl.exe --terminate "$@"; } 							# terminate

wsldel() { ask "Delete the $1 distribution" && wslm uninstall -n "$1"; }; # delete name
wsldup() { wslm duplicate -n "$1" -N "$2" -d "$(wsldir "$2")" || wslm unregister -n "$2" ; }; # duplicate SRC DEST
wsli() { local i="$(i dir)" name="$1"; local distro="${2-$name}" version="${3:-default}"; wslm install -n "$name" -d "$(wsldir "$name")" -f "$(utw "$i/LINUX/wsl/$distro/$version.tar.gz")" || wslm unregister -n "$name"; } # install name [distro]) ([version](default)
wslup() { wsl.exe --set-version "$1" 2; } # upgrade to WSL 2, wslup name