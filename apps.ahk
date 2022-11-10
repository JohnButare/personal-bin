
Open1Password()
{
	program := EnvGet("APPDATA") "\..\Local\1Password\app\8\1Password.exe"	

  If WinExist("ahk_exe" "1password.exe")
  	WinActivate "1Password"
  else
		run program
}

OpenSlack()
{
	program := EnvGet("APPDATA") "\..\Local\slack\app-4.28.184\slack.exe"	

  If WinExist("ahk_exe" "slack.exe")
  	WinActivate ".*Slack"
  else
		run program
}

OpenSqlServerManagementStudio()
{
	program := EnvGet("ProgramFiles(x86)") "\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe"	

  If WinExist("ahk_exe" "Ssms.exe")
  	WinActivate ".*Microsoft SQL Server Management Studio"
  else
		run program
}

OpenVisualStudio()
{
	program := EnvGet("ProgramFiles") "\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"	

  If WinExist("ahk_exe" "devenv.exe")
  	WinActivate ".*Microsoft Visual Studio"
  else
		run program
}
