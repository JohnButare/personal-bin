##include <Process.au3>

Opt("TCPTimeout", 10) ;10 milliseconds
TCPStartup()
Opt("TCPTimeout", 10) ;10 milliseconds

Local $ip = TCPNameToIP("win7aasfas")
ConsoleWrite($ip)
