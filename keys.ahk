; +=Shift ^=Control #=Win !=Alt

; Initialize
#SingleInstance force
#NoEnv

Init()
CommonInit()
BrowserInit()
OfficeInit()
BashInit()

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
	DEFAULT_BROWSER=chrome
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

; Mouse
WheelLeft::Send ^#{Right}
WheelRight::Send ^#{Left}

; Win
#1::WinClose A ; Close active window
#2::WinMinimize A ; Close active window
^#3::NewElevatedBash()
#3::OpenBash()
#!3::NewBash()
#+3::NewBash()

; +=Shift ^=Control #=Win !=Alt
#a::OpenBrowser()
#!a::WinActivate Antidote
#!g::WinActivate .*Git Extensions
^#h::reload ; Reload AutoHotKeys
#i::OpenIe()
#!i::NewIe()
#j::run eclipse.btm,,min
#n::RunOneNote()
^#m::RunTidal()
^#n::NewFolder()
#o::RunOutlook()
#!p::run "procexp.exe"
#!q::run "%bash%" quicken start,,min
#!s::WinActivate .*Microsoft SQL Server Management Studio
^#t::RunTidal()
#t::OpenTextEditor()
#!t::OpenTextEditor()
#v::WinActivate .* Microsoft Visual Studio
#!v::WinActivate .* ASG-Remote Desktop 2012
#!w::RunWord()
#!y::OpenRecycleBin()
#z::OpenIm()
; +=Shift ^=Control #=Win !=Alt
