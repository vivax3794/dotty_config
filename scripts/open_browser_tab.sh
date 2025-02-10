#!/bin/bash

last_search_file="/tmp/last_search"

focus_window() {
    local match="$1"
    while ! hyprctl clients | rg "$match"; do
        sleep 0.1
    done
    hyprctl dispatch focuswindow $match
}

expand_bangs() {
    local query="$1"
    query=$(echo "$query" | sed -E \
        -e 's/^!d /!docsrs /' \
        -e 's/^!r /!rust /' \
        -e 's/^!p /!py /' \
    )
    echo "$query"
}

custom_bangs() {
    local query="$1"

    if [[ "$query" =~ ^!docsrs[[:space:]]+([a-zA-Z0-9_-]+)[[:space:]]+(.+)$ ]]; then
        crate="${BASH_REMATCH[1]}"
        item="${BASH_REMATCH[2]}"
        echo "https://docs.rs/${crate}/latest/?search=${item}"
    else 
        echo "https://duckduckgo.com/?q=${query}"
    fi
}

normal_search() {
    search=$(cat "$last_search_file" | tofi --require-match=false --prompt "search: ")
    echo "$search\n" > "$last_search_file"

    search=$(expand_bangs "$search")
    search=$(custom_bangs "$search")
    floorp "${search}"
    focus_window "class:floorp"
}

normal_search
