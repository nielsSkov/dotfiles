#! /bin/sh

text=""
scrShot=0
printHelp=0

options="Options:
    -h, --help       Shows this help menu.
    
    -t, --text       Adds text string to the screen lock
    
    -s, --scrShot    Decide to use screenshot (1) or wallpaper (0)
                     as lock sccreen background (default: 0)"

while true ; do
    case "$1" in
        -h|--help) echo "$helpMenu"; exit 1 ;;
        -t|--text)
          case "$2" in
            ""|-s|--scrShot) printf "\nOption missing for $1\n" ; printHelp=1  ; shift ;;
                          *) text="$2" ; shift 2 ;;
          esac ;;
        -s|--scrShot)
          case "$2" in
            (*[!0-1]*) printf "\nInvalid input \"$2\" for $1\n" ; printHelp=1 ; shift 2 ;;
                    *) scrShot="$2" ; shift 2 ;;
          esac ;;
        "") break ;;
        *) printf "\nUnknown option: $1\n" ; printHelp=1 ; break ;;
    esac
done

if [[ printHelp -eq 1 ]] ; then
  printf "\nUsage: %s [options]\n\n%s\n\n" "$(basename "$0")" "$options"
  exit 1
fi

textSize=22
textColor=gray50
colorTheme=cda882

#res=$(xdpyinfo | grep -oP 'dimensions:\s+\K\S+')
res="1600x1000"

bckgImg="$HOME/.lockShot/lock.png"

if [[ $scrShot -eq 1 ]]; then
  scrot 'lock.png' -q 100 -e 'mv $f ~/.lockShot/'
else
  convert $wallpaper -resize $res $bckgImg
fi

convert $bckgImg \
        -sepia-tone 54000 \
        -blur 3x3 \
        -swirl 180 \
        $bckgImg

convert -size 400x$textSize xc:none -gravity center \
        -font Inconsolata-Regular -pointsize $textSize \
        -stroke black -strokewidth 4 -annotate +0+0 "$text" \
        -background none -shadow 85x3+0+0 +repage \
        -font Inconsolata-Regular -pointsize $textSize \
        -stroke none -fill $textColor -annotate +0+0 "$text" \
        $bckgImg +swap -gravity northeast -geometry +595+600 \
        -composite $bckgImg

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

i3lock -i $bckgImg "${param[@]}"

