#!/usr/bin/env bash

if niri msg focused-window | rg ".*kitty.*" >/dev/null; then
    wtype -M ctrl t -m ctrl
else
  exec kitty
fi

