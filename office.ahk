OfficeInit()
{
  global
     
  if FileExist(PROGRAMS64 "\Microsoft Office\root\office16\WinWord.EXE")
    Office := PROGRAMS64 "\Microsoft Office\root\office16"

  else if FileExist(PROGRAMS32 "\Microsoft Office\root\office16\WinWord.EXE")
    Office := PROGRAMS32 "\Microsoft Office\root\office16"
	  
  if (Office == "") 
    return

  word := Office "\WinWord.exe"
  WordTitle := ".* - Word"

  outlook := Office "\Outlook.exe"
	OneNote := Office "\OneNote.exe"
}  
  
NewWord()
{
  global
  run word
}

; Create a new word document in the active folder or opens a blank word document
; Requires that the only item in the right context new menu that starts with W is Word
NewWordDocument()
{
	if IsExplorerActive()
		send "+{F10}{up}{up}{right}W{enter}"
	else
		NewWord()
}

RunOneNote()
{
	global
	
	if WinExist(".* OneNote")
		WinActivate ".* OneNote"
	else
		run OneNote
}

RunOutlook()
{
  global
	
	if WinExist(".* Outlook")
		WinActivate ".* Outlook"
	else
		run "`"" outlook "`" /recycle"
}

RunWord()
{
  global

  if WinExist(WordTitle)
  {
  	WinMoveTop(WordTitle)
    WinActivate(WordTitle)
  }
  else
    run word
}
