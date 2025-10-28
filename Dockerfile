# Base image with Dart SDK
FROM dart:latest

# Install Java (required for Firebase emulators)
RUN apt-get update && apt-get install -y openjdk-17-jdk
RUN java -version

# Install Node via NVM (required for Firebase CLI)
ENV NODE_VERSION=20.10.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

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


