#!/bin/bash

get_monitor_name_by_serial() {
    local serial_suffix="$1"
    hyprctl monitors -j | jq --raw-output \
        ".[] | select(.description | endswith(\"$serial_suffix\")) .name"
}

for attempt in $(seq 1 20); do
    LEFT=$(get_monitor_name_by_serial "H4ZT700166")
    RIGHT=$(get_monitor_name_by_serial "H4ZT700149")
    if [ -n "$LEFT" ] && [ -n "$RIGHT" ]; then
        break
    fi
    sleep 0.5
done

cat > ~/.config/hypr/my_workspaces.conf <<EOF
workspace=1,monitor:$LEFT,default:true
workspace=2,monitor:$LEFT
workspace=3,monitor:$LEFT
workspace=4,monitor:$LEFT
workspace=5,monitor:$LEFT
workspace=6,monitor:$RIGHT,default:true
workspace=7,monitor:$RIGHT
workspace=8,monitor:$RIGHT
workspace=9,monitor:$RIGHT
workspace=10,monitor:$RIGHT
EOF

hyprctl reload
sleep 0.5

for i in {1..5}; do
    hyprctl dispatch moveworkspacetomonitor "$i" "$LEFT"
done

for i in {6..10}; do
    hyprctl dispatch moveworkspacetomonitor "$i" "$RIGHT"
done

hyprctl dispatch workspace 1
