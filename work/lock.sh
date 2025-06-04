#! /bin/bash

text=""
scrShot=0
printHelp=0

helpMenu="Options:
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

textSize=35
textColor=gray70
colorTheme=2a3558
#cda882

res=$(xdpyinfo | grep -oP 'dimensions:\s+\K\S+')

lockShot="$HOME/.lockShot/lockShot.png"
lockBckg="$HOME/.lockShot/lockBckg.png"
lockBckgFinal="$HOME/.lockShot/lockBckgFinal.png"

if [[ $scrShot -eq 1 ]]; then
  scrot 'lockShot.png' -q 100 -e 'mv $f ~/.lockShot/'
  convert $lockShot -blur 30x30 $lockShot
  bckgImg=$lockShot
else
  if [ ! -f "$lockBckg" ]; then
    convert $wallpaper -resize 2880 -background Black \
	    -gravity center -extent $res -blur 30x30 \
	    $lockBckg
  fi
  bckgImg=$lockBckg
fi

txtGeometry="-1920+250"

convert -size 400x$textSize xc:none -gravity center \
        -font Inconsolata-Regular -pointsize $textSize \
        -stroke black -strokewidth 4 -annotate +0+0 "$text" \
        -background none -shadow 85x3+0+0 +repage \
        -font Inconsolata-Regular -pointsize $textSize \
        -stroke none -fill $textColor -annotate +0+0 "$text" \
        $bckgImg +swap -geometry $txtGeometry \
        -composite $lockBckgFinal

param=( "--clock" \
        "--radius=180" \
        "--ring-width=17.0" \
        "--time-size=60" \
        "--date-size=30" \
        "--date-str=%a %Y-%m-%d" \
        "--date-pos=w*.5:h*.5+60" \
        "--time-font=Inconsolata-Bold" \
        "--date-font=Inconsolata-Bold" \
        "--color=000000ff" \
        "--time-color=ffffff99" \
        "--date-color=ffffff99" \
        "--ignore-empty-password" \
        "--indicator" \
        "--layout-color=ffffff00" \
        "--inside-color=${colorTheme}ac" \
        "--ring-color=${colorTheme}ae" \
        "--line-color=ffffff00" \
        "--keyhl-color=00000080" \
        "--ringver-color=00000000" \
        "--separator-color=22222260" \
        "--insidever-color=${colorTheme}ac" \
        "--ringwrong-color=00000055" \
        "--insidewrong-color=000000ac" )

i3lock -i $lockBckgFinal "${param[@]}"

