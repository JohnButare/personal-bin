app -b $command explorer AutoHotKey

if [[ "$COMPUTERNAME" == @(jjbutare-?vm*|jjbutare-mobl*) ]]; then
	app -b $command mosaico
else
	app -b $command winsplit
fi

local common="word DropBox"
case "$COMPUTERNAME" in
	bean) f.lux;;
	jjbutare-wvm*|oversoul) app -b $command $common;;
	jjbutare-i*|jjbutare-mobl*) app -b $command $common SyncPlicity; intel $command -b;;
esac

if [[ "$command" == "close" ]]; then
	app -b close notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

return $?
