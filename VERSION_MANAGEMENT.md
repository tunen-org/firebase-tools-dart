# Version Management

This repository uses explicit Dart SDK version pinning for reproducible builds.

## How It Works

### 1. Version Pinning
- The `.dart-version` file contains the Dart SDK version (e.g., `3.5.0` or `stable`)
- The `Dockerfile` uses this version via build arg: `ARG DART_VERSION=stable`

### 2. Automatic Updates
- GitHub Actions checks daily for new Dart SDK releases
- When detected, a PR is automatically created updating `.dart-version`
- On merge, Docker images are automatically built and tagged

### 3. Image Tags
Every build creates multiple tags:
- `latest` - Always points to the newest build
- `3.5.0` - Specific Dart SDK version
- `dart-3.5.0` - Alternative format with prefix

## Manual Version Update

To update the Dart SDK version manually:

```bash
# Update to specific version
echo "3.5.0" > .dart-version

# Or use latest stable
echo "stable" > .dart-version

# Commit and push
git add .dart-version
git commit -m "chore: update Dart SDK to 3.5.0"
git push
```

The Docker image will be automatically rebuilt on push to main.

## Building Locally with Different Versions

```bash
# Use pinned version from .dart-version
docker build -t firebase-dart-test .

# Override with specific version
docker build --build-arg DART_VERSION=3.4.0 -t firebase-dart-test .

# Use latest
docker build --build-arg DART_VERSION=latest -t firebase-dart-test .
```

## Why Version Pinning?

✅ **Reproducibility** - Same Dart version every time  
✅ **Version selection** - Users can choose specific Dart versions  
✅ **Clear tracking** - Know exactly what's in each image  
✅ **Compatibility** - Test against specific Dart SDK versions  
✅ **Rollback capability** - Easy to revert to previous versions
