@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "NODE_NO_WARNINGS=1"
set "NODE_OPTIONS=--no-deprecation"
set "BASE_URL=https://vm0099sim/archive/vsix"
set "FAILED=0"

call :download_and_install "ms-vscode-remote.remote-ssh-0.124.0.vsix"
call :download_and_install "ms-vscode-remote.remote-ssh-edit-0.87.0.vsix"
call :download_and_install "ms-vscode-remote.remote-server-1.5.3.vsix"
call :download_and_install "ms-vscode-remote.vscode-remote-extensionpack-0.26.0.vsix"

if "%FAILED%"=="1" (
  echo.
  echo One or more extensions failed.
  exit /b 1
)
echo.
echo All extensions installed.
exit /b 0

:download_and_install
set "VSIX=%~1"
echo.
echo === %VSIX% ===
curl.exe -fsSLk -o "%VSIX%" "%BASE_URL%/%VSIX%"
if errorlevel 1 (
  echo Download failed: %VSIX%
  set "FAILED=1"
  goto :eof
)
rem Isolate code.cmd: it uses "exit N" (not "exit /b"), which would kill this .bat.
cmd /c code --install-extension "%CD%\%VSIX%"
if errorlevel 1 (
  echo Install failed: %VSIX%
  set "FAILED=1"
  goto :eof
)
goto :eof
