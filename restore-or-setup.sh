#!/bin/bash

#restore zshell config from repo
cp ~/git/dotfiles/.zshrc ~/
#restore vim config from repo
cp ~/git/dotfiles/.vimrc ~/
#restore visual studio code config from repo
cp -r ~/git/dotfiles/.vscode ~/


#apply .gitignore_global
git config --global core.excludesfile ~/.gitignore_global