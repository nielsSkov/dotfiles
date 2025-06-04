#!/bin/bash

CACHE="$HOME/.dmenu_cache_recent"

MOST_USED=`sort $CACHE | uniq -c | sort -rn | colrm 1 8`
RUN=`(echo "$MOST_USED"; dmenu_path | grep -vxF "$MOST_USED") | dmenu -fn 'Inconsolata\-g-14' "$@"` &&
(echo $RUN; head -n 99 $CACHE) > $CACHE.$$ && mv $CACHE.$$ $CACHE
case $RUN in
    *) exec $RUN;;
esac
