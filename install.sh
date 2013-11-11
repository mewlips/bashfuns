#!/usr/bin/env bash

ln -sf "$PWD"/bashfuns.sh $HOME/.bashfuns
echo "source $HOME/.bashfuns" >> $HOME/.bashrc
