MailInit()
{
  global

  live := PROGRAMS64 "\WindowsApps\microsoft.windowscommunicationsapps_16005.11425.20146.0_x64__8wekyb3d8bbwe\HxOutlook.exe"
  outlook := Office "\Outlook.exe"
  thunderbird := PROGRAMS64 "\Mozilla Thunderbird\thunderbird.exe"

  if FileExist(thunderbird)
    mail := "Thunderbird"
  else if FileExist(live)
  	mail := "Live"
	else if FileExist(outlook)
		mail := "Outlook"
}  
  
OpenMail()
{
  global

  if mail != ""
    Open%mail%() 
}

OpenLive()
{
  if WinExist(".* - Mail")
    WinActivate(".* - Mail")
  ;else
  ;  run explorer "shell:appsFolder\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail"
}

OpenOutlook()
{
	RunOutlook()
}

NewThunderbird()
{
  global
  KeyWait "Shift" ; wait for shift to be released to avoid safe mode
  run thunderbird
}

OpenThunderbird()
{ 
  If WinExist("ahk_exe " "thunderbird.exe")
  {
    WinActivate "ahk_exe " "thunderbird.exe"
    return    
  }

  NewThunderbird()
}
