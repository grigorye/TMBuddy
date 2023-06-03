#! /bin/bash

lckfile=/tmp/brew.lock

while ! shlock -f "$lckfile" -p $$; do
    sleep 1
done
trap 'rm -f "$lckfile"' EXIT

brew=$(command -v brew)

if [ "$brew" == "/opt/homebrew/bin/brew" ]; then
    # Workaround user not being the owner of Homebrew (particularly, being an extra user on orchard-controlled VM).
    id=$(id -u)
    brew_owner_id=$(stat -f '%u' "$brew")

    if [ "$id" != "$brew_owner_id" ]; then
        brew() {
            sudo --set-home --user=admin command brew "$@"
        }
    fi
fi
