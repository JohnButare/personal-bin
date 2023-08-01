TextEditorInit()
{
	global

	NotepadPp := PROGRAMS64 "\Notepad++\notepad++.exe"
	NotepadPpTitle := ".* - Notepad++"

	Sublime := PROGRAMS64 "\Sublime Text\sublime_text.exe"
	SublimeUser := UADATA "\Sublime Text\sublime_text.exe"
	SublimeTitle := ".* - Sublime Text"

	if FileExist(Sublime)
	{
		TextEditor := Sublime
		TextEditorTitle := SublimeTitle
	}
	else if FileExist(SublimeUser)
	{
		TextEditor := SublimeUser
		TextEditorTitle := SublimeTitle
	}
	else if FileExist(NotepadPp)
	{
		TextEditor := NotepadPp
		TextEditorTitle := NotepadPpTitle
	}
	else
		TextEditor := "NotePad"
}

OpenTextEditor()
{
	global 

	If WinExist(TextEditorTitle)
	{
		WinRestore TextEditorTitle
		WinActivate TextEditorTitle
	}
	else
		run TextEditor
}

NewTextEditor()
{
	global

	run "`"" TextEditor "`" -n"
}

OpenNotepadPp()
{
	global

	If WinExist(NotepadPpTitle)
		WinActivate NotepadPpTitle
	else
		run NotepadPp
}
