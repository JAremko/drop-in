#!/bin/bash
mkdir -p $UHOME/.vim_runtime/temp_dirs
cd $UHOME
cat .vimrc~ >> .vimrc
