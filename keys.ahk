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

^Numpad8::SoundSet +5
^Numpad2::SoundSet -5
^Numpad0::SoundSet +1, , mute

; Win
#1::WinClose A ; Close active window
#2::WinMinimize A ; Close active window
^#3::NewElevatedBash()
#3::OpenBash()
#!3::NewBash()

; +=Shift ^=Control #=Win !=Alt
#a::OpenBrowser()
#!a::NewBrowser()
^#h::reload ; Reload AutoHotKeys
#i::OpenIe()
#!i::NewIe()
#j::run eclipse.btm,,min
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

