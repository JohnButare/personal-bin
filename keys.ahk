; +=Shift ^=Control #=Win !=Alt

; Initialize
#SingleInstance force
#NoEnv

CommonInit()
BrowserInit()
OfficeInit()
BashInit()

Init()

#Include common.ahk
#Include browser.ahk
#Include display.ahk
#Include office.ahk
#Include music.ahk
#Include bash.ahk
#Include VMware.ahk

Test()
{
	;global
	;EnvGet test, timerest
	;MsgBox test=%test% PROGRAMS64=%PROGRAMS64%
	run notepad.exe
}

Init()
{
  global
	StringCaseSense, Off		
	IdleMinutes = 15
}  

IdleEvent()
{
	;run SleepTaskSleep.btm,,min
}

#Enter::send {Enter} ; disable Narrator

; Numeric Keypad
^Numpad4::MusicPreviousTrack()
^Numpad5::MusicPlayPause()
^Numpad6::MusicNextTrack()
^Numpad7::MusicEqualizer()
^Numpad9::MusicOther()
; Win
#1::WinClose A ; Close active window
#2::WinMinimize A ; Close active window
^#3::NewElevatedBash()
#3::OpenBash()
#!3::NewBash()

; +=Shift ^=Control #=Win !=Alt
#a::OpenChrome()
#!a::NewChrome()
; +=Shift ^=Control #=Win !=Alt
^#h::reload ; Reload AutoHotKeys
#!h::reload ; Reload AutoHotKeys
^#i::run "%PROGRAMS64%\Internet Explorer\iexplore.exe" ; x64
#!i::run "%PROGRAMS32%\Internet Explorer\iexplore.exe" ; x86
#j::run eclipse.btm,,min
#m::run "mblctr.exe"
#!m::RunWindowsMediaPlayer()
#!n::RunOneNote()
#n::OpenEverNote()
^#n::NewFolder()
#o::RunOutlook()
#!p::run "procexp.exe"
#!q::run "%bash%" quicken start,,min
+#s::PowerDownMonitor()
+#^s::run "%bash%" %BashArgs% power sleep,,min
#!s::RunSonos()
^#t::Test()
#t::OpenTextEditor()
#!t::NewTextEditor()
^#v::run "%bash%" VisualStudio start new,,min
#v::run "%bash%" VisualStudio start,,min
#!v::OpenVmWare()
^#w::NewWordDocument()
#!w::NewWordDocument()
#!x::OpenFirefox()
#!y::OpenRecycleBin()
#z::OpenIm()
