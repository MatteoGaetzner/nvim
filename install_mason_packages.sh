#!/bin/bash

nvim --headless -c "MasonInstall $(cat ~/.config/nvim/mason_packages.txt | tr '\n' ' ')" -c qall
