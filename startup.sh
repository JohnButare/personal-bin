
# Common applications
app -b $command AutoHotKey WinSplit

# Host specific applications
case "${COMPUTERNAME,,}" in
	oversoul) app -b $command LastPass word EverNote DropBox PowerMixer SnagIt iCloud PowerPanel pu;;
	minime) app -b $command word EverNote DropBox PowerMixer SnagIt iCloud pu;;
	jjbutare-mobl) app -b $command LastPass word EverNote DropBox PowerMixer SnagIt CruiseControlTray hp pu; intel $command -b;;
	jjbutare-mobl7) app -b $command word EverNote DropBox PowerMixer SnagIt CruiseControlTray pu; intel $command -b;;
esac

# Other
if [[ "$command" == "startup" ]]; then
	app -b startup explorer
	
elif [[ "$command" == "close" ]]; then
	#app -q close Chrome Firefox LastPass NotepadPP OneNote Outlook ProcessExplorer SnagIt\
	#	Sonos TrueCrypt WindowsMediaPlayer pu Xming
	IsElevated && tc SqlServer service stop all
	
fi

return $?
