@echo off

set "Path=%~dp0bin\Win\x86_64;%PATH%"

busybox ash "%~dp0repackimg.sh" %*
exit /b %errorlevel%