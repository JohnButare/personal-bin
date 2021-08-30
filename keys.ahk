#SingleInstance force

Init()
CommonInit()
OfficeInit()
BrowserInit()
MailInit()
TerminalInit()
TextEditorInit()
VmInit()

#Include common.ahk

#Include browser.ahk
#Include mail.ahk
#Include office.ahk
#Include terminal.ahk
#Include TextEditor.ahk
#Include vm.ahk

Test()
{
	MsgBox "test"
}

Init()
{
  global
  DEFAULT_BROWSER := "firefox"
	DEFAULT_VM := "vmware"
}  

; +=Shift ^=Control #=Win !=Alt

^#t::Test()														; test
LWin & Space::Send "^{Esc}"						; Start Menu (search)
#1::WinClose "A" 											; close the active window
#2::WinMoveBottom "A" 								; move the active window to the back
^#r::reload 													; Reload AutoHotKeys

;
; Windows
;

RWin & q::Send "#{Numpad7}"
RWin & w::Send "#{Numpad8}"
RWin & e::Send "#{Numpad9}"
RWin & a::Send "#{Numpad4}"
RWin & s::Send "#{Numpad5}"
RWin & d::Send "#{Numpad6}"
RWin & z::Send "#{Numpad1}"
RWin & x::Send "#{Numpad2}"
RWin & c::Send "#{Numpad3}"

;
; Applications
;

RShift & 3::OpenTerminal() 			; Terminal
RShift & b::OpenBrowser() 			; Browser
RShift & g::WinActivate "Fork"  ; Git
RShift & m::OpenThunderbird()		; Mail
RShift & n::OpenNotion()				; Notes
RShift & t::OpenTextEditor()		; Text Editor
RShift & v::OpenVm()						; Virtual Machine
RShift & w::RunWord()						; word
