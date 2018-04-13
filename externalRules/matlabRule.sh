#! /bin/sh

#listen for new and terminated nodes (windows)
bspc subscribe node_add | while read line; do

  nodeID=$(echo $line | cut -d' ' -f5)
  nodeName=$(xprop -id $nodeID WM_NAME)

  #evenly tile matlab/simulink plots on desktop 10 (=9)
  if [[ $nodeName == *Scope* ]] || [[ $nodeName == *Figure* ]]; then

    openNodes=($(bspc query -N -d 10 -n .window))

    nrOfNodes=${#openNodes[@]}

    if [ $nrOfNodes -ge 2 ]; then
      #determines largest node and its longest direction (with or hight)
      oldMax=0
      oldYpos=0
      for i in $(seq 0 $(($nrOfNodes-1))); do

        width=$(wattr w ${openNodes[i]})
        higth=$(wattr h ${openNodes[i]})
        yPos=$(wattr y ${openNodes[i]})

        [ "$width" -gt "$higth" ] && max=$width direc=east || max=$higth direc=south

        if [ \( $max -ge $oldMax \) -a \( $yPos -ge $oldYpos \) ]; then
          targetNode=${openNodes[i]}
          targetDirec=$direc
          oldMax=$max
          oldYpos=$yPos
        fi
      done

      bspc node $targetNode --presel-dir $targetDirec
      bspc node $nodeID --to-node $targetNode
    else
      bspc node $nodeID --to-desktop 10
    fi
  fi
done
