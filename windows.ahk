WindowInit()
{
  global

  maxTo := UADATA "\MaxTo\MaxTo.Core.exe"
  
  if FileExist(maxTo)
    win := "MaxTo"
  else
    win := "Win"

  ;MsgBox win
}

CenterWindow()
{
  global
  center%win%()
}

CenterMaxTo()
{
  Send "#!c#"     ; MaxTo center
  Sleep 1
  Send "#{Right}" ; MaxTo move right a region - should be the right region
  Sleep 1
  Send "#{Left}"  ; MaxTo move left a region - should be the center region
}

CenterWin()
{
  ; open the snap menu - two seems to be required
  ;Send "#a"
  SendEvent "#z"
  Sleep 500

  ; 3 windows
  Send "9"
  
  ; middle window
  Send "2"
}
