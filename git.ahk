GitInit()
{
  global

  GitKraken := UADATA "\gitkraken\app-11.4.0\resources\bin\gitkraken.cmd"
  GitKraken := "\\wsl.localhost\Ubuntu\usr\bin\gitkraken"
  fork := UADATA "\..\Local\Fork\Fork.exe"
	
  if FileExist(GitKraken)
  	git := "GitKraken"
  else if FileExist(fork)
    git := "Fork"
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
  ; run GitKraken
  Run "wsl.exe -- DISPLAY=0.0.0.0:0 gitkraken --path /usr/local/data/bin", , "Min"
}

OpenGitKraken()
{ 
  if WinExist("GitKraken") or WinExist("ahk_exe" "gitkraken.exe")
    WinActivate "GitKraken"
  else
    NewGitKraken
}
