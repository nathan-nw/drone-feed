# Drone RTMP Ingest to WebRTC Prototype

A minimal, Docker-based setup that ingests RTMP from the drone and plays it in the browser via WebRTC.

## Overview

- **Ingest (RTMP from drone):** `rtmp://<HOST_IP>:1935/live/<STREAM_KEY>`
- **Playback (WebRTC, browser):** `http://<HOST_IP>:8080`
- **Underlying RTMP → WebRTC bridge:** MediaMTX pulling from Nginx RTMP

## Quick Start

1.  **Start the server:**
    ```bash
    docker compose up -d
    ```

2.  **Configure your Drone / Publisher:**
    -  **Protocol:** RTMP
    -  **URL:** `rtmp://<YOUR_MAC_LAN_IP>:1935/live`
    -  **Stream Key:** `drone`
    -  *Note: Make sure your Mac and Drone are on the same network.*

3.  **Watch (WebRTC):**
    Open [http://localhost:8080](http://localhost:8080) (or `http://<YOUR_MAC_LAN_IP>:8080` from another device).
    The page embeds the MediaMTX WebRTC player for the `drone` stream.

## Debug Checklist

If the stream isn't working, run these commands:

1.  **Check logs:**
    ```bash
    docker compose logs -f
    ```
    *Look for "hls: publish" messages.*

2.  **Verify ports are listening:**
    ```bash
    lsof -nP -iTCP:1935 -sTCP:LISTEN
    lsof -nP -iTCP:8080 -sTCP:LISTEN
    lsof -nP -iTCP:8889 -sTCP:LISTEN
    ```

3.  **Verify HLS files are being created:**
    ```bash
    ls -lah data/hls
    ```
    *You should see `drone.m3u8` and `.ts` files when streaming.*

4.  **Check network access:**
    Ensure your firewall isn't blocking port 1935 (RTMP), 8080 (HTTP UI), or 8889/8189 (WebRTC).

## Notes

-   Browsers cannot play RTMP directly. RTMP from the drone is ingested by Nginx and pulled by MediaMTX.
-   MediaMTX exposes a WebRTC endpoint that the HTML page embeds as a player.
-   This is a simple MVP optimized for local/LAN testing with a single drone stream.
