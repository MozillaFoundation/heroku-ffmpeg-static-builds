#!/usr/bin/env bash
set -euo pipefail

# Build the image with shared libraries
echo "🛠️ Building ffmpeg image with shared libs..."
docker build -f Dockerfile -t ffmpeg-shared .

# Run ffmpeg in a one-off container to extract version
echo "🔍 Detecting version from built binary..."
output=$(docker run --rm ffmpeg-shared ffmpeg -version)
echo "$output"
version=$(docker run --rm ffmpeg-shared ffmpeg -version | awk '/ffmpeg version/ { print $3; exit }')
tarball="ffmpeg-${version}-webp.tar.xz"

# Create a container just to copy the binary
container_id=$(docker create ffmpeg-shared)

echo "📥 Copying /usr/local/bin/ffmpeg to ./${tarball%.tar.xz}"
docker cp "$container_id":/usr/local/bin/ffmpeg ./${tarball%.tar.xz}

# Clean up container
docker rm "$container_id" >/dev/null
chmod +x ./${tarball%.tar.xz}

# Package it
echo "📦 Creating tarball: $tarball"
tar -cJf "$tarball" "${tarball%.tar.xz}"
rm "${tarball%.tar.xz}"

echo "✅ Done. Created $tarball"