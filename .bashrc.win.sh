# applications
alias autoruns='start --elevate autoruns.exe'
alias ahk='AutoHotkey'
alias ahkr='ahk restart'
alias hv='hyperv'
alias ie='InternetExplorer'
alias npp='notepadpp start'
alias powershell="$WINDIR/system32/WindowsPowerShell/v1.0/powershell.exe"
alias wmic="$WINDIR/system32/wbem/WMIC.exe"

rdesk()
{ 
	( mstsc.exe '/f' '/v:'"${@}" & )
}

# loctions
alias wh="$WIN_HOME"
alias wr="$WIN_ROOT"

# monitor
alias monden='monprofile den'
alias monstudy='monprofile study'

alias moninfo='cs $win/UltraMon.js info'
monprofile() { start "$cloud/data/UltraMon/$1.umprofile"; }

# network
alias NetConfig='control.exe netconnections'
alias NetStatus='ipconfig /all'

nu() { net use "$(ptw "$1")" "${@:2}"; } # NetUse

# operating system
alias apps='explorer shell:AppsFolder'
alias cm='start CompMgmt.msc'
alias credm='start control /name Microsoft.CredentialManager'
alias dm='start DevMgmt.msc'
alias ev='start eventvwr.msc'
alias ipconfig='ipconfig.exe'
alias logoff='IsSsh && exit || logoff.exe'
alias pfs='power fix sleep'
alias pfw='power fix wake'
alias prog='product gui'
alias prop='os SystemProperties'
alias SystemRestore='vss'
alias WindowSpy="start Au3Info.exe"

# VBA
alias ws='start wscript.exe /nologo'
alias cs='start cscript.exe /nologo'

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

wslm() { LxRunOffline.exe "$@"; }; alias wm='wslm'; 	# manage
wslr() { wslm r -n "$@"; }									 			# run
wslt() { wsl.exe --terminate "$@"; } 							# terminate

wsldel() { ask "Delete the $1 distribution" && wslm uninstall -n "$1"; }; # delete name
wsldup() { wslm duplicate -n "$1" -N "$2" -d "$(wsldir "$2")" || wslm unregister -n "$2" ; }; # duplicate SRC DEST
wslup() { wsl.exe --set-version "$1" 2; } # upgrade to WSL 2, wslup name

wsli() # install name [distro]) ([version](default)
{
	local i="$(i dir)" name="$1"
	local distro="${2-$name}" version="${3:-default}"

	wslm install -n "$name" -d "$(wsldir "$name")" -f "$(utw "$i/LINUX/wsl/image/$distro/$version.tar.gz")" || wslm unregister -n "$name"
}
