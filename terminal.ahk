TerminalInit()
{
	global

	SHELL := EnvGet("SHELL")
	
	; if AutoHotkey was not started from a Terminal process, start it as a login shell
	;if (SHELL != "/bin/Terminal")
	;	TerminalArgs := "-"

	terminal := "WindowsTerminal"
	;terminal := "Terminator"

	%terminal%Init() 
}

OpenTerminal()
{
	global
	%terminal%Open() 
}

;
; Windows Terminal
;

WindowsTerminalInit()
{
	global 

	WindowsTerminal := "wt.exe"
	WindowsTerminalProcess := "WindowsTerminal.exe"
	WindowsTerminalClass := "CASCADIA_HOSTING_WINDOW_CLASS"
}

WindowsTerminalOpen()
{
	global

  If WinExist("ahk_class " WindowsTerminalClass)
  {
  	WinActivate "ahk_class " WindowsTerminalClass
    return    
  }

  TerminalNew()
}

TerminalNew()
{
	global
	wt := UADATA "\Windows Terminal\wt.exe"
  if not FileExist(wt)
  	wt := PROGRAMS64 "\Windows Terminal\wt.exe"

  run wt
}

;
; Terminator
;

TerminatorInit()
{
	global

	TerminatorProcess := "wscript.exe c:\ProgramData\terminator\terminator.vbs"

	TerminatorTitle := "terminal* ahk_class X410_XAppWin"
	TerminatorClass := "terminator.Terminator"
}

TerminatorOpen()
{
	global

	if WinExist(TerminatorTitle)
		TerminatorActivate()
	else
		TerminatorNew()
}

TerminatorNew()
{
	global
	run TerminatorProcess
}

TerminatorActivate()
{
	global
	WinActivate TerminatorTitle
	WinSetAlwaysOnTop 1, TerminatorTitle
	WinSetAlwaysOnTop 0, TerminatorTitle
}