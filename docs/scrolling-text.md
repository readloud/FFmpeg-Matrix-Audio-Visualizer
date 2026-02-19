##scrolling text
```
ffmpeg -i input.mp4 -vf "drawtext=fontfile=/path/to/font.ttf:fontsize=40:fontcolor=white:text='Your Scrolling Text Here':x=w-t*(w+tw)/10:y=h-th-20" -codec:a 
```
```
ffmpeg -i input.mp4 -vf "drawtext=fontfile=/path/to/font.ttf:textfile=/path/to/livetext.txt:reload=1:x=w-t*(w+tw)/10:y=h-th-20" -codec:a copy output.mp4
```
```
ffmpeg -i input.mp4 -vf "drawtext=fontfile=Yellow.ttf:fontsize=40:fontcolor=white:x=w-t*(w+tw)/duration:y=h-th-10:textfile=screen.txt" -c:a copy output.mp4
```
```
ffmpeg -f lavfi -i color=c=black:s=1280x720:d=30 -vf "drawtext=fontfile=Yellow.ttf:fontsize=40:fontcolor=white:x=w-t*(w+tw)/30:y=h-th-10:textfile=screen.txt" output.mp4
```
```
ffmpeg -i input.mp4 -vf "drawtext=fontfile=Arial.ttf:fontsize=30:fontcolor=white:x=10:y=10:text='Line One\nLine Two\nLine Three'" -codec:a copy output.mp4
```
```
ffmpeg -i input.mp4 -vf "drawtext=fontfile=Yellow.ttf:fontsize=30:fontcolor=white:x=10:y=10:textfile=tes.txt" -codec:a copy output.mp4
```
```
ffmpeg -loop 1 -t 20 -i input.png -i output.mp4 -filter_complex "[0]split[txt][orig];[txt]drawtext=fontfile=tahoma.ttf:fontsize=55:fontcolor=white:x=(w-text_w)/2+20:y=h-20
```
*t:textfile='yourfile.txt':bordercolor=black:line_spacing=20:borderw=3[txt];[orig]crop=iw:50:0:0[orig];[txt][orig]overlay" -c:v libx264 -y -preset ultrafast -t 20 -sortest output_scrolling.mp4

##recording
```
ffmpeg -f gdigrab -framerate 30 -i desktop -c:v libx264 -pix_fmt yuv420p output.mp4
```
```
ffmpeg -f gdigrab -framerate 30 -i desktop -f dshow -i audio="Stereo Mix" -c:v libx264 -pix_fmt yuv420p output.mp4
```
```
(Linux)ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0 -c:v libx264 -pix_fmt yuv420p output.mp4
```
The error message `Could not find audio only device with name [Stereo Mix]` means that FFmpeg cannot find a recording device named "Stereo Mix" on your system. This is a very common issue because "Stereo Mix" is not a universal or default audio device on Windows; its name and availability depend entirely on your specific sound card driver .

Here are the steps to diagnose and fix this problem, starting with the most likely solution.

### 🔍 Step 1: Find the Exact Name of Your "What U Hear" Device

You need to ask FFmpeg to list all the audio input devices it can see on your computer. The name will almost certainly be different from "Stereo Mix".

1.  Open your command prompt or terminal.
2.  Run the following command:
    ```bash
    ffmpeg -list_devices true -f dshow -i dummy
    ```
3.  Look for the `DirectShow audio devices` section in the output. You will see a list of your available audio input devices, which might look something like this :
    ```
    [dshow @ 000001e0034ade00] DirectShow audio devices
    [dshow @ 000001e0034ade00]  "立体声混音 (Realtek(R) Audio)"
    [dshow @ 000001e0034ade00]     Alternative name "@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{348B8A31-CF2E-42D5-A6B2-862A966A1ED0}"
    ```
    In this example, the device is actually named `立体声混音 (Realtek(R) Audio)` (which is "Stereo Mix" in Chinese). On an English system, it might be named something like `Stereo Mix (Realtek High Definition Audio)`, `What U Hear`, `Wave Out Mix`, or `Mixed Output` .

The exact name in the quotes (`" "`) is what you must use in your FFmpeg command. Copy and paste it directly from your terminal to avoid typos.

### 🎯 Step 2: Use the Correct Device Name in Your Command

Once you have the exact name, replace `"Stereo Mix"` in your original command. For example, if your device is listed as `"Stereo Mix (Realtek High Definition Audio)"`, your command would become:

```bash
ffmpeg -f gdigrab -framerate 30 -i desktop -f dshow -i audio="Stereo Mix (Realtek High Definition Audio)" -c:v libx264 -pix_fmt yuv420p output.mp4
```

### ✅ Step 3: Alternative Solutions If No Device Is Found

If the `ffmpeg -list_devices ...` command **does not list any audio devices at all** under `DirectShow audio devices`, or if the device you find doesn't capture system audio, you have a few options:

*   **Enable "Stereo Mix" in Windows Sound Settings:** The device might be present but disabled. Follow these steps:
    1.  Right-click the **speaker icon** in your system tray and select **"Sounds"**.
    2.  Go to the **"Recording"** tab.
    3.  Right-click in an empty area of the list and check **"Show Disabled Devices"**.
    4.  If "Stereo Mix" appears, right-click it and select **"Enable"** .
*   **Use a Virtual Audio Cable:** This is a very reliable fallback. Software like **VB-Cable** or **Virtual Audio Cable** creates a new virtual audio device. You set your system's audio to output to this virtual cable, and then FFmpeg records from it. This guarantees a consistent device name (like `CABLE Input`), solving the problem permanently .
*   **Check Your Sound Card Driver:** On some systems, the "Stereo Mix" feature is not enabled in the sound card driver itself. You may need to open your sound card's control panel (e.g., Realtek HD Audio Manager) and look for an option to enable "Stereo Mix" or "Record What You Hear" .

Start with **Step 1** to identify the correct name. In the vast majority of cases, that's all you need to do to get your screen recording command working.