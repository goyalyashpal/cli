local output=$(cat)

local regex="make: Nothing to be done for '(.*)'"
if [[ "$output" =~ $regex ]]; then

    # If target is a directory
    if [[ -d "$1" ]]; then
        echo "Cannot run ${bold}make${normal} on a directory. Did you mean to ${bold}cd ${1}${normal} first?"
        return
    fi

    # If target ends with .c
    if [[ "$1" == *?.c ]]; then
        base="${1%.c}"
        if [[ -n "$base" && ! -d "$base" ]]; then
            echo "Did you mean to ${bold}make ${base}${normal}?"
            return
        fi
    fi

fi

local regex="No rule to make target '(.*)'"
if [[ "$output" =~ $regex ]]; then

    # If no .c file for target
    local c="$1.c"
    if [[ ! -f "$c" ]]; then

        # Search recursively for .c file
        paths=$(find * -name "$c" 2> /dev/null)
        lines=$(echo "$paths" | grep -c .)
        echo -n "There isn't a file called ${bold}${c}${normal} in your current directory."
        if [[ "$lines" -eq 1 ]]; then # If unambiguous
            d=$(dirname "$paths")
            echo " Did you mean to ${bold}cd ${d}${normal} first?"
        else
            echo
        fi
        return
    fi
fi
