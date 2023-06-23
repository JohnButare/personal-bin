NoteEditorInit()
{
	global

	Notion := LOCALAPPDATA "\Programs\Notion\Notion.exe"	
	Obsidian := LOCALAPPDATA "\obsidian\Obsidian.exe"
	ObsidianTitle := ".* - Obsidian v.*"
	StandardNotes := LOCALAPPDATA "\Programs\standard-notes\Standard Notes.exe"

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
