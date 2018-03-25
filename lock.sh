#! /bin/sh

if [[ $1 == "--text" ]]; then
  text=$2
else
  text=""
fi

textSize=22
textColor=gray50
colorTheme=cda882

scrot 'lock.png' -q 100 -e 'mv $f ~/.lockShot/'

convert $HOME/.lockShot/lock.png \
        -sepia-tone 54000 \
        -blur 3x3 \
        -swirl 180 \
        $HOME/.lockShot/lock.png

convert -size 400x$textSize xc:none -gravity center \
        -font Inconsolata-Regular -pointsize $textSize -stroke black -strokewidth 4 -annotate +0+0 "$text" \
        -background none -shadow 85x3+0+0 +repage \
        -font Inconsolata-Regular -pointsize $textSize -stroke none -fill $textColor -annotate +0+0 "$text" \
        $HOME/.lockShot/lock.png +swap -gravity center -geometry +0+160 \
        -composite $HOME/.lockShot/lock.png

param=( "-k" \
        "--timecolor=111111ff" \
        "--ignore-empty-password" \
        "--indicator" \
        "--textcolor=ffffff00" \
        "--insidecolor=${colorTheme}ac" \
        "--ringcolor=${colorTheme}ae" \
        "--linecolor=ffffff00" \
        "--keyhlcolor=00000080" \
        "--ringvercolor=00000000" \
        "--separatorcolor=22222260" \
        "--insidevercolor=${colorTheme}ac" \
        "--ringwrongcolor=00000055" \
        "--insidewrongcolor=000000ac" )

i3lock -i $HOME/.lockShot/lock.png "${param[@]}"

