# Nginx RTMP/HLS Prototype

A minimal, Docker-based RTMP ingest and HLS playback server.

## Overview

- **Ingest (RTMP):** `rtmp://<HOST_IP>:1935/live/<STREAM_KEY>`
- **Playback (HLS):** `http://<HOST_IP>:8080` (Standard HTML5 Player)
- **HLS Direct URL:** `http://<HOST_IP>:8080/hls/<STREAM_KEY>.m3u8`

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

3.  **Watch:**
    Open [http://localhost:8080](http://localhost:8080) (or `http://<YOUR_MAC_LAN_IP>:8080` from another device).

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
    ```

3.  **Verify HLS files are being created:**
    ```bash
    ls -lah data/hls
    ```
    *You should see `drone.m3u8` and `.ts` files when streaming.*

4.  **Check network access:**
    Ensure your firewall isn't blocking port 1935 (RTMP) or 8080 (HTTP).

## Notes

-   **RTMP vs HLS:** Browsers cannot play RTMP natively. This project uses Nginx to transmux RTMP to HLS on the fly.
-   **Latency:** HLS has inherent latency (approx 6-10s with this config).
