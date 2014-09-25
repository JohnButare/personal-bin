
# Common applications
app -b $command explorer AutoHotKey

if [[ "$COMPUTERNAME" == @(oversoul|jjbutare-ivm1) ]]; then
	app -b mosaico
elif [[ "$COMPUTERNAME" != @(MiniMe) ]]; then
	app -b winsplit
fi

# Host specific applications
local common="word EverNote DropBox PowerMixer PowerMixer SnagIt"
case "$COMPUTERNAME" in
	bean) f.lux;;
	minime|oversoul) app -b $command $common;;
	jjbutare*) app -b $command $common pu; intel $command -b;;
esac

[[ "$COMPUTERNAME" == "jjbutare-mobl" ]] && app -b "$hp"

# Other
if [[ "$command" == "close" ]]; then
	app -b close LastPass notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

return $?
