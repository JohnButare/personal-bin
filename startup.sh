app -b $command explorer AutoHotKey

local common="AquaSnap TidyTabs AltTabTerminatror DropBox word Greenshot GlassWire"
case "$COMPUTERNAME" in
	oversoul) app -b $command CorsairUtilityEngine $common IntelRapidStorage vmware; PuttyAgent;;
	bean) f.lux;;
	jjbutare-wvm*) app -b $command $common;;
	jjbutare-i*|jjbutare-mobl*) app -b $command $common SyncPlicity; intel $command -b;;
esac

if [[ "$command" == "close" ]]; then
	app -b close notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

# start X if it is not started (X is in /usr/bin/XWin for Cygwin)
if [[ "$command" == "startup" && -f "/usr/bin/XWin" ]] && ! ps | grep XWin > /dev/null; then
	printf "X server..."
	startxwin &
fi

return $?
