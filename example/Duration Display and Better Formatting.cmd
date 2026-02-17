@echo off
setlocal enabledelayedexpansion

:: Configuration
set WAVE_HEIGHT=120
set WAVE_COLORS=cyan|white
set VIDEO_WIDTH=1280
set VIDEO_HEIGHT=720
set TITLE_FONTSIZE=48
set SUBTITLE_FONTSIZE=24
set TIMESTAMP_FONTSIZE=16

for %%f in (*.mp3) do (
    echo ========================================
    echo Processing: %%~nf
    echo ========================================
    
    :: Get duration using ffprobe
    for /f "tokens=*" %%a in ('ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%%f"') do set DURATION=%%a
    
    :: Convert duration to HH:MM:SS format
    set /a HOURS=!DURATION:/=! / 3600
    set /a MINUTES=(!DURATION:/=! %% 3600) / 60
    set /a SECONDS=!DURATION:/=! %% 60
    if !HOURS! lss 10 set HOURS=0!HOURS!
    if !MINUTES! lss 10 set MINUTES=0!MINUTES!
    if !SECONDS! lss 10 set SECONDS=0!SECONDS!
    set DURATION_FORMATTED=!HOURS!:!MINUTES!:!SECONDS!
    
    ffmpeg -loop 1 -i images.webp -i "%%f" -filter_complex ^
    "[0:v]scale=%VIDEO_WIDTH%:%VIDEO_HEIGHT%:force_original_aspect_ratio=increase,crop=%VIDEO_WIDTH%:%VIDEO_HEIGHT%,pad=%VIDEO_WIDTH%:%VIDEO_HEIGHT%:(ow-iw)/2:(oh-ih)/2,setsar=1[bg];^
    [1:a]showwaves=s=%VIDEO_WIDTH%x%WAVE_HEIGHT%:mode=cline:rate=25:colors=%WAVE_COLORS%[waves];^
    color=c=#1a1a1a:s=%VIDEO_WIDTH%x%WAVE_HEIGHT%,format=rgba[wave_bg];^
    [wave_bg][waves]overlay=0:0[waves_final];^
    [bg]drawtext=text='%%~nf':fontcolor=white:fontsize=%TITLE_FONTSIZE%:fontweight=bold:x=(w-text_w)/2:y=((h-%WAVE_HEIGHT%)/2)-40:shadowcolor=black@0.8:shadowx=3:shadowy=3,^
    drawtext=text='Audio Visualization':fontcolor=#AAAAAA:fontsize=%SUBTITLE_FONTSIZE%:x=(w-text_w)/2:y=((h-%WAVE_HEIGHT%)/2)+30,^
    drawtext=text='%%{pts\:hms}':fontcolor=cyan:fontsize=%TIMESTAMP_FONTSIZE%:x=20:y=20,^
    drawtext=text='!DURATION_FORMATTED!':fontcolor=green:fontsize=%TIMESTAMP_FONTSIZE%:x=w-120:y=20,^
    drawbox=x=0:y=H-%WAVE_HEIGHT%:w=%VIDEO_WIDTH%:h=%WAVE_HEIGHT%:color=#1a1a1a@0.95:t=fill[with_box];^
    [with_box][waves_final]overlay=0:H-%WAVE_HEIGHT%" ^
    -c:v libx264 -tune stillimage -preset fast -c:a aac -b:a 192k -pix_fmt yuv420p -shortest "%%~nf_waveform.mp4" -y
    
    if !errorlevel! equ 0 (
        echo [SUCCESS] Created: %%~nf_waveform.mp4
    ) else (
        echo [ERROR] Failed to process: %%~nf
    )
    echo ----------------------------------------
)

echo.
echo All conversions completed!
pause