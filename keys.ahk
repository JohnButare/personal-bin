; +=Shift ^=Control #=Win !=Alt

; Initialize
#SingleInstance force
#NoEnv

CommonInit()
;TimerInit()
OfficeInit()
BashInit()
TakeCommandInit()

Init()

#Include common.ahk
#Include browser.ahk
#Include display.ahk
#Include office.ahk
#Include phone.ahk
#Include music.ahk
; #Include timer.ahk
#Include bash.ahk
#Include TakeCommand.ahk
#Include VMware.ahk

Test()
{
	global
	EnvGet test, timerest
	MsgBox test=%test% PROGRAMS64=%PROGRAMS64%
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

; Numeric Keypad
^Numpad4::MusicPreviousTrack()
^Numpad5::MusicPlayPause()
^Numpad6::MusicNextTrack()
^Numpad7::MusicEqualizer()
^Numpad9::MusicOther()

;!Numpad0::PhoneActivate() 
;!NumpadDot::PhoneHeadset() 
;!NumpadSub::PhoneMute()
;!NumpadAdd::PhoneHangup()

!Numpad1::PhoneDefaultSpeakers()
!Numpad2::PhoneDefaultPhone()
;!Numpad3::PhoneSpeed(3)
;!Numpad4::PhoneSpeed(4)
;!Numpad5::PhoneSpeed(5)
;!Numpad6::PhoneSpeed(6)

; Win
#1::WinClose A ; Close active window
#2::WinMinimize A ; Close active window
^#3::NewElevatedBash()
#3::OpenBash()
#!3::NewBash()
#6::NewPowerShell()
#!6::NewTakeCommandPowerShell()

; +=Shift ^=Control #=Win !=Alt
#a::OpenChrome()
#!a::OpenChrome()
; +=Shift ^=Control #=Win !=Alt
#b::Bridge()
^#b::ClipBridge()
+#b::PersonalBridge()
^#h::reload ; Reload AutoHotKeys
#!h::reload ; Reload AutoHotKeys
^#i::run "%PROGRAMS64%\Internet Explorer\iexplore.exe" ; x64
#!i::run "%PROGRAMS32%\Internet Explorer\iexplore.exe" ; x86
#j::run eclipse.btm,,min
#m::run "%tcc%" /c os.btm MobilityCenter,min
#!m::RunWindowsMediaPlayer()
#!n::RunOneNote()
#n::OpenEverNote()
^#n::NewFolder()
#o::RunOutlook()
#!p::run "procexp.exe"
#!q::run quicken.btm,,min
+#s::PowerDownMonitor()
^#s::run "%tcc%" /c power.btm sleep force,,min
#!s::RunSonos()
^#t::Test()
#t::OpenTextEditor()
#!t::RuniTunes()
^#v::run "%tcc%" /c VisualStudio.btm start new,,min
#v::run VisualStudio.btm,,min
#!v::OpenVmWare()
^#w::NewWordDocument()
#!w::NewWordDocument()
#x::OpenIm()
#!x::OpenFirefox()
#!y::OpenRecycleBin()

