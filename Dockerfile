# Base image with Dart SDK
ARG DART_VERSION=stable
FROM dart:${DART_VERSION}

# Install Java and Node.js (required for Firebase CLI and emulators)
RUN apt-get update && apt-get install -y default-jdk nodejs npm && rm -rf /var/lib/apt/lists/*

# Install Firebase CLI
RUN npm install -g firebase-tools

# Install Firebase emulators
RUN firebase setup:emulators:database
RUN firebase setup:emulators:firestore
RUN firebase setup:emulators:pubsub
RUN firebase setup:emulators:storage

# Copy firebase.json configuration file
COPY firebase.json /firebase.json

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory for tests
WORKDIR /workspace

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]


