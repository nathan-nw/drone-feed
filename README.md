# Drone Live Stream Project

A prototype for low-latency drone video streaming, demonstrating the difference between **RTMP -> HLS** and **RTMP -> WebRTC** pipelines using Docker, Nginx, and MediaMTX.

## 📚 Concepts & Technologies

This project serves as a practical comparison between two major video streaming technologies: **HLS** and **WebRTC**.

### 1. HLS (HTTP Live Streaming)
**What is it?**  
HLS is a widely used streaming protocol developed by Apple. It works by breaking the continuous video stream into small file chunks (usually `.ts` files), typically 2-10 seconds long. A manifest file (`.m3u8`) tells the video player which chunks to play and in what order.

**How it works here:**
1. Drone sends video via RTMP.
2. Nginx chops the video into small files on the disk (`data/hls/*.ts`).
3. Browser requests the `.m3u8` playlist via standard HTTP.
4. Browser downloads each video chunk via HTTP and plays them in sequence.

**Pros/Cons:**
*   ✅ **Reliable:** Uses TCP/HTTP. Buffering ensures smooth playback even with network jitter.
*   ✅ **Scalable:** Since it's just static files, it can be cached by CDNs easily.
*   ❌ **High Latency:** The player must wait for a chunk to be fully created and downloaded before playing. Typical latency is 10-30 seconds.

### 2. WebRTC (Web Real-Time Communication)
**What is it?**  
WebRTC is an open standard for real-time communication (video, voice, and data). Unlike HLS, it is designed for *interaction*, meaning it prioritizes low latency over perfect video quality.

**How it works here:**
1. Drone sends video via RTMP.
2. MediaMTX acts as a bridge, transcoding the RTMP stream into RTP packets.
3. MediaMTX establishes a direct peer connection with the browser using UDP (mostly).
4. Video packets are streamed immediately as they arrive.

**Pros/Cons:**
*   ✅ **Ultra-Low Latency:** Latency is typically **under 500ms**. Essential for FPV (First Person View) flying or remote control.
*   ❌ **No Buffering:** If packets are lost (bad network), the video will "glitch" or artifact immediately rather than pausing to buffer.
*   ❌ **Complexity:** Requires a signaling process (SDP exchange) to set up the connection.

### 🏁 Comparison: Why is WebRTC Faster?
The main speed difference comes from **Transport Layer** and **Buffering Strategy**:

| Feature | HLS | WebRTC |
| :--- | :--- | :--- |
| **Transport** | **TCP (HTTP)**: Guarantees delivery. If a packet is lost, it stops everything to retransmit it. | **UDP**: "Fire and forget". If a packet is lost, it skips it and moves to the next frame. |
| **Delivery** | **Chunk-based**: Must wait for X seconds of video to be recorded before sending. | **Stream-based**: Sends individual packets immediately as they are generated. |
| **Latency** | High (5s - 30s) | Low (< 0.5s) |
| **Best For** | Netflix, YouTube, Live TV Sports (Passive viewing) | Zoom, Google Meet, Drone Control (Interactive) |

---

## 🚀 Quick Start

### Prerequisites
*   Docker & Docker Compose

### 1. Start the Server
```bash
docker compose up -d
```
This spins up:
*   **Nginx-RTMP** (Port 1935): Receives the video from the drone.
*   **MediaMTX** (Port 8889/8189): Converts RTMP to WebRTC.
*   **Web Server** (Port 8080): Serves the `index.html` player.

### 2. Stream from Drone (or OBS)
Configure your broadcasting software or drone with these settings:
*   **Protocol:** RTMP
*   **Address:** `rtmp://<YOUR_COMPUTER_IP>:1935/live`
*   **Stream Key:** `drone`

### 3. Watch
Open your browser to: **[http://localhost:8080](http://localhost:8080)**

You will see two players side-by-side:
1.  **HLS Player:** High quality, but delayed.
2.  **WebRTC Player:** Almost instant feedback.

## 🛠️ Debugging
If the stream isn't working:
1.  **Check Logs:** `docker compose logs -f`
2.  **Check Ports:** Ensure firewall allows 1935 (RTMP) and 8889/8189 (WebRTC).
3.  **Check HLS Generation:** `ls -lah data/hls` (You should see `.ts` files appearing).
