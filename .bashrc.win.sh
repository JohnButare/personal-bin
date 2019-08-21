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
wsll() { wsl.exe --list $(IsWsl2 && echo --verbose || echo "");} # WSL list
wslv() { cb; echo "WSL $(IsWsl2 && echo 2 || echo 1)" | figlet | lolcat; } # version
