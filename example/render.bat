@echo off
setlocal enabledelayedexpansion

:: Cek file wajib
if not exist bg_loop.mp4 (echo File loop_bg.mp4 tidak ada! && pause && exit)
if not exist logo.png (echo File logo.png tidak ada! && pause && exit)

set /p youtube_url="Masukkan URL YouTube: "

echo [1/3] Mengambil Metadata...
yt-dlp --print "drawtext=text='%%(title)s':enable='between(t,%%(start_time)s,%%(end_time)s)':fontcolor=white:fontsize=40:x=(w-text_w)/2:y=h-150:shadowcolor=black:shadowx=2:shadowy=2" "%youtube_url%" > filters_raw.txt
findstr /v "NA" filters_raw.txt > filters.txt
yt-dlp -x --audio-format mp3 -o "input_audio.mp3" "%youtube_url%"

echo [2/3] Menyusun Filter...
set "track_filters="
for /f "usebackq delims=" %%i in ("filters.txt") do (
    if "!track_filters!"=="" (set "track_filters=%%i") else (set "track_filters=!track_filters!,%%i")
)
if "!track_filters!"=="" (set "track_filters=drawtext=text='Music Compilation':fontcolor=white:fontsize=40:x=(w-text_w)/2:y=h-150")

echo [3/3] Rendering (Satu Baris Perintah)...
:: Perintah di bawah ini sengaja dibuat satu baris panjang agar tidak error di Windows CMD
ffmpeg -re -stream_loop -1 -i bg_loop.mp4 -i input_audio.mp3 -i logo.png -filter_complex "[0:v]scale=1280:720,boxblur=10:5[bg];[2:v]scale=150:-1[logo_s];[1:a]showwaves=s=1200x120:mode=line:colors=cyan[wave];[bg][logo_s]overlay=(W-w)/2:(H-h)/2-100[bg_l];[bg_l][wave]overlay=(W-w)/2:H-h-50[v_pre];[v_pre]%track_filters%[outv]" -map "[outv]" -map 1:a -c:v libx264 -preset fast -crf 20 -c:a aac -b:a 192k -shortest output_fix.mp4 -y

echo Selesai! Cek file: output_fix.mp4
pause