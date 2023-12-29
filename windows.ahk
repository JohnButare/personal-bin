CenterWindow()
{
  Send "#!c#"     ; MaxTo center
  Sleep 1
  Send "#{Right}" ; MaxTo move right a region - should be the right region
  Sleep 1
  Send "#{Left}"  ; MaxTo move left a region - should be the center region
}
