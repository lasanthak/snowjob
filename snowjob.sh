#!/bin/zsh

LINES=$(tput lines)
COLUMNS=$(tput cols)

declare -A snowflakes
declare -A lastflakes
declare -A shapes

function move_flake() {
    i="$1"

    if [[ "${snowflakes[$i]}" == "" || "${snowflakes[$i]}" == "$LINES" ]]; then
        snowflakes[$i]=0
    else
        if [[ "${lastflakes[$i]}" != "" ]]; then
            printf "\033[%s;%sH \033[1;1H " ${lastflakes[$i]} $i
        fi
    fi

    printf "\033[%s;%sH${shapes[$i]}\033[1;1H" ${snowflakes[$i]} $i

    lastflakes[$i]=${snowflakes[$i]}
    snowflakes[$i]=$((${snowflakes[$i]} + 1))
}

clear

for (( x = 0; x <= $COLUMNS; x++)); do
    shapes[$x]="\u274$[($RANDOM%6)+3]"
done

while :
do
    move_flake "$(($RANDOM % $COLUMNS))"
    sleep 0.02

    move_flake "$(($RANDOM % $COLUMNS))"
    sleep 0.02

    for (( x = 0; x < $COLUMNS; x++)); do
        if [[ "${lastflakes[$x]}" != "" ]]; then
            move_flake "$x"
        fi
    done
    sleep 0.05
done
