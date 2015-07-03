
# Common applications
app -b $command explorer AutoHotKey

if [[ "$COMPUTERNAME" == @(oversoul|jjbutare-ivm1) ]]; then
	app -b mosaico
elif [[ "$COMPUTERNAME" != @(MiniMe) ]]; then
	app -b winsplit
fi

# Host specific applications
local common="word DropBox PowerMixer PowerMixer"
case "$COMPUTERNAME" in
	bean) f.lux;;
	minime) app -b $command $common;;
	oversoul) app -b $command $common;;
	jjbutare*) app -b $command ProcessExplorer $common SyncPlicity; intel $command -b;;
esac

[[ "$COMPUTERNAME" == "jjbutare-mobl" ]] && app -b "$hp"

# Other
if [[ "$command" == "close" ]]; then
	app -b close LastPass notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

return $?
