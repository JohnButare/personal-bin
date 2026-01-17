ExplorerInit()
{
  global

  windowsExplorer := "explorer.exe"
  files := UADATA "\Microsoft\WindowsApps\files-stable.exe"
  filesBeta := UADATA "\Microsoft\WindowsApps\files-preview.exe"
	
  if FileExist(FilesBeta)
    explorer := "FilesBeta"
  else if FileExist(files)
    explorer := "Files"
	else
		explorer := "WindowsExplorer"
}

NewExplorer()
{
	global
  New%explorer%()
}

OpenExplorer()
{
	global
  Open%explorer%() 
}

NewWindowsExplorer()
{
	run  "explorer ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" ; This PC
	;run  "explorer " EnvGet("HOMEDRIVE") EnvGet("HOMEPATH")
}

OpenWindowsExplorer()
{
	If WinExist("ahk_class" "CabinetWClass")
    WinActivate "ahk_class" "CabinetWClass"
  else
    NewWindowsExplorer()
}

OpenFiles()
{
	global
  If WinExist("ahk_exe" "Files.exe")
    WinActivate "ahk_exe" "Files.exe"
  else
    NewFiles()
}

NewFiles()
{
	run files
}

OpenFilesBeta()
{
  If WinExist("ahk_exe" "Files.exe")
    WinActivate "ahk_exe" "Files.exe"
  else
    NewFilesBeta()
}

NewFilesBeta()
{
	global
	run filesBeta
}

;
; other
;

IsWindowsExplorerActive()
{
	if WinActive("ahk_class CabinetWClass")
		return 1
	return 0
}

; Requires that the only item in the right context new menu that starts with F is Folder
NewFolder()
{
  if IsWindowsExplorerActive()
		send "+{F10}{up}{up}{right}{enter}"
}
