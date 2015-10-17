#!/bin/bash
mkdir -p /home/developer/.vim_runtime/temp_dirs
cd /home/developer
cat .vimrc~ >> .vimrc
rm .vimrc~
