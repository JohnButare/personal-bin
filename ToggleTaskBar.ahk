; https://www.reddit.com/r/AutoHotkey/comments/el94pf/script_to_hide_not_autohide_just_hide_taskbar_on/

ToggleTaskBar()
{
	APPBARDATA	:= BufferAlloc(A_PtrSize=4 ? 36:48, 0)
	hidden := DllCall("Shell32\SHAppBarMessage", "UInt", 4, "Ptr", APPBARDATA.Ptr)

	if (hidden)
	{
		WinShow("ahk_class Shell_TrayWnd")
		NumPut("UInt", 2, APPBARDATA, A_PtrSize=4 ? 32:40)
		DllCall("Shell32\SHAppBarMessage", "UInt", 10, "Ptr", APPBARDATA.Ptr)
	}
	else
	{
		NumPut("UInt", 1, APPBARDATA, A_PtrSize=4 ? 32:40)
		DllCall("Shell32\SHAppBarMessage", "UInt", 10, "Ptr", APPBARDATA.Ptr)
	}
}