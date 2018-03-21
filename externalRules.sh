#! /bin/sh

#container for matlab nodes
#nodeNR:    0 1 2 3 4 5 6 7
container=( 0 0 0 0 0 0 0 0 )

#listen for new and terminated nodes (windows)
(bspc subscribe node_manage & bspc subscribe node_unmanage) | while read line; do  
  nodeState=$(echo $line | cut -d' ' -f1)
  nodeID=$(echo $line | cut -d' ' -f4)

  #get WM_NAME for node
  if [[ $nodeState == node_manage ]]; then
    nodeName=$(xprop -id $nodeID WM_NAME)
  fi

  #evenly tile matlab/simulink plots on desktop 10 (=9)
  if [[ $nodeName == *Scope* ]] || [[ $nodeName == *Figure* ]]; then  
  
    if [[ $nodeState == node_unmanage ]]; then
  
      #echo $nodeState
      for i in {0..7}; do
        if [[ $nodeID == ${container[i]} ]]; then
          container[i]=0
        fi
      done
 
     #echo ${container[*]}
  
    elif [[ $nodeState == node_manage ]]; then
  
      #echo $nodeState
      for nodeNR in {0..7}; do
        if [[ ${container[nodeNR]} == 0 ]]; then
          container[nodeNR]="$nodeID"
          break
        fi
      done
      
      case "$nodeNR" in
        0)  stem=4; dir=north ;;
        1)  stem=0; dir=south ;;
        2)  stem=0; dir=east  ;;
        3)  stem=1; dir=east  ;;
        4)  stem=0; dir=south ;;
        5)  stem=1; dir=south ;;
        6)  stem=2; dir=south ;;
        7)  stem=3; dir=south ;;
      esac
  
      nodeCount=$(bspc query --nodes --desktop 10 --node .window | wc -l)
  
      if [[ $nodeCount == 0 ]]; then
        bspc node ${container[$nodeNR]} --to-desktop 10
      elif [[ $nodeCount < 8 ]]; then
        bspc node ${container[$stem]} --presel-dir $dir
        bspc node ${container[$nodeNR]} --to-node ${container[$stem]}
      fi
      #echo ${container[*]}
    fi
  fi
done
