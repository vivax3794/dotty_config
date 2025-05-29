#!/bin/bash

start_mpvpaper() {
    mpvpaper -s -o "no-audio loop hwdec=auto vf=crop=w=3440:h=1440 gpu-api=vulkan" DP-1 ~/dotty_config/wallpaper/wide &
    mpvpaper -s -o "no-audio loop hwdec=auto vf=crop=w=1080:h=1920 gpu-api=vulkan" HDMI-A-1 ~/dotty_config/wallpaper/vertical &
}

kill_mpvpaper() {
    killall mpvpaper
}

while true; do
    start_mpvpaper
    sleep 1800
    kill_mpvpaper
    sleep 1
done
