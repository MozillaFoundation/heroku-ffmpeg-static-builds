# heroku-ffmpeg-static-builds
Contains static builds of ffmpeg or use in buildpacks

## Build static binary from source
docker build -f Dockerfile -t ffmpeg-static .

## Extract the binary and package into project root
./scripts/extract-ffmpeg-binary.sh