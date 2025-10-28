#!/bin/bash
set -e

# Default working directory
WORKDIR=${WORKDIR:-/workspace}

# Change to working directory if it exists
if [ -d "$WORKDIR" ]; then
    cd "$WORKDIR"
fi

# If no arguments provided, start an interactive shell
if [ $# -eq 0 ]; then
    echo "Starting interactive shell. Firebase emulators are available."
    echo "Run: firebase emulators:start --only firestore"
    echo "Or: firebase emulators:exec --only firestore 'dart test'"
    exec /bin/bash
fi

# If the first argument is a firebase command, execute it directly
if [[ "$1" == "firebase" ]]; then
    exec "$@"
fi

# Otherwise, assume it's a test command and run with firebase emulators:exec
echo "Starting Firebase emulators and executing: $@"
exec firebase emulators:exec --only firestore --project demo-test "$@"
