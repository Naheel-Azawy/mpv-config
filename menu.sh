#!/bin/sh

LIST='Information
Open with
Delete
Copy file name
Copy image
Rotate auto
Rotate 270
Rotate 90
Rotate 180
Flip horizontally
Flip vertically
Set as wallpaper
Set as temporary wallpaper
Drag and drop'

file="$2"
files="$file" # TODO: allow multiple files
files_len=$(echo "$files" | wc -l)

choice="$1"
if [ "$choice" = menu ]; then
    choice=$(echo "$LIST" | menus-face -i -l 20)
fi

case "$choice" in
    "Information")
        echo "$files" | while read -r f; do
            txt="${f%%.*}.txt"
            if [ -f "$txt" ]; then
                theterm sh -c "(cat '$txt' && echo && exiftool '$f') | less" &
            else
                theterm "exiftool '$f' | less" &
            fi 2>/dev/null
        done;;
    "Open with")
        open --ask "$file" &;;
    "Copy file name")
        echo "$files" | xclip -in -selection clipboard;;
    "Copy image")
        xclip -selection clipboard -target image/png "$file";;
    "Set as wallpaper")
        ndg wallpaper "$file";;
    "Set as temporary wallpaper")
        feh --bg-fill "$file";;
    "Duplicate")
        mpv "$file" &;;
    "Rotate auto")
        echo "$files" | while read -r f; do convert "$f" -auto-orient "$f"; done;;
    "Rotate 270")
        echo "$files" | while read -r f; do convert "$f" -rotate 270 "$f"; done;;
    "Rotate 90")
        echo "$files" | while read -r f; do convert "$f" -rotate  90 "$f"; done;;
    "Rotate 180")
        echo "$files" | while read -r f; do convert "$f" -rotate 180 "$f"; done;;
    "Flip horizontally")
        echo "$files" | while read -r f; do convert "$f" -flop "$f"; done;;
    "Flip vertically")
        echo "$files" | while read -r f; do convert "$f" -flip "$f"; done;;
    "Delete")
        if [ "$files_len" = 1 ]; then
            P=$(basename "$file" | head -c 40)
        else
            P="$files_len files"
        fi
        R=$(printf "Trash\nDelete permanently\nCancel" |
                menus-face -p "Delete $P?" -i -sb red -nf red)
        case "$R" in
            Trash)   echo "$files" | while read -r f; do gio trash "$f" || trash-put "$f"; done;;
            Delete*) echo "$files" | while read -r f; do rm -f "$f";                       done;;
        esac ;;
    "Drag and drop" | "d")
        echo "$files" | xargs dragon -a -x ;;
esac
