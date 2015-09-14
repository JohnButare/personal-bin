
# Common applications
app -b $command explorer AutoHotKey

[[ "$COMPUTERNAME" == @(jjbutare-?vm*) ]] && app -b $command mosaico
[[ "$COMPUTERNAME" != @(jjbutare-?vm*|MiniMe) ]] && app -b $command winsplit

# Host specific applications
local common="word DropBox"
case "$COMPUTERNAME" in
	bean) f.lux;;
	minime | oversoul | jjbutare-wvm*) app -b $command $common;;
	oversoul) app -b $command $common;;
	jjbutare-i* | jjbutare-mobl*) app -b $command $common SyncPlicity; intel $command -b;;
esac

if [[ "$command" == "close" ]]; then
	app -b close notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

return $?
