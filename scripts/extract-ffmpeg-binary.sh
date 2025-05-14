#!/usr/bin/env bash
set -euo pipefail

# Use buildx and target amd64 platform for Heroku compatibility
docker buildx create --name ffmpeg-builder --use >/dev/null 2>&1 || docker buildx use ffmpeg-builder

echo "Building ffmpeg image for linux/amd64..."
docker buildx build --platform linux/amd64 -f Dockerfile -t ffmpeg-shared --load .

# Run ffmpeg in a one-off container to extract version
echo "Detecting version from built binary..."
output=$(docker run --rm ffmpeg-shared ffmpeg -version)
echo "$output"
version=$(echo "$output" | head -n1 | awk '{ print $3 }')
tarball="ffmpeg-${version}.tar.xz"

# Create a container just to copy the binaries
container_id=$(docker create ffmpeg-shared)

# Copy ffmpeg and ffprobe into a bin/ directory
mkdir -p bin
docker cp "$container_id":/usr/local/bin/ffmpeg ./bin/ffmpeg
docker cp "$container_id":/usr/local/bin/ffprobe ./bin/ffprobe
chmod +x ./bin/ffmpeg ./bin/ffprobe

# Clean up container
docker rm "$container_id" >/dev/null

# Package it
echo "Creating tarball: $tarball"
tar -cJf "$tarball" bin
rm -rf bin

echo "Done. Created $tarball"