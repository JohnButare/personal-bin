BrowserInit()
{
  global

  chrome := PROGRAMS32 "\Google\Chrome\Application\chrome.exe"
  edge := "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe"
  firefox := PROGRAMS64 "\Mozilla Firefox\firefox.exe"
  ie := PROGRAMS32 "\Internet Explorer\iexplore.exe"
	
  if FileExist(chrome)
  	browser := "Chrome"
  else if FileExist(firefox)
    browser := "Firefox"
	else if FileExist(edge)
		browser := "Edge"
	else
		browser := "Ie"

  if (DEFAULT_BROWSER = "chrome" && FileExist(chrome))
    browser := "Chrome"

  if (DEFAULT_BROWSER = "firefox" && FileExist(firefox))
    browser := "Firefox"

  if (DEFAULT_BROWSER = "edge" && FileExist(edge))
    browser := "Edge"

  if (DEFAULT_BROWSER = "ie" && FileExist(ie))
    browser := "Ie"

  ;MsgBox browser
}

NewBrowser()
{
	global
  New%browser%()
}

OpenBrowser()
{
	global
  Open%browser%() 
}

NewChrome()
{
  global chrome

  ;run chrome, , Normal, pid
  ;WinWait "ahk_pid " pid
  ;WinActivate "ahk_pid " pid
}

OpenChrome()
{
  ChromeClass := "chrome.exe"
  
  WinActivate "ahk_exe " ChromeClass

  If WinExist("ahk_exe " ChromeClass)
    return    

  NewChrome()
}

NewEdge()
{
  global
  run "shell:AppsFolder\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge"
}

OpenEdge()
{
  NewEdge()
}

NewFirefox()
{
  global firefox
  KeyWait "Shift" ; wait for shift to be released to avoid safe mode
  ;run firefox " -ProfileManager", "C:\Program Files\Mozilla Firefox\"
  run firefox, "C:\Program Files\Mozilla Firefox\"
}

OpenFirefox()
{ 
  local title := ".* Mozilla Firefox"
  local titleCmdow := "* Mozilla Firefox"

  If !WinExist("ahk_exe" " firefox.exe")
  {
    NewFirefox()
    return
  }

  if TopActive(title)
    return

  ;WinActivate "ahk_exe" " firefox.exe" 
  ;WinRestore title 
  ;run 'cmdow.exe "' titleCmdow '" /res /act', "C:\Users\Public\Documents\data\platform\win\", "Hide" 
  ;run 'nircmd.exe win normal ititle "- Mozilla Firefox"', "C:\Users\Public\Documents\data\platform\win\", "Hide" 
  PostMessage 0x112, 0xF120,,, title  ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE 
}

NewIe()
{
  global
  run ie ; x86
}

OpenIe()
{ 
  WinActivate "ahk_class IEFrame"

  If WinExist("ahk_class IEFrame")
    return    

  NewIe()
}

