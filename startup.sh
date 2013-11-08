
# Common applications
app -q $command AutoHotKey WinSplit

# Host specific applications
case "${COMPUTERNAME,,}" in
	oversoul) app -q $command LastPass word EverNote DropBox PowerMixer SnagIt iCloud PowerPanel pu;;
	minime) app -q $command word EverNote DropBox PowerMixer SnagIt iCloud;;
	jjbutare-mobl) app -q $command LastPass word EverNote DropBox PowerMixer SnagIt CruiseControlTray hp pu; intel $command;;
	jjbutare-mobl7) app -q $command word EverNote DropBox PowerMixer SnagIt CruiseControlTray; intel $command;;
esac

# Other
if [[ "$command" == "startup" ]]; then
	app -q startup explorer
	
elif [[ "$command" == "close" ]]; then
	#app -q close Chrome Firefox LastPass NotepadPP OneNote Outlook ProcessExplorer SnagIt\
	#	Sonos TrueCrypt WindowsMediaPlayer pu Xming
	IsElevated && tc SqlServer service stop all
	
fi

return $?
