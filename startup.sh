
# Common applications
app -b $command explorer AutoHotKey

if [[ "$COMPUTERNAME" == @(jjbutare-ivm1) ]]; then
	app -b mosaico
else
	app -b winsplit
fi

# Host specific applications
local common="word EverNote DropBox PowerMixer PowerMixer f.lux SnagIt pu"
case "$COMPUTERNAME" in
	bean) f.lux;;
	minime) app -b $command $common;;
	oversoul) app -b $command $common;;
	jjbutare*) app -b $command $common; intel $command -b;;
esac

[[ "$COMPUTERNAME" == "jjbutare-mobl" ]] && app -b "$hp"

# Other
if [[ "$command" == "close" ]]; then
	app -b close LastPass notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

return $?
