@ECHO OFF
REM -- Automates cygwin installation
REM -- Source: https://github.com/rotor-head/auto-cygwin-install
REM -- Based on: https://gist.github.com/wjrogers/1016065 and https://github.com/rtwolf/auto-cygwin-install
REM --
REM -- 32-bit URL: https://www.cygwin.com/setup-x86.exe
REM -- 64-bit URL: https://www.cygwin.com/setup-x86_64.exe
 
SETLOCAL

REM -- Get OS version and Architecture type to select correct installer

REM -- use 1st for loop if you need sub build numbers.  
REM for /f "tokens=4-5 delims=. " %%i in ('ver') do SET CURRVERSION=%%i.%%j
for /f "tokens=4-5 delims=. " %%i in ('ver') do SET CURRVERSION=%%i

REM -- SET /A gives numeric values for accurate compare - script will break without the flag
SET /A VERSION=%CURRVERSION%
SET /A COMPARE=6

REM -- os = 0 for XP/2003  os = 1 for Vista and newer

if %VERSION% GEQ %COMPARE% ( SET /A OSVERSION=1 ) else ( SET /A OSVERSION=0 )


ECHO Version returned %VERSION%, Comparison is %COMPARE%

REM -- following doesn't account for 'independent' arch

if /i "%processor_architecture%" == "AMD64" ( SET /A PROCESSOR=64 ) else ( SET /A PROCESSOR=32 )

ECHO %processor_architecture% and %PROCESSOR% and OS Ver %OSVERSION%

REM -- there are no 64bit builds for the older Cygwin versions

if %OSVERSION% == 0 SET INSTALLER=setup.exe

if %OSVERSION% == 1 ECHO OS is 6.0 or greater
if %PROCESSOR% == 64 ECHO Arch is 64bit

REM -- for 32bit builds of 2.6.x or newer

if %OSVERSION% == 1 (
		if %PROCESSOR% == 32 (
		 SET INSTALLER=setup-x86.exe
			      ) 	   	
		)

REM -- for 64bit builds of 2.6.x or newer

if %OSVERSION% == 1 (
	 if %PROCESSOR% == 64 (
		 SET INSTALLER=setup-x86_64.exe
			      )
	   	)
 
REM -- Change to the directory of the executing batch file

CD %~dp0

ECHO "%~dp0"
ECHO Installer is %INSTALLER%
 
REM -- Configure our paths
SET SITE=http://cygwin.mirrors.pair.com/
SET LOCALDIR=%CD%
SET ROOTDIR=C:/cygwin
 
REM -- These are the packages we will install (in addition to the default packages)
REM -- MODIFY BELOW TO SUITE AND ADD apt-cyg
REM -- These are necessary for apt-cyg install, Add or adjust to suite needs beyond base. Any duplicates will be ignored.
REM -- SET PACKAGES=%PACKAGES%,wget,tar,gawk,bzip2,subversion

SET PACKAGES=bash,mintty,wget,rsync,curl,vim,lynx,tar,gawk,bzip2,subversion,openssh
 
REM -- Do it!
ECHO *** INSTALLING DEFAULT PACKAGES
%INSTALLER% --quiet-mode --no-desktop --download --local-install --no-verify -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -P "%PACKAGES%"
ECHO.
ECHO.

REM -- Show what we did
ECHO.
ECHO.
ECHO cygwin installation updated
ECHO  - %PACKAGES%
ECHO.


ECHO apt-cyg installing.
set PATH=%ROOTDIR%/bin;%PATH%
%ROOTDIR%/bin/bash.exe -c 'svn --force export https://github.com/transcode-open/apt-cyg /bin/'
REM -- ^                            ^
REM -- | removed ref to google code |
REM --   added ref to transcode
REM -- 
REM -- Pull and install
%ROOTDIR%/bin/bash.exe -c 'lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > %ROOTDIR%/apt-cyg
%ROOTDIR%/bin/bash.exe -c 'chmod +x %ROOTDIR%/apt-cyg'
%ROOTDIR%/bin/bash.exe -c 'install %ROOTDIR%/apt-cyg %ROOTDIR%/bin'

REM -- Verify version info
%ROOTDIR%/bin/bash.exe -c 'apt-cyg --version'

ENDLOCAL
 
PAUSE
EXIT /B 0
