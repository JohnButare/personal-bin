; +=Shift ^=Control #=Win !=Alt

; Initialize
#SingleInstance force

Init()
CommonInit()
BashInit()
BrowserInit()
OfficeInit()
VmInit()

#Include C:\Users\Public\Documents\data\platform\win
#Include common.ahk

#Include bash.ahk
#Include browser.ahk
#Include mail.ahk

#Include office.ahk
#Include vm.ahk

Test()
{
	test := EnvGet("TEST")
	MsgBox "TEST=" TEST
}

Init()
{
  global

  DEFAULT_BROWSER := "firefox"
	DEFAULT_VM := "vmware"
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
#n::OpenNotion()
+#n::OpenStandardNotes()
^#n::NewFolder()
#o::OpenMail()
#!q::run bash " quicken start",,min
#!s::WinActivate ".*Microsoft SQL Server Management Studio"
#t::OpenTextEditor()
#!t::OpenNotepadPp()
^#t::OpenNotepadPp()
#v::OpenVm()
#!v::WinActivate ".* ASG-Remote Desktop 2012"
#w::RunWord()
#!w::RunWord()
#!y::OpenRecycleBin()
; +=Shift ^=Control #=Win !=Alt
