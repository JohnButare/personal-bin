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
alias imgcat=${HOME}/.iterm2/imgcat;alias imgls=${HOME}/.iterm2/imgls;alias it2api=${HOME}/.iterm2/it2api;alias it2attention=${HOME}/.iterm2/it2attention;alias it2check=${HOME}/.iterm2/it2check;alias it2copy=${HOME}/.iterm2/it2copy;alias it2dl=${HOME}/.iterm2/it2dl;alias it2getvar=${HOME}/.iterm2/it2getvar;alias it2git=${HOME}/.iterm2/it2git;alias it2setcolor=${HOME}/.iterm2/it2setcolor;alias it2setkeylabel=${HOME}/.iterm2/it2setkeylabel;alias it2ul=${HOME}/.iterm2/it2ul;alias it2universion=${HOME}/.iterm2/it2universion