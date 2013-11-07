#!/bin/sh

ln -sf "$PWD"/bashfuns.bash $HOME/.bashfuns
echo "source $HOME/.bashfuns" >> $HOME/.bashrc
