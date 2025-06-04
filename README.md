# heroku-ffmpeg-static-builds

## Description
Contains static builds of ffmpeg or use in buildpacks. Provides example commands to build a package from source. Alternatively, download & commit a static x64 build from a trusted source if it contains webp codecs (i.e. [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html)). Push new package to generate a release via release.yml

## Build static binary from source
docker build -f Dockerfile -t ffmpeg-static .

## Extract the binary and package into project root
./scripts/extract-ffmpeg-binary.sh

## Releasing
The repo will automatically create a new release via Github actions if a new package is committed. But it will not overwrite existing releases & tags. You will have to manually delete the existing release & tag and re-run the Github Action in order to release a new version of the same name.

## Post Release (to update the heroku buildpack)
Once a new static build is uploaded, visit the buildpack repo (https://github.com/MozillaFoundation/heroku-ffmpeg-buildpack), and follow the instructions to update the buildpack. 
