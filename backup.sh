#!/bin/bash

#backup zshrc
cp ~/.zshrc ~/git/dotfiles/
#backup vimrc
cp ~/.vimrc ~/git/dotfiles/
#backup visual studio code
cp -r ~/.vscode ~/git/dotfiles/

#merge backed up configs to master branch
date=date
cd ~/git/dotfiles
git add .
git commit -a -m "backed up on"+$date
git push