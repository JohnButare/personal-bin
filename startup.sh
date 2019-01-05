app -b $command explorer AutoHotKey

local common="AquaSnap TidyTabs AltTabTerminatror DropBox word GlassWire"
case "$COMPUTERNAME" in
	oversoul) app -b $command CorsairUtilityEngine $common IntelRapidStorage;;
	bean) f.lux;;
	jjbutare-wvm*) app -b $command $common;;
	jjbutare-i*|jjbutare-mobl*) app -b $command $common SyncPlicity; intel $command -b;;
esac

if [[ "$command" == "close" ]]; then
	app -b close notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

return $?
