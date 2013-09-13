
# Common applications
app -q $command AutoHotKey WinSplit VistaSwitcher

# Host specific applications
case "${COMPUTERNAME,,}" in
	"oversoul") app -q $command word EverNote pu DropBox PowerMixer SnagIt iCloud PowerPanel;;
	"minime") app -q $command word EverNote pu DropBox PowerMixer SnagIt iCloud;;
	"jjbutare-mobl") app -q $command word EverNote pu DropBox PowerMixer SnagIt SideBar hp; intel $command
esac

# Other
if [[ "$command" == "startup" ]]; then
	app -q startup explorer
	tc background UpdateSelected
	
elif [[ "$command" == "close" ]]; then
	#app -q close Chrome Firefox LastPass NotepadPP OneNote Outlook ProcessExplorer SnagIt\
	#	Sonos TrueCrypt WindowsMediaPlayer pu Xming
	IsElevated && tc SqlServer service stop all
	
fi

return $?
