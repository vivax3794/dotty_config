#!/bin/sh
hyprctl activewindow | rg "class.*kitty" || exec kitty
