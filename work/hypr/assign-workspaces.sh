#!/bin/bash

get_monitor_desc_by_serial() {
    local serial_suffix="$1"
    hyprctl monitors -j | jq --raw-output \
        ".[] | select(.description | endswith(\"$serial_suffix\")) .description"
}

get_monitor_name_by_serial() {
    local serial_suffix="$1"
    hyprctl monitors -j | jq --raw-output \
        ".[] | select(.description | endswith(\"$serial_suffix\")) .name"
}

for attempt in $(seq 1 20); do
    LEFT_DESC=$(get_monitor_desc_by_serial "H4ZT700166")
    RIGHT_DESC=$(get_monitor_desc_by_serial "H4ZT700149")
    LEFT=$(get_monitor_name_by_serial "H4ZT700166")
    RIGHT=$(get_monitor_name_by_serial "H4ZT700149")
    if [ -n "$LEFT" ] && [ -n "$RIGHT" ]; then
        break
    fi
    sleep 0.5
done

cat > ~/.config/hypr/my_workspaces.conf <<EOF
workspace=1,monitor:desc:$LEFT_DESC,default:true
workspace=2,monitor:desc:$LEFT_DESC
workspace=3,monitor:desc:$LEFT_DESC
workspace=4,monitor:desc:$LEFT_DESC
workspace=5,monitor:desc:$LEFT_DESC
workspace=6,monitor:desc:$RIGHT_DESC,default:true
workspace=7,monitor:desc:$RIGHT_DESC
workspace=8,monitor:desc:$RIGHT_DESC
workspace=9,monitor:desc:$RIGHT_DESC
workspace=10,monitor:desc:$RIGHT_DESC
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
