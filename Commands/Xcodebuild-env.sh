#! /bin/bash

set -x
set -euo pipefail

stderr-filter() {
    grep -v '^objc\[.*\]'
}

xcodebuild() {
    (command xcodebuild "$@" 2>&1 >&3 3>&- | stderr-filter >&2 3>&-) 3>&1        
}

xcpretty() {
    if [ "${XCPRETTY_ENABLED:-}" != "NO" ] && which xcpretty > /dev/null; then
        command xcpretty
    else
        grep -v '^ '
    fi
}