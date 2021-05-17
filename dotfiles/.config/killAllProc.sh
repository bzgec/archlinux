#!/bin/sh

if [ $# -eq 0 ]
then
    echo "Supply process/script to kill"
    exit 1
fi

# Grep PID that also has an argument equal to $1 (this is usefull for python scripts)
# and also get the PID of the last one started - that is this script PID
thisScriptId=$(pgrep -n -f "$1")
#echo $thisScriptId

# Grep all PIDs that match the $1 (also match for parameters)
procIds=$(pgrep -f "$1")
#echo $procIds

for procId in $procIds
do
    # Check that this script doesn't kill itself
    if [ "$thisScriptId" != "$procId" ]
    then
        echo "Killing PID: $procId"
        kill "$procId"
    fi
done

exit 0
