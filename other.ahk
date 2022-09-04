
Open1Password()
{
	program := EnvGet("APPDATA") "\..\Local\1Password\app\8\1Password.exe"	

  If WinExist("ahk_exe" "1password.exe")
  	WinActivate "1Password"
  else
		run program
}