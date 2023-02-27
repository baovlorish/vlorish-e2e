#!/bin/bash
FILE=$1
if test -f "$FILE"; then
    echo -e "$FILE exists."
    if [ -s "$FILE" ]; then
        # The file is not-empty.
        echo -e "$FILE contains test filed: "
        cat $FILE
        exit 1
    else
        # The file is empty.
        echo -e "$FILE is empty. Please re-check the test"
fi
fi
