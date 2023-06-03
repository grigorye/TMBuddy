#! /bin/bash

lckfile=/tmp/brew.lock

while ! shlock -f "$lckfile" -p $$; do
    sleep 1
done
trap 'rm -f "$lckfile"' EXIT
