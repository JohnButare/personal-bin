local file="DropBox OneDrive"
local common="AquaSnap TidyTabs AltTabTerminator LogitechOptions word Greenshot GlassWire PuttyAgent sshd $file"

app -b $command AutoHotKey || return
xserver $command || return

case "$HOSTNAME" in
	oversoul|ultron) app -b $command $common CorsairUtilityEngine IntelRapidStorage || return;;
	bean) duet f.lux || return;;
	jjbutare-mobl*) app -b $command $common duet || return;;
	jjbutare-wvm*) app -b $command $common || return;;
esac

return 0
