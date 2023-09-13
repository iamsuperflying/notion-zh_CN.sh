#!/bin/bash

NOTION="/Applications/Notion.app"
URL="https://api.github.com/repos/Reamd7/notion-zh_CN/releases/latest"
NOTION_RENDERER="$NOTION/Contents/Resources/app/renderer"
NOTION_ZH_CN_JS="notion-zh_CN.js"
REQUIRE="require('./notion-zh_CN');"

# Check if Notion app exists
if [ ! -d $NOTION ]; then
    echo "Notion app not found."
    exit 1
fi

# Get download url of latest release
download_url=$(curl --silent "$URL" | awk -F'"browser_download_url": "' '/"browser_download_url":/ {print $2}' | sed 's/"//g' | head -n 1)

echo $download_url

# Download notion-zh_CN.js to renderer
curl -L "$download_url" -o "$NOTION_RENDERER/$NOTION_ZH_CN_JS"

# Check if "require('./notion-zh_CN')" already exists in the end of preload.js
if ! grep -q $REQUIRE $NOTION_RENDERER/preload.js; then
    echo "\\n$REQUIRE" >> $NOTION_RENDERER/preload.js
fi

# Restart Notion app
osascript -e 'quit app "Notion"'
open -a "Notion"
