app -b $command AutoHotKey

local common="AquaSnap TidyTabs AltTabTerminatror DropBox word Greenshot GlassWire"
case "$HOSTNAME" in
	oversoul) app -b $command CorsairUtilityEngine $common IntelRapidStorage vmware;;
	bean) f.lux;;
	jjbutare-wvm*) app -b $command $common;;
	jjbutare-i*|jjbutare-mobl*) app -b $command $common SyncPlicity; intel $command -b;;
esac

[[ "$command" == "close" ]] && { app -b close notepadpp ProcessExplorer || return; }

return 0
