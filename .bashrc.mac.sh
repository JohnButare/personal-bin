#alias e='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias dir='ls'
alias estart="e /etc/profile /etc/bashrc $BIN/bash.bashrc $UBIN/.bash_profile $UBIN/.bashrc"
alias gcp="acp --progress"

GetPreferenceChange() # determine the configure domain for a preferences change
{
	defaults read > /tmp/orig.txt
	pause "Make a change in Preferences..."
	defaults read > /tmp/new.txt
	BeyondCompare /tmp/orig.txt /tmp/new.txt
}