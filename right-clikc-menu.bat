@echo off
:start
cls
echo,
echo Modify
echo,
echo 1 Windows 10
echo,
echo 2 Windows 11
echo,
echo 0 Nothing
echo,
echo,
choice /c:120 /n /m:"Please choose :
if %errorlevel%==0 exit
if %errorlevel%==2 goto cmd2
if %errorlevel%==1 goto cmd1
exit
:cmd1
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
taskkill /f /im explorer.exe
start explorer.exe
exit
:cmd2
reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
taskkill /f /im explorer.exe
start explorer.exe
exit