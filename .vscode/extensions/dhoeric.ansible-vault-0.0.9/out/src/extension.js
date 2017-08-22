'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
const tilde = require("tilde-expansion");
const tmp = require("tmp");
const child_process = require("child_process");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    var toggleEncrypt = () => __awaiter(this, void 0, void 0, function* () {
        let config = vscode.workspace.getConfiguration('ansibleVault');
        let editor = vscode.window.activeTextEditor;
        if (!editor) {
            return;
        }
        // Get password
        let keypath = "";
        let pass = "";
        let tmpFileObj = '';
        if (config.keyfile != "") {
            let keyfile = config.keyfile.trim("/");
            keyfile = keyfile.trim("/");
            yield tilde(keyfile, (s) => { keypath = s; });
        }
        if (keypath == "") {
            pass = config.keypass;
            if (pass == "") {
                yield vscode.window.showInputBox({ prompt: "Enter the ansible-vault keypass: " }).then((val) => {
                    pass = val;
                });
            }
            keypath = tmp.tmpNameSync();
            let cmd = `touch ${keypath} && echo "${pass}" > ${keypath}`;
            exec(cmd);
        }
        // Go encrypt / decrypt
        let doc = editor.document;
        let fileType = yield checkFileType(doc.fileName);
        if (fileType == "plaintext") {
            encrypt(doc.fileName, keypath, config);
        }
        else if (fileType == "encrypted") {
            decrypt(doc.fileName, keypath, config);
        }
        if (pass != "" && keypath != "") {
            exec(`rm -f ${keypath}`);
        }
    });
    let disposable = vscode.commands.registerCommand('extension.ansibleVault', toggleEncrypt);
    context.subscriptions.push(disposable);
}
exports.activate = activate;
// Check YAML file content
// start with '$ANSIBLE_VAULT' -> 'decrypt'
// others -> 'encrypt'
let checkFileType = (f) => __awaiter(this, void 0, void 0, function* () {
    let content = '';
    yield vscode.workspace.openTextDocument(f).then((document) => {
        content = document.getText();
    });
    if (content.indexOf("$ANSIBLE_VAULT") == 0) {
        return 'encrypted';
    }
    return 'plaintext';
});
let encrypt = (f, pass, config) => {
    console.log("Encrypt: " + f);
    let cmd = `${config.executable} encrypt "${f}" --vault-password-file="${pass}"`;
    exec(cmd);
    vscode.window.showInformationMessage(`${f} encrypted`);
};
let decrypt = (f, pass, config) => {
    console.log("Decrypt: " + f);
    let cmd = `${config.executable} decrypt "${f}" --vault-password-file="${pass}"`;
    exec(cmd);
    vscode.window.showInformationMessage(`${f} decrypted`);
};
let exec = (cmd) => {
    console.log(`> ${cmd}`);
    let stdout = child_process.execSync(cmd, {});
};
// this method is called when your extension is deactivated
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map