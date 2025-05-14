#!/usr/bin/env bash
set -euo pipefail

for TARBALL in ffmpeg-*.tar.xz; do
  VERSION=$(echo "$TARBALL" | sed -E 's/^ffmpeg-(.*).tar.xz$/\1/' | tr '+' '-')
  TAG="v$VERSION"

  echo "Preparing release for $TAG using $TARBALL"

  # Check if the release already exists
  if gh release view "$TAG" >/dev/null 2>&1; then
    echo "Release $TAG already exists. Skipping."
    continue
  fi

  # Create the release
  gh release create "$TAG" "$TARBALL" \
    --title "FFmpeg $VERSION" \
    --notes "Auto-generated FFmpeg build from Docker container."

  echo "Release $TAG created successfully."
done