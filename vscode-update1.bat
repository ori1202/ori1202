@echo off
cd /d "%~dp0"
set NODE_NO_WARNINGS=1

curl.exe -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-ssh-0.124.0.vsix" && cmd /c code --install-extension "ms-vscode-remote.remote-ssh-0.124.0.vsix"
curl.exe -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-ssh-edit-0.87.0.vsix" && cmd /c code --install-extension "ms-vscode-remote.remote-ssh-edit-0.87.0.vsix"
curl.exe -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-server-1.5.3.vsix" && cmd /c code --install-extension "ms-vscode-remote.remote-server-1.5.3.vsix"
curl.exe -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.vscode-remote-extensionpack-0.26.0.vsix" && cmd /c code --install-extension "ms-vscode-remote.vscode-remote-extensionpack-0.26.0.vsix"
