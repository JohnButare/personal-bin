VpnInit()
{
  global
   
  vpn := ""
  vpnTitle := ""

  if FileExist(PROGRAMS64 "\Palo Alto Networks\GlobalProtect\PanGPA.exe") {    
    vpn := PROGRAMS64 "\Palo Alto Networks\GlobalProtect\PanGPA.exe"
    vpnTitle := "GlobalProtect"
  }
}  

VpnWindowToggle()
{
  global

  if (vpnTitle == "") 
    return

  if WinVisible(vpnTitle)
    VpnHide()
  else
    VpnShow()
}

VpnShow()
{
  global

  if ! WinVisible(vpnTitle)
    run vpn
}

VpnHide()
{
  global

  if WinVisible(vpnTitle)
    WinHide vpnTitle
}

VpnConnectionToggle()
{
  global
  VpnShow()
  WinWait vpnTitle, , 1000
  sleep 200
  
  text := ControlGetText("Static6", vpnTitle)
  if text == "Connected"
    ControlClick "Disconnect", vpnTitle
  else if text == "Disconnected"
    ControlClick "Connect", vpnTitle
    
  VpnHide()
}

VpnOn()
{
  global
  VpnShow()
  WinWait vpnTitle, , 1000
  sleep 200
  ControlClick "Connect", vpnTitle
  VpnHide()
}

VpnOff()
{
  global
  VpnShow()
  WinWait vpnTitle, , 1000
  sleep 200
  ControlClick "Disconnect", vpnTitle
  VpnHide()
}