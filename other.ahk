
OpenFork()
{ 
	program := EnvGet("APPDATA") "\..\Local\Fork\Fork.exe"

  If WinExist("ahk_exe" "Fork.exe")
  	WinActivate "Fork"
  else
		run program
}

Open1Password()
{
	program := EnvGet("APPDATA") "\..\Local\1Password\app\8\1Password.exe"	

  If WinExist("ahk_exe" "1password.exe")
  	WinActivate "1Password"
  else
		run program
}