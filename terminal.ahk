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

TerminatorInit()
{
	global

	TerminalProcess := "wscript.exe"
	TerminalArgs := "c:\Users\Public\Documents\data\platform\win\terminator.vbs"

	TerminalProcess := "Terminal.exe"
	TerminalTitle := "terminal "
	TerminalClass := "terminator.Terminator"
}

TerminatorOpen()
{
	global

	if WinExist(TerminalTitle)
		TerminatorActivate()
	else
		TerminatorNew()
}

TerminatorNew()
{
	global
	run TerminalProcess " " TerminalArgs, , Normal, pid
}

TerminatorActivate()
{
	global

	; Assumes terminal starts with TerminalTitle, which depends on shell configuration 
	; and is not the case a command is running.
	if TopActive(TerminalTitle)
		return

	run "cmdow.exe terminal* /res /act", , "Hide"

	; Uses the X window class but is slower
	;run "wsl.exe /usr/local/data/bin/RunScript -x WinSetState " TerminalClass " -a", , "Hide"
}