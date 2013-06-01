; #=Win, !=Alt, +=Shift ^=Control

#!m::MusicCopyArtist()
^0::send Intel{enter}

; MusicCopyArtist()
; In Windows Media Player, copy the Contributing Artist to the Album Artist.  
; Before running this macro, position the mouse cursor over the Contributing Artist in the Fix - Various Artist playlist.
; When the tag is updated move the mouse to the next song to update
; Assign the macro to a single ey temporarily
; If the cursor is positioned near the bottom of the list the list will automatically scroll preventing the need for a mouse movement
MusicCopyArtist()
{
	MouseClick, right
	Send e^c{shift down}
	Sleep 400
	Send {tab}{shift up}^v
	return
}


