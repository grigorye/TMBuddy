#! /bin/bash

if [ -f "$KEYCHAIN_PATH" ]; then
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
fi
