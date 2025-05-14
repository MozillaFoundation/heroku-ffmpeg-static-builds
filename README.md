# heroku-ffmpeg-static-builds
Contains static builds of ffmpeg or use in buildpacks. Provides example commands to build a package from source. Alternatively, download & commit a static x64 build from a trusted source if it contains webp codecs (https://ffmpeg.org/). Push new package to generate a release via release.yml

Will automatically create a new release if a new package is detected. Will not overwrite existing releases & tags. Manually delete the existing release & tag and re-run the Github Action.

## Build static binary from source
docker build -f Dockerfile -t ffmpeg-static .

## Extract the binary and package into project root
./scripts/extract-ffmpeg-binary.sh
