
OpenFork()
{ 
	fork := EnvGet("APPDATA") "\..\Local\Fork\Fork.exe"

  If WinExist("ahk_exe" "Fork.exe")
  	WinActivate "Fork"
  else
		run fork
}
