@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Circular Waveform Generator for Windows
echo ========================================

if "%1"=="" (
    echo Usage: %0 input_audio.mp3 output_video.mp4
    echo Example: %0 song.mp3 waveform.mp4
    goto :error
)

if "%2"=="" (
    set OUTPUT=output.mp4
) else (
    set OUTPUT=%2
)

set WIDTH=720
set HEIGHT=720

echo.
echo Creating circular waveform from: %1
echo Output: %OUTPUT%
echo.

REM Alternative: Using showwaves with radial blur effect
ffmpeg -i "%1" -filter_complex ^
"[0:a]showwaves=s=%WIDTH%x%HEIGHT%:mode=cline:rate=25:colors=cyan[waves]; ^
 [waves]format=rgba,geq=r='X/W*255':g='Y/H*255':b='255-X/W*255',radial=size=360[circular]" ^
-map "[circular]" -map 0:a -c:v libx264 -pix_fmt yuv420p -preset fast -c:a copy "%OUTPUT%"

if %errorlevel% neq 0 (
    echo.
    echo Error: FFmpeg failed to process the file
    goto :error
)

echo.
echo Success! Output saved to: %OUTPUT%
goto :end

:error
echo.
echo Error occurred. Make sure:
echo 1. FFmpeg is installed and in PATH
echo 2. Input file exists and is valid
pause

:end
endlocal