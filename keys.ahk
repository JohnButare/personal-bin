#SingleInstance force

Init()
CommonInit()
OfficeInit()
BrowserInit()
MailInit()
TerminalInit()
TextEditorInit()
VmInit()

#Include C:\Users\Public\Documents\data\platform\win
#Include common.ahk
#Include ToggleTaskBar.ahk

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
#!d::ToggleTaskBar										; show/hide Launcher (taskbar/dock)
#1::WinClose "A" 											; close the active window
#2::WinMoveBottom "A" 								; move the active window to the back

#3::OpenTerminal()										; terminal
#b::OpenBrowser()											; browser
#g::WinActivate "Fork" 								; git
#m::OpenThunderbird() 								; mail
#n::OpenNotion() 											; notes
#t::OpenTextEditor()									; text editor
#v::OpenVm()													; virtual machine
#w::RunWord()													; word

