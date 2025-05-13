set -euo pipefail

TARBALL=$(ls -1t ffmpeg-*-webp.tar.xz | head -n1)
VERSION=$(echo "$TARBALL" | sed -E 's/^ffmpeg-(.*)-webp.tar.xz$/\1/' | tr '+' '-')
TAG="v$VERSION"

echo "Preparing release for $TAG using $TARBALL"

# Check if the release already exists
if gh release view "$TAG" >/dev/null 2>&1; then
  echo "Release $TAG already exists."
  echo "To update it, delete the release manually via GitHub UI or CLI:"
  echo "   gh release delete $TAG -y"
  exit 1
fi

# Create the release
gh release create "$TAG" "$TARBALL" \
  --title "FFmpeg $VERSION" \
  --notes "Auto-generated FFmpeg build from Docker container."

echo "Release $TAG created successfully."