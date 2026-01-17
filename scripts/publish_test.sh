#!/usr/bin/env bash
set -euo pipefail
# Requires: ffmpeg installed locally
# Loops a local file into RTMP as a test publisher.
# Replace sample.mp4 with any local video file.
ffmpeg -re -stream_loop -1 -i sample.mp4 \
  -c:v libx264 -preset veryfast -tune zerolatency -g 48 -keyint_min 48 \
  -c:a aac -ar 44100 -b:a 128k \
  -f flv rtmp://localhost/live/drone
