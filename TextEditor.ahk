TextEditorInit()
{
	global

	NotepadPp := PROGRAMS64 "\Notepad++\notepad++.exe"
	NotepadPpTitle := ".* - Notepad++"

	Sublime := PROGRAMS64 "\Sublime Text 3\sublime_text.exe"
	SublimeTitle := ".* - Sublime Text"
	
	if FileExist(Sublime)
	{
		TextEditor := Sublime
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

OpenNotion()
{ 
  global

  WinActivate "ahk_exe " "Notion.exe"

  If WinExist("ahk_exe " "Notion.exe")
    return    

  run LOCALAPPDATA "\Programs\Notion\Notion.exe"
}

OpenStandardNotes()
{ 
  global

  WinActivate "ahk_exe " "Standard Notes.exe"

  If WinExist("ahk_exe " "Standard Notes.exe")
    return    

  run LOCALAPPDATA "\Programs\standard-notes\Standard Notes.exe"
}