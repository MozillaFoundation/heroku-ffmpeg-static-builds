FROM debian:bookworm-slim as builder

RUN apt-get update && apt-get install -y \
    autoconf automake build-essential cmake git-core \
    libass-dev libfreetype6-dev libtool libvorbis-dev pkg-config \
    texinfo wget yasm zlib1g-dev libwebp-dev \
    nasm && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --depth=1 --branch n5.1.6 https://github.com/ffmpeg/ffmpeg.git

WORKDIR /build/ffmpeg

RUN ./configure \
  --prefix=/opt/ffmpeg \
  --enable-gpl \
  --enable-libwebp \
  --disable-doc \
  --disable-debug \
  --disable-ffplay \
  --disable-ffprobe && \
  make -j"$(nproc)" && \
  make install

FROM debian:bookworm-slim

COPY --from=builder /opt/ffmpeg/bin/ffmpeg /usr/local/bin/ffmpeg
RUN apt-get update && apt-get install -y \
    libwebpmux3 libwebp7 libwebpdemux2 && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/ffmpeg"]