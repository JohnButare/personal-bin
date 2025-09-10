alias karabiner='KarabinerElements'
alias dir='ls'
alias estart="e /etc/profile /etc/bashrc $BIN/bash.bashrc $UBIN/.bash_profile $UBIN/.bashrc $UBIN/.profile"

AppFixPermissions() { sudoc gchown root -R "/Applications/$1.app" && sudoc gchgrp wheel -R "/Applications/$1.app"; }
AppCheckPermissions() { ls -al "/Applications" | grep $USER; } # Applications should be owned by root not the current user

# GetPreferenceFile APP - find the preference file for APP
GetPreferenceFile()
{
	local app="$1"
	local id="$(defaults domains | tr ',' '\n' | ${G}grep -i "$app" | RemoveSpaceTrim)"
	echo "Searching for '$id.plist'..."
	fd "$id.plist" ~/Library /Library /System/Library
}

# GetPreferenceChange - determine the configure domain for a preferences change
GetPreferenceChange()
{
	defaults read > /tmp/orig.txt
	pause "Make a change in Preferences..."
	defaults read > /tmp/new.txt
	BeyondCompare /tmp/orig.txt /tmp/new.txt
}

SmbFix()
{
	sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist	|| return
	sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist || return
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist EnabledServices -array disk || return
}

return 0
