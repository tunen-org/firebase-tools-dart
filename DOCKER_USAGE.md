# Firebase Tools Dart - Docker Usage Examples

## Build the Image
```bash
docker build -t firebase-dart-test .
```

Or build with a specific Dart version:
```bash
docker build --build-arg DART_VERSION=3.5.0 -t firebase-dart-test .
```

## Pulling Pre-built Images

### Use Latest
```bash
docker pull ghcr.io/tunen-org/firebase-tools-dart:latest
```

### Use Specific Dart SDK Version
```bash
docker pull ghcr.io/tunen-org/firebase-tools-dart:3.5.0
# or
docker pull ghcr.io/tunen-org/firebase-tools-dart:dart-3.5.0
```

## Usage Examples

### 1. Run Tests (Recommended for CI/CD)
The simplest way - just pass your test command:
```bash
docker run -v $(pwd):/workspace ghcr.io/tunen-org/firebase-tools-dart:latest "dart test"
```

### 2. Run with Specific Dart Version
```bash
docker run -v $(pwd):/workspace ghcr.io/tunen-org/firebase-tools-dart:3.5.0 "dart test"
```

### 3. Run Specific Test Files
```bash
docker run -v $(pwd):/workspace firebase-dart-test "dart test test/integration/firestore_test.dart"
```

### 3. Run with Custom Firebase Emulator Options
```bash
docker run -v $(pwd):/workspace firebase-dart-test firebase emulators:exec --only firestore,storage "dart test"
```

### 4. Start Emulators Manually (for Development)
```bash
docker run -it -v $(pwd):/workspace -p 8080:8080 -p 4000:4000 firebase-dart-test firebase emulators:start --only firestore
```

### 5. Interactive Shell (for Debugging)
```bash
docker run -it -v $(pwd):/workspace firebase-dart-test
# Inside container:
# firebase emulators:start --only firestore
# or
# dart test
```

## CI/CD Integration Examples

### GitHub Actions
```yaml
name: Integration Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Integration Tests
        run: docker run -v ${{ github.workspace }}:/workspace ghcr.io/tunen-org/firebase-tools-dart:latest "dart test"
```

### GitHub Actions with Specific Dart Version
```yaml
name: Integration Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        dart-version: ['3.5.0', 'latest']
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Integration Tests (Dart ${{ matrix.dart-version }})
        run: docker run -v ${{ github.workspace }}:/workspace ghcr.io/tunen-org/firebase-tools-dart:${{ matrix.dart-version }} "dart test"
```

### GitLab CI
```yaml
test:
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker run -v $(pwd):/workspace ghcr.io/tunen-org/firebase-tools-dart:latest "dart test"
```

### CircleCI
```yaml
version: 2.1
jobs:
  test:
    machine: true
    steps:
      - checkout
      - run:
          name: Run Tests
          command: |
            docker run -v $(pwd):/workspace ghcr.io/tunen-org/firebase-tools-dart:latest "dart test"
```

## Available Image Tags

The Docker images are automatically built and tagged with:

- `latest` - Latest stable Dart SDK
- `<dart-version>` - Specific Dart SDK version (e.g., `3.5.0`)
- `dart-<dart-version>` - Alternative format (e.g., `dart-3.5.0`)

Images are automatically rebuilt when new Dart SDK versions are released.

## Environment Variables

- `WORKDIR`: Override the working directory (default: `/workspace`)
- `FIRESTORE_EMULATOR_HOST`: Automatically set by Firebase CLI

## Port Mappings

- `8080`: Firestore emulator
- `4000`: Firebase Emulator UI
- `4500`: Emulator logging

## Notes

- The entrypoint automatically wraps your command with `firebase emulators:exec`
- Tests run with `--project demo-test` to avoid needing Firebase project configuration
- Volume mount your code to `/workspace` for the container to access your tests
- For local development, map ports with `-p` flag to access emulator UI
