#! /bin/bash

if [ -n "${KEYCHAIN_PATH:-}" ] && [ -f "$KEYCHAIN_PATH" ]; then
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
fi

[ -z "${GHA_LOCAL_PREAMBLE:-}" ] || "$GHA_LOCAL_PREAMBLE"
