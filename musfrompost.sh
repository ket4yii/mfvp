#!/bin/bash
set -e
post_id=$1
folder=$2

api_url="https://api.vk.com/method/wall.getById?posts=$post_id&extended=0&v=5.52"

audios_json=$(curl $api_url 2> /dev/null | jq '.response[0].copy_history[0].attachments | map(select(.type == "audio") | .audio | {artist, title, url})')
len=$(echo $audios_json | jq 'length')
((len--))

for i in `seq 0 $len`; do
    title=$(echo $audios_json | jq -r ".[$i].title")
    artist=$(echo $audios_json | jq -r ".[$i].artist") 
    url=$(echo $audios_json | jq -r ".[$i].url")
    
    echo $artist -- $title
    wget -q --show-progress -O "$2$artist-$title" "$url"
done
