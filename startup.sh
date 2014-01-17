
# Common applications
app -b $command explorer AutoHotKey WinSplit

# Host specific applications
case "${COMPUTERNAME,,}" in
	oversoul) app -b $command word EverNote DropBox PowerMixer SnagIt iCloud PowerPanel pu;;
	minime) app -b $command word EverNote DropBox PowerMixer SnagIt iCloud pu;;
	jjbutare-mobl) app -b $command word EverNote DropBox PowerMixer SnagIt CruiseControlTray hp pu; intel $command -b;;
	jjbutare-mobl7) app -b $command word EverNote DropBox PowerMixer SnagIt CruiseControlTray pu; intel $command -b;;
esac

# Other
if [[ "$command" == "close" ]]; then
	app -b close LastPass notepadpp ProcessExplorer
	IsElevated && SqlServer service stop all
fi

return $?
