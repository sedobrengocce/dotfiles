!#/bin/bash

action_list="Start Video Capture\nStop Video Capture\nScreenshot a Window\nScreenshot a Window in Clipboard\nScreenshot the Entire Screen\nScreenshot the Entire Screen in Clipboard\nScreenshot a Selected Area\nScreenshot a Selected Area in Clipboard"
action=$(echo -e $action_list | fuzzel --dmenu -i -p "Capture")

if [[ $action == "Start Video Capture" ]]; then
    notify-send "Video Capture" "Started"
    wf-recorder --audio=$(pactl list sources | grep Name | grep output| awk '{ print $2 }' | tail -1 ) -f ~/Videos/mov-$(date +"%Y-%m-%d--%H-%M-%S.mp4")
elif [[ $action == "Stop Video Capture" ]]; then
    notify-send "Video Capture" "Stopped"
    killall wf-recorder
elif [[ $action == "Screenshot a Window" ]]; then
    notify-send "Screenshot" "Window"
    hyprshot -m window -f screenshot-$(date +"%Y-%m-%d--%H-%M-%S.png")
elif [[ $action == "Screenshot a Window in Clipboard" ]]; then
    notify-send "Screenshot" "Window"
    hyprshot -m window --clipboard-only
elif [[ $action == "Screenshot the Entire Screen in Clipboard" ]]; then
    notify-send "Screenshot" "Screen"
    hyprshot -m output --clipboard-only
elif [[ $action == "Screenshot a Selected Area in Clipboard" ]]; then
    notify-send "Screenshot" "Area"
    hyprshot -m region --clipboard-only
elif [[ $action == "Screenshot the Entire Screen" ]]; then
    notify-send "Screenshot" "Screen"
    hyprshot -m output -f screenshot-$(date +"%Y-%m-%d--%H-%M-%S.png")
elif [[ $action == "Screenshot a Selected Area" ]]; then
    notify-send "Screenshot" "Area"
    hyprshot -m region -f screenshot-$(date +"%Y-%m-%d--%H-%M-%S.png")
fi
