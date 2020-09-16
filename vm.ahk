VmInit()
{
  global

  vmware := PROGRAMS32 "\VMware\VMware Workstation\vmware.exe"
  hyperv := "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe"
	
  if FileExist(vmware)
  	vm := "Vmware"
  else if FileExist(hyperv)
    vm := "Hyperv"
	else
		vm := ""

  if (DEFAULT_VM = "vmware" && FileExist(vmware))
    vm := "Vmware"

  if (DEFAULT_BROWSER = "hyperv" && FileExist(hyperv))
    vm := "Hyperv"

  ;MsgBox vm
}

OpenVm()
{
	global
  Open%vm%()
}

OpenHyperv()
{
	WinActivate "Hyper-V Manager"
	;%windir%\System32\mmc.exe "%windir%\System32\virtmgmt.msc"
}

NewVmware()
{
	global
	run PROGRAMS32 "\VMware\VMware Workstation\vmware.exe"
}

OpenVmware()
{
	global

  WinActivate "ahk_exe " "vmware.exe"

  If WinExist("ahk_exe " "vmware.exe")
    return    

  NewVmware()
}

