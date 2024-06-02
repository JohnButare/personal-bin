#SingleInstance force

Init()
CommonInit()
GitInit()
OfficeInit()
BrowserInit()
MailInit()
NoteEditorInit()
TerminalInit()
TextEditorInit()
VmInit()
WindowInit()

#Include common.ahk

#Include apps.ahk
#Include browser.ahk
#Include git.ahk
#Include mail.ahk
#Include NoteEditor.ahk
#Include office.ahk
#Include terminal.ahk
#Include TextEditor.ahk
#Include windows.ahk
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
RShift & r::reload 										; Reload AutoHotKey
#NumpadAdd::reload										; Reload AutoHotKeys - hides magnifier shortcut keyR

;
; Windows
;

LWin & NumpadClear::CenterWindow()
RShift & q::CenterWindow()
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

;RShift & e::run "explorer.exe  %HOMEDRIVE%%HOMEPATH%"	; Explorer
RShift & e::OpenExplorer()			; Explorer(e)
RShift & 1::Open1Password() 		; 1Password(1)
RShift & 3::OpenTerminal() 			; Terminal(3)
RShift & b::OpenBrowser() 			; Browser(b)
RShift & a::OpenTeams() 				; CollAboration(a)
RShift & g::Opengit()						; Git(g)
RShift & m::OpenMail()					; Mail(m)
RShift & n::OpenNoteEditor()		; Note Editor(n)
RShift & t::OpenTextEditor()		; Text Editor(t)
RShift & w::RunWord()						; word(w)
#=::^=													; map cmd= (magnifier shortcut) to ctrl= (text size increase)
#-::^-												  ; map cmd- to ctrl- (text size decrease)
;RShift & v::OpenVm()

; coding
RShift & v::OpenVisualStudioCode()
; RShift & v::OpenVisualStudio()
RShift & s::OpenSqlServerManagementStudio()

; DriveTime
RShift & l::OpenSlack()
