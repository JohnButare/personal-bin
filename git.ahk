GitInit()
{
  global

  GitKraken := UADATA "\gitkraken\app-9.7.1\resources\bin\gitkraken.cmd"
  fork := UADATA "\..\Local\Fork\Fork.exe"
	
  if FileExist(GitKraken)
  	git := "GitKraken"
  else if FileExist(fork)
    git := "Fork"

  ;MsgBox git
}

NewGit()
{
  global
  New%git%()
}

OpenGit()
{
  global
  Open%git%() 
}

NewFork()
{
  run fork
}

OpenFork()
{ 
  If WinExist("ahk_exe" "Fork.exe")
    WinActivate "Fork"
  else
    NewFork
}

NewGitKraken()
{
  run GitKraken
}

OpenGitKraken()
{ 
  if WinExist("GitKraken") or WinExist("ahk_exe" "gitkraken.exe")
    WinActivate "GitKraken"
  else
    NewGitKraken
}
