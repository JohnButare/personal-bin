local file="DropBox OneDrive"
local common="AquaSnap TidyTabs AltTabTerminator LogitechOptions word Greenshot GlassWire PuttyAgent sshd $file"

app -b $command AutoHotKey || return
xserver $command || return

case "$HOSTNAME" in
	oversoul) app -b $command $common CorsairUtilityEngine IntelRapidStorage Discord || return;;
	bean) f.lux || return;;
	jjbutare-wvm*) app -b $command $common || return;;
esac

return 0
