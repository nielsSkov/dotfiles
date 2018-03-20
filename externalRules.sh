#! /bin/sh

i=0

#listen for new nodes (windows)
bspc subscribe node_manage | while read line; do  
  
  nodeID=$(echo $line | cut -d' ' -f4)

  #reset if the first plot node is gone
  if [[ $i != 0 ]]; then
    test=$(bspc query -N |grep ${nodeIDplot[1]})
    if [[ $test != ${nodeIDplot[1]} ]]; then
      i=0
    fi
  fi
  
  #obtain bspwm node id
  nodeID=$(echo $line | cut -d' ' -f4)
  
  #get WM_NAME for node
  nodeName=$(xprop -id $nodeID WM_NAME)

  #evenly tile matlab/simulink plots on desktop 10 (=9) 
  if [[ $nodeName == *Scope* ]] || [[ $nodeName == *Figure* ]]; then
    ((i++))
    nodeIDplot[$i]=$nodeID
    if [ $i == 1 ]; then
      bspc node ${nodeIDplot[1]} --to-desktop 10
    elif [ $i == 2 ]; then
      bspc node ${nodeIDplot[1]} --presel-dir south
      bspc node ${nodeIDplot[2]} --to-node ${nodeIDplot[1]}
    elif [ $i == 3 ]; then
      bspc node ${nodeIDplot[1]} --presel-dir east
      bspc node ${nodeIDplot[3]} --to-node ${nodeIDplot[1]}
    elif [ $i == 4 ]; then
      bspc node ${nodeIDplot[2]} --presel-dir east
      bspc node ${nodeIDplot[4]} --to-node ${nodeIDplot[2]}
    elif [ $i == 5 ]; then
      bspc node ${nodeIDplot[1]} --presel-dir north
      bspc node ${nodeIDplot[5]} --to-node ${nodeIDplot[1]}
    elif [ $i == 6 ]; then
      bspc node ${nodeIDplot[2]} --presel-dir north
      bspc node ${nodeIDplot[6]} --to-node ${nodeIDplot[2]}
    elif [ $i == 7 ]; then
      bspc node ${nodeIDplot[3]} --presel-dir north
      bspc node ${nodeIDplot[7]} --to-node ${nodeIDplot[3]}
    elif [ $i == 8 ]; then
      bspc node ${nodeIDplot[4]} --presel-dir north
      bspc node ${nodeIDplot[8]} --to-node ${nodeIDplot[4]}
    fi
  fi

done
