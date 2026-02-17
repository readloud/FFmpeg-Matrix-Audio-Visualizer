@echo off
setlocal enabledelayedexpansion

:: Configuration
set LOGO_FILE=logo.png  (optional, remove if not needed)
set BRAND_COLOR=#00BFFF
set BG_COLOR=#0A0A0A

for %%f in (*.mp3) do (
    echo Creating video for: %%~nf
    
    :: Build filter complex based on logo availability
    if exist "%LOGO_FILE%" (
        set LOGO_FILTER=;[1:0]scale=60:-1[logo];[title_video][logo]overlay=10:10
    ) else (
        set LOGO_FILTER=
    )
    
    ffmpeg -loop 1 -i images.webp -i "%%f" %LOGO_FILE% -filter_complex ^
    "[0:v]scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720[bg];^
    [1:a]asplit[audio1][audio2];^
    [audio1]showwaves=s=600x80:mode=cline:rate=25:colors=red[Lwaves];^
    [audio2]showwaves=s=600x80:mode=cline:rate=25:colors=blue[Rwaves];^
    color=c=%BG_COLOR%:s=1280x120,format=rgba[wave_bg];^
    [wave_bg][Lwaves]overlay=40:20[withL];^
    [withL][Rwaves]overlay=640:20[waves_final];^
    [bg]drawtext=text='%%~nf':fontcolor=white:fontsize=44:fontweight=bold:x=(w-text_w)/2:y=((h-120)/2)-50,^
    drawtext=text='Audio Waveform Visualization':fontcolor=%BRAND_COLOR%:fontsize=22:x=(w-text_w)/2:y=((h-120)/2)+20,^
    drawtext=text='L':fontcolor=red:fontsize=14:x=40:y=H-40,^
    drawtext=text='R':fontcolor=blue:fontsize=14:x=680:y=H-40,^
    drawtext=text='%%{pts\:hms}':fontcolor=cyan:fontsize=14:x=20:y=20,^
    drawtext=text='%%~nf':fontcolor=gray:fontsize=12:x=w-150:y=H-20[title_video]%LOGO_FILTER%;^
    [title_video][waves_final]overlay=0:H-120" ^
    -c:v libx264 -tune stillimage -preset fast -c:a aac -b:a 192k -pix_fmt yuv420p -shortest "%%~nf_pro.mp4" -y
    
    echo [OK] %%~nf_pro.mp4
)

echo All videos created successfully!
pause