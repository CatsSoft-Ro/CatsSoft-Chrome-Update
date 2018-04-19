@echo off
Title CatsSoft-Chrome-Update
color 0B
mode con:cols=90 lines=26
echo.
echo --------------------------------------------------------------------------------- >> CatsSoft-Chrome-Update.txt
echo Check For Updates >> CatsSoft-Chrome-Update.txt
echo. |time |find "current" >> CatsSoft-Chrome-Update.txt
echo %date% >> CatsSoft-Chrome-Update.txt
echo --------------------------------------------------------------------------------- >> CatsSoft-Chrome-Update.txt
echo.
SET "BinDir=%~dp0Bin"
echo.
if exist "%BinDir%" (
 goto menu
) else (
 MD "%BinDir%"
 goto menu
)
goto menu
goto :eof
:: /*************************************************************************************/
:: Menu of tool.
:: void menu();
:: /*************************************************************************************/
:menu
    @cls
    Title CatsSoft-Chrome-Update
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and uninstall old version of Google Chrome.
    echo.
    echo.    [2] Type "2" and get download link for Google Chrome. 
    echo.
    echo.    [3] Type "3" and download new version of Google Chrome. 
    echo.
    echo.    [0] Type "0" and close this tool.
    echo.
    echo.

    set /P "option=Type 1, 2, 3 or 0 then press ENTER: "

    if %option% EQU 0 (
       goto close
    ) else if %option% EQU 1 (
       goto uninstall
    ) else if %option% EQU 2 (
       goto getlink
    ) else if %option% EQU 3 (
       goto download
    ) else (
    echo.
    echo.Invalid option.
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
    )
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: uninstall Google Chrome.
:: void uninstall();
:: /*************************************************************************************/
:uninstall
    @cls
    Title CatsSoft-Uninstall-Chrome
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" /v InstallLocation`) DO (
        set InstallLocation=%%A
    )
    ECHO InstallLocation: %InstallLocation% >> CatsSoft-Chrome-Update.txt
    echo.
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" /v DisplayVersion`) DO (
        set DisplayVersion=%%A
    )
    ECHO DisplayVersion: %DisplayVersion% >> CatsSoft-Chrome-Update.txt
    echo.
    set ChromeInstallLocation=%InstallLocation%\%DisplayVersion%\Installer
    echo.
    echo ChromeUninstallLocation: %ChromeInstallLocation% >> CatsSoft-Chrome-Update.txt
    echo.
    echo Please wait Google Chrome is uninstalled.
    echo.
    if exist "%ChromeInstallLocation%\setup.exe" (
    echo.
    taskkill /F /IM "Chrome.exe"
    "%ChromeInstallLocation%\setup.exe" --uninstall
     echo Google Chrome has been sucessfully Uninstall.
     goto close_uninstaller
    ) else (
     echo Google Chrome was failed Uninstall.
     goto close_uninstaller
    )
    :close_uninstaller
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Download Google Chrome.
:: void Download();
:: /*************************************************************************************/
:getlink
    @cls
    Title CatsSoft-Get-Link-Chrome
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    start /d "%PROGRAMFILES%\Internet Explorer" IEXPLORE.EXE "https://api.shuax.com/tools/getchrome"
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Download Google Chrome.
:: void Download();
:: /*************************************************************************************/
:Download
    @cls
    Title CatsSoft-Download-Chrome
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Paste URL below (right click - Paste) and press Enter
    echo.
    set /P "URL=URL: "
    echo URL: %URL% >> CatsSoft-Chrome-Update.txt
    echo.
    for %%g in ("%URL%") do set "File=%%~nxg"
    echo File: %File% >> CatsSoft-Chrome-Update.txt
    echo.
    FOR /F "tokens=1,2,3,4,5 delims=/" %%A IN ("%URL%") DO set "Domain=%%B"
    echo Domain: %Domain% >> CatsSoft-Chrome-Update.txt
    echo.
    for /f "tokens=1,2,3,4,5delims=_chrome_installer" %%F in ("%File%") DO set "Version=%%F"
    echo Version: %Version% >> CatsSoft-Chrome-Update.txt
    echo.
    for %%f in ("%~dp0*_chrome_installer.exe") do (
     set cver=%%~nf
    )
    if not exist "%~dp0%cver%.exe" ( set cver=none )
    echo.
    REM [DEBUG]
    echo current install is %cver%
    echo.
    echo Checking server for updates . . .
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%BinDir%\wget.exe" (
       goto gcstandard
      ) else (
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" "%BinDir%\wget.exe"
       goto gcstandard
      )
    ) else (
      if exist "%BinDir%\wget.exe" (
       goto gcstandard
      ) else (
       bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/64/wget.exe" "%BinDir%\wget.exe"
       goto gcstandard
      )
    )
    :gcstandard
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    cd /d "Bin"
    wget.exe --continue --show-progress --no-check-certificate "%URL%" -O "%~dp0%File%"
    if %errorlevel%==1 exit 1
    if exist "%~dp0%File%" (
      echo The files "%File%" has been sucessfully downloaded!
      goto install
    ) else (
      echo The files "%File%" could not be downloaded! Try again later.
      goto close
    )
    :install
    echo.
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0*_chrome_installer.exe"') do @del "%%F"
    for %%f in ("%~dp0*_chrome_installer.exe") do (
    if %%~nf==%cver% (
     echo.
      echo Google Chrome is already up to date [%%~nf]
     echo.
    ) else (
     echo.
     echo A newer version of Google Chrome was found [%cver% --^> %%~nf]
     echo.
     echo Installing . . .
     REM [DEBUG] comment this for debugging
     echo.
     %%~ff /silent /install
     echo.
     echo Finished!
     echo.
     )
    )
    echo.
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" /v InstallLocation`) DO (
        set InstallLocation=%%A
        )
    ECHO InstallLocation: %InstallLocation%
    echo.
    if exist "%InstallLocation%\chrome.exe" (
    echo.
    echo Google Chrome has been sucessfully installed!
    echo.
    start /d "%InstallLocation%" chrome.exe "https://github.com/CatsSoft-Ro"
     goto close
    ) else (
    echo.
    echo Google Chrome could not be installed! Try again later.
    echo.
     goto close
    )
    REM echo.
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: End tool.
:: void close();
:: /*************************************************************************************/
:close
goto :eof
exit