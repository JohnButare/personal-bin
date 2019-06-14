local common="AquaSnap TidyTabs AltTabTerminatror DropBox word Greenshot GlassWire PuttyAgent sshd"

app -b $command AutoHotKey || return
xserver $command || return

case "$HOSTNAME" in
	oversoul) app -b $command $common CorsairUtilityEngine IntelRapidStorage;;
	bean) f.lux || return;;
	jjbutare-wvm*) app -b $command $common || return;;
	jjbutare-i*|jjbutare-mobl*) app -b $command $common SyncPlicity || return; intel $command -b || return;;
esac


return 0
