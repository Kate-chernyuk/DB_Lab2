
cls

Del *.exe

@If "%ProgramW6432%" NEQ "" goto 64-bit
 
@Echo "32-bit"
@SET CSC="C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe" 
goto compile

:64-bit
@Echo "64-bit"
@SET CSC="C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"

:compile

%CSC% /t:exe /out:lab2.exe C:\DB\cs\Program.cs /r:.\dll\adodb.dll 

cmd /k lab2.exe

pause>nul
