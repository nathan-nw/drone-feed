# Requires: ffmpeg installed locally
ffmpeg -re -stream_loop -1 -i sample.mp4 `
  -c:v libx264 -preset veryfast -tune zerolatency -g 48 -keyint_min 48 `
  -c:a aac -ar 44100 -b:a 128k `
  -f flv rtmp://localhost/live/drone
