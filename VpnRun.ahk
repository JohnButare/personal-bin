#Include common.ahk
#Include vpn.ahk

CommonInit()
VpnInit()


if A_Args.Length < 1
{
    MsgBox "usage: vpn VpOn|VpnOff|VpnConnectionToggle|VpnShow|VpnHide|VpnWindowToggle" A_Args.Length "."
    ExitApp
}

; %A_Args[1]%
for n, param in A_Args
{
    MsgBox param
}
