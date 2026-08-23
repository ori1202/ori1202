@echo off
setlocal EnableExtensions
cd /d "%~dp0"

curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-ssh-0.124.0.vsix" && code --install-extension "ms-vscode-remote.remote-ssh-0.124.0.vsix"
curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-ssh-edit-0.87.0.vsix" && code --install-extension "ms-vscode-remote.remote-ssh-edit-0.87.0.vsix"
curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-server-1.5.3.vsix" && code --install-extension "ms-vscode-remote.remote-server-1.5.3.vsix"
curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.vscode-remote-extensionpack-0.26.0.vsix" && code --install-extension "ms-vscode-remote.vscode-remote-extensionpack-0.26.0.vsix"
