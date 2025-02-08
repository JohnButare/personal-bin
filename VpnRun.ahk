#Include common.ahk
#Include vpn.ahk

CommonInit()
VpnInit()

if A_Args.Length != 1
{
    MsgBox "usage: vpn on|off|toggle|show|hide|wint"
    ExitApp
}

Switch A_Args[1]
{
Case "on": VpnOn
Case "off": VpnOff
Case "toggle": VpnConnectionToggle
Case "show": VpnShow
Case "hide": VpnHide
Case "wint": VpnWindowToggle
Default: MsgBox "'" A_Args[1] "' is not a valid command"
}
    