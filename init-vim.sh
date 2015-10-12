#!/bin/bash
cd /home/developer
echo "let g:pathogen_disabled = ['vim-airline']" > .vimrc
echo "execute pathogen#infect('/ext/bundle/{}')" >> .vimrc
mkdir -p /home/developer/.vim_runtime/temp_dirs
cat .vimrc~ >> .vimrc
rm .vimrc~
