NoteEditorInit()
{
	global

	Notion := UADATA "\Programs\Notion\Notion.exe"	
	StandardNotes := UADATA "\Programs\standard-notes\Standard Notes.exe"

	ObsidianTitle := ".* - Obsidian v.*"
	if FileExist(PROGRAMS64 "\Obsidian\Obsidian.exe")
    Obsidian := PROGRAMS64 "\Obsidian\Obsidian.exe"
  else
    Obsidian := UADATA "\Programs\obsidian\Obsidian.exe"

	NoteEditorTitle := ""
	NoteEditor := ""

	if FileExist(Obsidian)
	{
		NoteEditor := Obsidian
		NoteEditorTitle := ObsidianTitle
	}
	else if FileExist(Notion)
	{
		NoteEditor := Notion
		NoteEditorTitle := NoteEditorTitle
	}
}

OpenNoteEditor()
{
	global 

	If WinExist(NoteEditorTitle)
	{
		;WinRestore NoteEditorTitle
		WinActivate NoteEditorTitle
	}
	else
		run NoteEditor
}
