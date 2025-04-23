#!/bin/bash

# Function to start mpvpaper instances
start_mpvpaper() {
    mpvpaper -s -o "no-audio loop hwdec=auto vf=crop=w=3440:h=1440 gpu-api=vulkan" DP-1 ~/dotty_config/wallpaper/wide &
    WIDE_PID=$!
    
    mpvpaper -s -o "no-audio loop hwdec=auto vf=crop=w=1080:h=1920 gpu-api=vulkan" HDMI-A-1 ~/dotty_config/wallpaper/vertical &
    VERTICAL_PID=$!
    
    # Store PIDs for later termination
    echo "$WIDE_PID $VERTICAL_PID" > /tmp/mpvpaper_pids
}

# Function to kill mpvpaper instances
kill_mpvpaper() {
    if [ -f /tmp/mpvpaper_pids ]; then
        read WIDE_PID VERTICAL_PID < /tmp/mpvpaper_pids
        kill $WIDE_PID $VERTICAL_PID 2>/dev/null
        rm /tmp/mpvpaper_pids
    else
        # Fallback: kill all mpvpaper processes if PID file doesn't exist
        pkill mpvpaper
    fi
}

# Main loop to restart every hour
while true; do
    # Start mpvpaper instances
    start_mpvpaper
    
    # Wait for 1 hour (3600 seconds)
    sleep 1800
    
    # Kill the instances
    kill_mpvpaper
    
    # Small delay before restarting
    sleep 1
done
