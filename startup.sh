
# Common applications
app -b $command explorer AutoHotKey WinSplit

# Host specific applications
local common="word EverNote DropBox PowerMixer PowerMixer f.lux SnagIt pu"
case "${COMPUTERNAME,,}" in
	bean) f.lux;;
	minime) app -b $command $common;;
	oversoul) app -b $command $common;;
	jjbutare-mobl) app -b $command $common hp; intel $command -b;;
	jjbutare-mobl7) app -b $command $common; intel $command -b;;
esac

# Other
if [[ "$command" == "close" ]]; then
	app -b close LastPass notepadpp ProcessExplorer
	IsElevated && SqlServer service stop --all
fi

return $?
