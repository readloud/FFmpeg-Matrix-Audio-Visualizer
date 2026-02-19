@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "FFMPEG_PATH=ffmpeg"
set "ASSETS_DIR=assets"
set "OUTPUT_DIR=output"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo 🎵 Music Factory Visualizer [Batch Version]
echo 1. YouTube (1920x1080)
echo 2. TikTok/Shorts (1080x1920)
set /p choice="Select Format (1 or 2): "

for %%A in (*.mp3) do (
    set "songname=%%~nA"
    echo 🔨 Processing: !songname!
    
    :: Check for matching image, else use default
    if exist "!songname!.png" (
        set "cover=!songname!.png"
    ) else (
        set "cover=%ASSETS_DIR%\cover.png"
    )

    if "%choice%"=="1" (
        :: YouTube Horizontal Logic
        %FFMPEG_PATH% -y -i "%ASSETS_DIR%\bg_loop.mp4" -i "%%A" -i "!cover!" -filter_complex "[1:a]showwaves=s=1920x200:mode=line:colors=white[v];[0:v][v]overlay=0:H-200[bg];[bg][2:v]overlay=(W-w)/2:(H-h)/2" -pix_fmt yuv420p -shortest "%OUTPUT_DIR%\!songname!_YT.mp4"
    ) else (
        :: TikTok Vertical Logic
        %FFMPEG_PATH% -y -i "%ASSETS_DIR%\bg_loop.mp4" -i "%%A" -i "!cover!" -filter_complex "[1:a]showwaves=s=1080x400:mode=line:colors=cyan[v];[0:v]scale=1080:1920,setsar=1[bg];[bg][v]overlay=0:H-600[res];[res][2:v]scale=800:-1[img];[res][img]overlay=(W-w)/2:(H-h)/2" -pix_fmt yuv420p -shortest "%OUTPUT_DIR%\!songname!_Shorts.mp4"
    )
)
echo ✅ All videos rendered!
pause