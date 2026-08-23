@echo off
setlocal EnableExtensions
cd /d "%~dp0"

rem Hide Node DEP0169 from the VS Code CLI (deprecated url.parse).
set "NODE_NO_WARNINGS=1"

rem "call" is required: "code" is code.cmd, and without it this .bat would
rem exit after the first install instead of continuing the remaining lines.
curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-ssh-0.124.0.vsix" && call code --install-extension "ms-vscode-remote.remote-ssh-0.124.0.vsix"
curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-ssh-edit-0.87.0.vsix" && call code --install-extension "ms-vscode-remote.remote-ssh-edit-0.87.0.vsix"
curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.remote-server-1.5.3.vsix" && call code --install-extension "ms-vscode-remote.remote-server-1.5.3.vsix"
curl -fsSLOk "https://vm0099sim/archive/vsix/ms-vscode-remote.vscode-remote-extensionpack-0.26.0.vsix" && call code --install-extension "ms-vscode-remote.vscode-remote-extensionpack-0.26.0.vsix"
