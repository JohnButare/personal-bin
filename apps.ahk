
Open1Password()
{
	program := EnvGet("APPDATA") "\..\Local\1Password\app\8\1Password.exe"

	if ! FileExist(program) 
		program := EnvGet("APPDATA") "\..\Local\Microsoft/WindowsApps/1Password.exe"
	else
		program := EnvGet("ProgramFiles") "\1Password\app\8\1Password.exe"

	if ! FileExist(program)
		return

  If WinExist("ahk_exe" "1Password.exe")
  	WinActivate "1Password"
  else
		run program
}

OpenAi()
{
	program := EnvGet("APPDATA") "\..\Local\AnthropicClaude\claude.exe"	

  If WinExist("ahk_exe" "claude.exe")
  	WinActivate "Claude"
  else
		run program
		;  --squirrel-firstrun
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

OpenTeams()
{
	program := UADATA "\Microsoft\WindowsApps\ms-teams.exe"	
	title := ".*Microsoft Teams"

  If WinExist("ahk_exe" "ms-teams.exe")
  {
  	;WinRestore title
		WinActivate title
	}
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

OpenVisualStudioCode()
{
	program := EnvGet("APPDATA") "\..\Local\Programs\Microsoft VS Code\Code.exe"	

  If WinExist("ahk_exe" "Code.exe")
  	WinActivate ".* - Visual Studio Code"
  else
		run program
}
