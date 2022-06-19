#alias e='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias dir='ls'
alias estart="e /etc/profile /etc/bashrc $BIN/bash.bashrc $UBIN/.bash_profile $UBIN/.bashrc"
alias gcp="acp --progress"

AppFixPermissions() { sudoc gchown root -R "/Applications/$1.app" && sudoc gchgrp wheel -R "/Applications/$1.app"; }
AppCheckPermissions() { ls -al "/Applications" | grep $USER; } # Applications should be owned by root not the current user

GetPreferenceChange() # determine the configure domain for a preferences change
{
	defaults read > /tmp/orig.txt
	pause "Make a change in Preferences..."
	defaults read > /tmp/new.txt
	BeyondCompare /tmp/orig.txt /tmp/new.txt
}

alias karabiner='"/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"'

# iTerm2
SourceIfExists "$HOME/.iterm2_shell_integration.zsh" || return
