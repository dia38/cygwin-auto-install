@ECHO OFF
REM -- Automates cygwin installation
REM -- Source: https://github.com/rotor-head/auto-cygwin-install
REM -- Based on: https://gist.github.com/wjrogers/1016065 and https://github.com/rtwolf/auto-cygwin-install
REM --
REM -- 32-bit URL: https://www.cygwin.com/setup-x86.exe
REM -- 64-bit URL: https://www.cygwin.com/setup-x86_64.exe
 
SETLOCAL

REM -- Get OS version and Architecture type to select correct installer
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" GEQ "6.0" ( SET OSVERSION=1 ) else ( SET OSVERSION=0 )  REM os = 0 for XP/2003  os = 1 for Vista and newer
if /i %processor_architecture% == "AMD64" ( SET PROCESSOR=64 ) else ( SET PROCESSOR=32 ) REM doesn't account for 'independent' arch

REM -- there are no 64bit builds for the older Cygwin versions
if OSVERSION == 0 SET INSTALLER=setup.exe

REM -- for 32bit builds of 2.6.x or newer
if %OSVERSION% == 1 (
	 if %PROCESSOR% == 32 (
		 SET INSTALLER=setup-x86.exe 
			      ) 
	   	)

REM -- for 64bit builds of 2.6.x or newer
if %OSVERSION% == 1 (
	 if %PROCESSOR% == 32 (
		 SET INSTALLER=setup-x86_64.exe 
			      ) 
	   	)
 
REM -- Change to the directory of the executing batch file
CD %~dp0
 
REM -- Configure our paths
SET SITE=http://cygwin.mirrors.pair.com/
SET LOCALDIR=%CD%
SET ROOTDIR=C:/cygwin
 
REM -- These are the packages we will install (in addition to the default packages)
SET PACKAGES=bash,mintty,wget,rsync,curl,vim,lynx
REM -- These are necessary for apt-cyg install, do not change. Any duplicates will be ignored.
SET PACKAGES=%PACKAGES%,wget,tar,gawk,bzip2,subversion
 
REM -- Do it!
ECHO *** INSTALLING DEFAULT PACKAGES
%INSTALLER% --quiet-mode --no-desktop --download --local-install --no-verify -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%"
ECHO.
ECHO.
ECHO *** INSTALLING CUSTOM PACKAGES
%INSTALLER% -q -d -D -L -X -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -P %PACKAGES%
 
REM -- Show what we did
ECHO.
ECHO.
ECHO cygwin installation updated
ECHO  - %PACKAGES%
ECHO.

ECHO apt-cyg installing.
set PATH=%ROOTDIR%/bin;%PATH%
REM -- %ROOTDIR%/bin/bash.exe -c 'svn --force export https://github.com/transcode-open/apt-cyg /bin/'
REM -- ^                            ^
REM -- | removed ref to google code |
REM --   added ref to transcode here 
%ROOTDIR%/bin/bash.exe -c 'lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg'
%ROOTDIR%/bin/bash.exe -c 'install apt-cyg /bin'
%ROOTDIR%/bin/bash.exe -c 'chmod +x /bin/apt-cyg'
ECHO apt-cyg installed if it says something like "A    /bin" and "A   /bin/apt-cyg" and "Exported revision 18" or some other number.

ENDLOCAL
 
PAUSE
EXIT /B 0
