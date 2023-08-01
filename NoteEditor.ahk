NoteEditorInit()
{
	global

	Notion := UADATA "\Programs\Notion\Notion.exe"	
	Obsidian := UADATA "\obsidian\Obsidian.exe"
	ObsidianTitle := ".* - Obsidian v.*"
	StandardNotes := UADATA "\Programs\standard-notes\Standard Notes.exe"

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
		WinRestore NoteEditorTitle
		WinActivate NoteEditorTitle
	}
	else
		run NoteEditor
}
