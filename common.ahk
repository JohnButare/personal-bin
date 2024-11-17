CommonInit()
{
	global
  
	InitTitleMatchMode()
	
	; Set the working directory to c:\, otherwise programs are run from win32 directory 
	; even if they are in win64 directory on x64.
	SetWorkingDir "c:\"
	
	COMPUTERNAME := EnvGet("COMPUTERNAME")
	PUBLIC := "c:\Users\Public"
	PROGRAMS64 :="c:\Program Files"
	PROGRAMS32 :="c:\Program Files (x86)"
	UADATA := EnvGet("LOCALAPPDATA")
}

InitTitleMatchMode()
{
	SetTitleMatchMode "RegEx"
	SetTitleMatchMode "fast"
}

; TopActive(title) - if the window is not minimized move it to the top and make it active.
; Do not minimize windows as it causes issues:
; 1) X windows are maximized on restore and sometime X410 hange
; 2) Firefox becomes sluggish after a while
TopActive(title)
{
	if ! WinExist(title)
		return 0

	if WinGetMinMax(title) == -1
		return 0

	WinMoveTop(title)
	WinActivate(title)
	return 1
}

IsExplorerActive()
{
	; Is explorer active? - Window Spy shows ExploreWClass for Windows XP and CabinetWClass for Vista/Win7
  if WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
		return 1
	return 0
}

; Requires that the only item in the right context new menu that starts with F is Folder
NewFolder()
{
  if IsExplorerActive()
		send "+{F10}{up}{up}{right}{enter}"
}

OpenExplorer()
{
	run  "explorer ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" ; This PC
	;run  "explorer " EnvGet("HOMEDRIVE") EnvGet("HOMEPATH")
}

RunProcessExplorer()
{
	run "procexp.exe"
}

OpenRecycleBin()
{
	run "explorer ::{645FF040-5081-101B-9F08-00AA002F954E}"
}

OpenRemoteDesktop()
{
  If WinExist("ahk_exe " "RDCMan.exe")
    WinActivate "ahk_exe " "RDCMan.exe"
  else
		run PUBLIC "\data\appdata\win\RDCMan.exe"
}

WinVisible(Title)
{
  DetectHiddenWindows false ; Force to not detect hidden windows
  result := WinExist(Title) ; Return 0 for hidden windows or the ahk_id
  DetectHiddenWindows true ; Return to "normal" state
  return result
}
