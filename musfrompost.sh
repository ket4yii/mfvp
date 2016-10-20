#!/bin/bash
set -e

#=======Process args======================

if [ -z $1 ]
then
  echo "[Error]: Please, pass the first argument"
  exit 1
else
  post_id=$1
fi

if [ -z $2 ] 
then
  folder="."
else
  echo "else"
  folder=$(echo $2 | sed 's/\///')
fi

#========================================

api_url="https://api.vk.com/method/wall.getById?posts=$post_id&extended=0&v=5.52"

audios_json=$(curl $api_url 2> /dev/null | jq '.response[0].copy_history[0] // .response[0] | .attachments | map(select(.type == "audio") | .audio | {artist, title, url})')
len=$(echo $audios_json | jq 'length')
((len--))
echo $len;

for i in `seq 0 $len`; do
    title=$(echo $audios_json | jq -r ".[$i].title")
    artist=$(echo $audios_json | jq -r ".[$i].artist")
    url=$(echo $audios_json | jq -r ".[$i].url")
    
    echo "$artist -- $title"
    wget -q --show-progress -O "$folder/$artist-$title" "$url" || echo "Can't download this track. Check this link manually: $url"
done

