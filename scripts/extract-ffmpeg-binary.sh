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

# Copy ffmpeg and ffprobe into an ffmpeg-{version}/bin/ directory
mkdir -p "ffmpeg-${version}/bin"
docker cp "$container_id":/usr/local/bin/ffmpeg "ffmpeg-${version}/bin/ffmpeg"
docker cp "$container_id":/usr/local/bin/ffprobe "ffmpeg-${version}/bin/ffprobe"
chmod +x "ffmpeg-${version}/bin/ffmpeg" "ffmpeg-${version}/bin/ffprobe"

# Clean up container
docker rm "$container_id" >/dev/null

# Package it
echo "Creating tarball: $tarball"
tar -cJf "ffmpeg-${version}.tar.xz" "ffmpeg-${version}"
rm -rf "ffmpeg-${version}"

echo "Done. Created $tarball"