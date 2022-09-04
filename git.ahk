GitInit()
{
  global

  GitKraken := LOCALAPPDATA "\gitkraken\app-8.8.0\resources\bin\gitkraken.cmd"
  fork := LOCALAPPDATA "\..\Local\Fork\Fork.exe"
	
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
  If WinExist("ahk_exe" "gitkraken.exe")
    WinActivate "GitKraken"
  else
    NewGitKraken
}
