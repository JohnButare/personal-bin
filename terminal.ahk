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

	WinActivate "ahk_class " WindowsTerminalClass

  If WinExist("ahk_class " WindowsTerminalClass)
    return    

  TerminalNew()
}

TerminalNew()
{
	global
  run WindowsTerminal
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

	; Assumes terminal starts with TerminatorTitle, which depends on shell configuration 
	; and is not the case a command is running.
	;if TopActive(TerminatorTitle)
	;	return

	;WinActivate TerminatorTitle

	; making it top most and not top most works in WSL 2
	WinActivate TerminatorTitle
	WinSetAlwaysOnTop 1, TerminatorTitle
	WinSetAlwaysOnTop 0, TerminatorTitle

	;run "cmdow.exe terminator* /res /top /not", , "Hide"

	; Uses the X window class but is slower
	;run "wsl.exe /usr/local/data/bin/RunScript -x WinSetState " TerminatorClass " -a", , "Hide"

	; manipulate the X Server
	;WinActivate "X410_XAppWin"
	;TopActive("X410_XAppWin")
}