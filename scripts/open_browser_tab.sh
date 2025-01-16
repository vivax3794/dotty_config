#!/bin/bash

# Extract class and title of the active window
window_class=$(hyprctl activewindow | rg -o "class.*" | awk '{print $2}')
window_title=$(hyprctl activewindow | rg -o "title.*" | cut -d'"' -f2)

wait_for_window() {
    local match="$1"
    while ! hyprctl clients | rg "$match"; do
        sleep 0.1
    done
}

if [[ "$window_class" == "floorp" ]]; then
    floorp https://duckduckgo.com
elif [[ "$window_class" == "kitty" ]]; then
    if [[ "$window_title" =~ "nvim" ]]; then
        floorp https://docs.rs/
        wait_for_window "title:.*Docs.rs.*"
        hyprctl dispatch focuswindow "title:.*Docs.rs.*"
    elif [[ "$window_title" =~ "lazygit" ]]; then
        floorp https://github.com/
        wait_for_window "title:.*GitHub.*"
        hyprctl dispatch focuswindow "title:.*GitHub.*"
    else
        floorp
    fi
elif [[ "$window_class" == "obs" ]]; then
    floorp https://dashboard.twitch.tv/u/vivax3794/stream-manager
    wait_for_window "title:.*Twitch.*"
    hyprctl dispatch focuswindow "title:.*Twitch.*"
else
    floorp
fi

