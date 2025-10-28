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

# Otherwise, execute the command directly without wrapping in emulators:exec
# This allows test scripts to manage their own emulator lifecycle
echo "Executing: $@"
exec "$@"
