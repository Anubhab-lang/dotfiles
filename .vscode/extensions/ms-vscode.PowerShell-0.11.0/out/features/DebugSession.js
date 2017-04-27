/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
"use strict";
const vscode = require("vscode");
class DebugSessionFeature {
    constructor() {
        this.command = vscode.commands.registerCommand('PowerShell.StartDebugSession', config => { this.startDebugSession(config); });
    }
    setLanguageClient(languageclient) {
    }
    dispose() {
        this.command.dispose();
    }
    startDebugSession(config) {
        if (!config.request) {
            // No launch.json, create the default configuration
            config.type = 'PowerShell';
            config.name = 'PowerShell Launch Current File';
            config.request = 'launch';
            config.args = [];
            config.script = vscode.window.activeTextEditor.document.fileName;
        }
        if (config.request === 'launch') {
            // Make sure there's a usable working directory if possible
            config.cwd = config.cwd || vscode.workspace.rootPath || config.script;
            // For launch of "current script", don't start the debugger if the current file
            // is not a file that can be debugged by PowerShell
            if (config.script === "${file}") {
                let filename = vscode.window.activeTextEditor.document.fileName;
                let ext = filename.substr(filename.lastIndexOf('.') + 1);
                let langId = vscode.window.activeTextEditor.document.languageId;
                if ((langId !== 'powershell') || (ext !== "ps1" && ext !== "psm1")) {
                    let path = filename;
                    let workspaceRootPath = vscode.workspace.rootPath;
                    if (filename.startsWith(workspaceRootPath)) {
                        path = filename.substring(vscode.workspace.rootPath.length + 1);
                    }
                    let msg = "'" + path + "' is a file type that cannot be debugged by the PowerShell debugger.";
                    vscode.window.showErrorMessage(msg);
                    return;
                }
            }
        }
        // Prevent the Debug Console from opening
        config.internalConsoleOptions = "neverOpen";
        // Create or show the interactive console
        // TODO #367: Check if "newSession" mode is configured
        vscode.commands.executeCommand('PowerShell.ShowSessionConsole', true);
        vscode.commands.executeCommand('vscode.startDebug', config);
    }
}
exports.DebugSessionFeature = DebugSessionFeature;
var GetPSHostProcessesRequest;
(function (GetPSHostProcessesRequest) {
    GetPSHostProcessesRequest.type = { get method() { return 'powerShell/getPSHostProcesses'; } };
})(GetPSHostProcessesRequest || (GetPSHostProcessesRequest = {}));
class PickPSHostProcessFeature {
    constructor() {
        this.command =
            vscode.commands.registerCommand('PowerShell.PickPSHostProcess', () => {
                return this.getLanguageClient()
                    .then(_ => this.pickPSHostProcess(), _ => undefined);
            });
    }
    setLanguageClient(languageClient) {
        this.languageClient = languageClient;
        if (this.waitingForClientToken) {
            this.getLanguageClientResolve(this.languageClient);
            this.clearWaitingToken();
        }
    }
    dispose() {
        this.command.dispose();
    }
    getLanguageClient() {
        if (this.languageClient) {
            return Promise.resolve(this.languageClient);
        }
        else {
            // If PowerShell isn't finished loading yet, show a loading message
            // until the LanguageClient is passed on to us
            this.waitingForClientToken = new vscode.CancellationTokenSource();
            return new Promise((resolve, reject) => {
                this.getLanguageClientResolve = resolve;
                vscode.window
                    .showQuickPick(["Cancel"], { placeHolder: "Attach to PowerShell host process: Please wait, starting PowerShell..." }, this.waitingForClientToken.token)
                    .then(response => {
                    if (response === "Cancel") {
                        this.clearWaitingToken();
                        reject();
                    }
                });
                // Cancel the loading prompt after 60 seconds
                setTimeout(() => {
                    if (this.waitingForClientToken) {
                        this.clearWaitingToken();
                        reject();
                        vscode.window.showErrorMessage("Attach to PowerShell host process: PowerShell session took too long to start.");
                    }
                }, 60000);
            });
        }
    }
    pickPSHostProcess() {
        return this.languageClient.sendRequest(GetPSHostProcessesRequest.type, null).then(hostProcesses => {
            var items = [];
            for (var p in hostProcesses) {
                var windowTitle = "";
                if (hostProcesses[p].mainWindowTitle) {
                    windowTitle = `, Title: ${hostProcesses[p].mainWindowTitle}`;
                }
                items.push({
                    label: hostProcesses[p].processName,
                    description: `PID: ${hostProcesses[p].processId.toString()}${windowTitle}`,
                    pid: hostProcesses[p].processId
                });
            }
            ;
            if (items.length === 0) {
                return Promise.reject("There are no PowerShell host processes to attach to.");
            }
            let options = {
                placeHolder: "Select a PowerShell host process to attach to",
                matchOnDescription: true,
                matchOnDetail: true
            };
            return vscode.window.showQuickPick(items, options).then(item => {
                return item ? item.pid : "";
            });
        });
    }
    clearWaitingToken() {
        if (this.waitingForClientToken) {
            this.waitingForClientToken.dispose();
            this.waitingForClientToken = undefined;
        }
    }
}
exports.PickPSHostProcessFeature = PickPSHostProcessFeature;
//# sourceMappingURL=DebugSession.js.map