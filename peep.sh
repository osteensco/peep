#!/usr/bin/env bash



# peep is a commmand that lets you look through your windows terminal 
# requires jq

# TODO
#   - install script
#   - ensure works on both powershell and wsl linux

peep_max_opacity=100
peep_min_opacity=80
peep_default_background="desktopWallpaper"
peep_terminal_settings=$(find /mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json 2>/dev/null | head -n1)

peep() {

    if ! command -v jq &> /dev/null; then
        echo "jq was not found. jq is a dependecy of peep, please install jq."
        return 1
    fi

    if [[ $(jq --arg guid "$WT_PROFILE_ID" -r '.profiles.list[] | select(.guid == $guid) | .opacity' $peep_terminal_settings) -gt $peep_min_opacity ]]; then
        jq --arg guid "$WT_PROFILE_ID" --argjson opacity "$peep_min_opacity" \
        '(.profiles.list[] | select(.guid == $guid)) |= (.opacity = $opacity | del(.backgroundImage))' \
        $peep_terminal_settings > tmp.json && mv tmp.json $peep_terminal_settings
    else 
        jq --arg guid "$WT_PROFILE_ID" --argjson opacity "$peep_max_opacity" --arg background "$peep_default_background" \
        '(.profiles.list[] | select(.guid == $guid)) |= (.opacity = $opacity | .backgroundImage = $background)' \
        $peep_terminal_settings > tmp.json && mv tmp.json $peep_terminal_settings 
    fi

}





