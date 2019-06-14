; +=Shift ^=Control #=Win !=Alt

; Initialize
#SingleInstance force

Init()
CommonInit()
BrowserInit()
BashInit()

OfficeInit()
ImInit()
MailInit()

#Include C:\Users\Public\Documents\data\platform\win
#Include common.ahk
#Include browser.ahk
#Include display.ahk
#Include music.ahk
#Include bash.ahk

#Include office.ahk
#Include im.ahk
#Include mail.ahk

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

  DEFAULT_BROWSER := "chrome"
  if (EnvGet("USERDOMAIN") = "AMR")
		DEFAULT_BROWSER := "chrome"
}  

#Enter::send "{Enter}" ; disable Narrator

; Numeric Keypad
;^Numpad4::MusicPreviousTrack()
;^Numpad5::MusicPlayPause()
;^Numpad6::MusicNextTrack()
;^Numpad7::MusicEqualizer()
;^Numpad9::MusicOther()

;^Numpad8::SoundSet +5
;^Numpad2::SoundSet -5
;^Numpad0::SoundSet +1, , mute

; Mouse
;WheelLeft::Send "^#{Right}"
;WheelRight::Send "^#{Left}"

; Win
#1::WinClose "A" ; Close active window
#2::WinMinimize "A" ; Close active window
^#3::NewElevatedBash()
#3::OpenBash()
#!3::NewBash()
#+3::NewBash()

; +=Shift ^=Control #=Win !=Alt
#a::OpenBrowser()
#b::OpenThunderbird()
#c::WinActivate ".*Visual Studio" ; code
#!a::WinActivate Antidote
#!g::WinActivate ".*Git Extensions"
^#h::reload ; Reload AutoHotKeys
#i::OpenIe()
#!i::NewIe()
#j::run eclipse.btm,,min
#n::OpenStandardNotes()
+#n::RunOneNote()
^#m::RunTidal()
^#n::NewFolder()
#o::OpenMail()
#!p::run "procexp.exe"
#!q::run bash " quicken start",,min
#!s::WinActivate ".*Microsoft SQL Server Management Studio"
#t::OpenTextEditor()
#!t::OpenNotepadPp()
^#t::OpenNotepadPp()
#v::WinActivate ".*VMware Workstation"
#!v::WinActivate ".* ASG-Remote Desktop 2012"
#w::RunWord()
#!w::RunWord()
#!y::OpenRecycleBin()
#z::OpenIm()
; +=Shift ^=Control #=Win !=Alt
