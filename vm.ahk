VmInit()
{
  global

  vmware := PROGRAMS32 "\VMware\VMware Workstation\vmware.exe"
  hyperv := "C:\WINDOWS\System32\virtmgmt.msc"
	
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
}

OpenVm()
{
	global
  Open%vm%()
}

NewHyperv()
{
  run "C:\WINDOWS\System32\virtmgmt.msc"
}

OpenHyperv()
{
	WinActivate "Hyper-V Manager"

  If WinExist("Hyper-V Manager")
    return

  run "C:\WINDOWS\System32\virtmgmt.msc"
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

