#SingleInstance force

Init()
CommonInit()
GitInit()
OfficeInit()
BrowserInit()
MailInit()
TerminalInit()
TextEditorInit()
VmInit()

#Include common.ahk

#Include apps.ahk
#Include browser.ahk
#Include git.ahk
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

; +=Shift ^=Control #=Command !=Alt

^#t::Test()														; test
LWin & Space::Send "^{Esc}"						; Start Menu (search)
#1::WinClose "A" 											; close the active window
;#2::WinMoveBottom "A" 								; move the active window to the back
#2::WinMinimize "A"
#3::WinMaximize "A"
^#a::reload 													; Reload AutoHotKeys

;
; Windows
;

LWin & NumpadClear::Send "+^#z"
;RWin & q::Send "#{Numpad7}"
;RWin & w::Send "#{Numpad8}"
;RWin & e::Send "#{Numpad9}"-
;RWin & a::Send "#{Numpad4}"
;RWin & s::Send "#{Numpad5}"
;RWin & d::Send "#{Numpad6}"
;RWin & z::Send "#{Numpad1}"
;RWin & x::Send "#{Numpad2}"
;RWin & c::Send "#{Numpad3}"

;
; Applications
;

RShift & 1::Open1Password() 		; 1Password
RShift & 3::OpenTerminal() 			; Terminal
RShift & b::OpenBrowser() 			; Browser
RShift & g::Opengit()					; Git
RShift & m::OpenMail()					; Mail
RShift & n::OpenNotion()				; Notes
RShift & t::OpenTextEditor()		; Text Editor
RShift & w::RunWord()						; word
#=::^=													; map cmd= (magnifier shortkcut) to ctrl= (text size increase)
#-::^-												  ; map cmd- to ctrl- (text size decrease)
;RShift & v::OpenVm()

; coding
RShift & v::OpenVisualStudio()
RShift & s::OpenSqlServerManagementStudio()

; DriveTime
RShift & l::OpenSlack()
