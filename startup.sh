
# Common applications
app $command AutoHotKey WinSplit VistaSwitcher

# Host specific applications
case ${COMPUTERNAME,,} in
	oversoul) app $command word EverNote pu DropBox PowerMixer SnagIt iCloud GoogleDrive PowerPanel;;
	minime) app $command word EverNote pu DropBox PowerMixer SnagIt;;
	jjbutare-mobl) app $command word EverNote pu DropBox PowerMixer SnagIt iCloud SideBar hp; tc intel $command
esac

# Other
if [[ "$command" == "startup" ]]; then
	app startup explorer
	tc background UpdateSelected
	
elif [[ "$command" == "close" ]]; then
	app close Chrome Firefox LastPass NotepadPP OneNote Outlook ProcessExplorer SnagIt\
		Sonos TrueCrypt WindowsMediaPlayer pu Xming
	IsElevated && tc SqlServer service stop all
	
fi

return $?
