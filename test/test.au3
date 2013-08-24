Opt("WinTitleMatchMode", 3)
If $CmdLine[0] == 2 Then
	exit WinSetState("[REGEXPCLASS:\A" & $CmdLine[2] & "\z]", $CmdLine[3])
ElseIf $CmdLine[0] == 1 Then
	exit WinSetState("[REGEXPTITLE:\A" & $CmdLine[1] & "\z]", $CmdLine[2])
Else
	ConsoleWriteError("usage: WinSetState [class] <title|class> <flag>" & @CRLF)
	ConsoleWriteError(@SW_HIDE & " = Hide window" & @CRLF)
	ConsoleWriteError(@SW_SHOW & " = Shows a previously hidden window" & @CRLF)
	ConsoleWriteError(@SW_MINIMIZE & " = Minimize window" & @CRLF)
	ConsoleWriteError(@SW_MAXIMIZE & " = Maximize window" & @CRLF)
	ConsoleWriteError(@SW_RESTORE & " = Undoes a window minimization or maximization" & @CRLF)
	ConsoleWriteError(@SW_DISABLE & " = Disables the window" & @CRLF)
	ConsoleWriteError(@SW_ENABLE & " = Enables the window" & @CRLF)
	exit 1
EndIf