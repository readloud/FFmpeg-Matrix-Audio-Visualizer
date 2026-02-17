@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Vectorscope Waveform Generator
echo ========================================

if "%1"=="" (
    echo Usage: %0 input_audio.mp3 output_video.mp4
    echo Example: %0 song.mp3 waveform.mp4
    goto :error
)

if "%2"=="" (
    set OUTPUT=vectorscope_%date:~-4,4%%date:~-10,2%%date:~-7,2%.mp4
    set OUTPUT=!OUTPUT: =0!
) else (
    set OUTPUT=%2
)

set WIDTH=720
set HEIGHT=720

echo.
echo Creating vectorscope from: %1
echo Output: %OUTPUT%
echo.

REM Working avectorscope parameters
ffmpeg -i "%1" -filter_complex ^
"[0:a]avectorscope=s=%WIDTH%x%HEIGHT%:zoom=1.3:draw=line:rf=1:gf=1:bf=1,format=yuv420p[outv]" ^
-map "[outv]" -map 0:a -c:v libx264 -pix_fmt yuv420p -preset fast -c:a copy "%OUTPUT%"

if %errorlevel% neq 0 (
    echo Error: FFmpeg failed to process the file
    goto :error
)

echo.
echo Success! Output saved to: %OUTPUT%
goto :end

:error
echo.
echo Error occurred. Check FFmpeg installation.
pause

:end
endlocal
Script 3: Interactive Menu with Working Parameters
Save as waveform_menu_fixed.cmd:

batch
@echo off
setlocal enabledelayedexpansion
title Waveform Generator

:MENU
cls
echo ========================================
echo    WAVEFORM GENERATOR MENU
echo ========================================
echo.
echo 1. Vectorscope (line mode)
echo 2. Vectorscope (color gradient)
echo 3. Showwaves (linear waveform)
echo 4. Showwaves + Circular effect
echo 5. Exit
echo.
set /p choice="Select option (1-5): "

if "%choice%"=="1" goto vectorscope_line
if "%choice%"=="2" goto vectorscope_color
if "%choice%"=="3" goto showwaves
if "%choice%"=="4" goto circular_effect
if "%choice%"=="5" goto exit
goto MENU

:vectorscope_line
cls
echo Vectorscope - Line Mode
echo -----------------------
set /p input="Drag audio file here: "
set input=%input:"=%

if "%input%"=="" goto MENU
if not exist "%input%" (
    echo File not found!
    pause
    goto MENU
)

set /p output="Output filename (default: vectorscope_line.mp4): "
if "%output%"=="" set output=vectorscope_line.mp4

ffmpeg -i "%input%" -filter_complex "[0:a]avectorscope=s=720x720:zoom=1.3:draw=line:rc=1:gc=1:bc=1,format=yuv420p[outv]" -map "[outv]" -map 0:a -c:v libx264 -pix_fmt yuv420p -preset fast -c:a copy "%output%"

if %errorlevel%==0 (echo Success! Saved as %output%) else (echo Error!)
pause
goto MENU

:vectorscope_color
cls
echo Vectorscope - Color Gradient
echo ----------------------------
set /p input="Drag audio file here: "
set input=%input:"=%

if "%input%"=="" goto MENU
if not exist "%input%" (
    echo File not found!
    pause
    goto MENU
)

set /p output="Output filename (default: vectorscope_color.mp4): "
if "%output%"=="" set output=vectorscope_color.mp4

ffmpeg -i "%input%" -filter_complex "[0:a]avectorscope=s=720x720:zoom=1.3:draw=color:rf=1:gf=1:bf=1,format=yuv420p[outv]" -map "[outv]" -map 0:a -c:v libx264 -pix_fmt yuv420p -preset fast -c:a copy "%output%"

if %errorlevel%==0 (echo Success! Saved as %output%) else (echo Error!)
pause
goto MENU

:showwaves
cls
echo Showwaves - Linear Waveform
echo ---------------------------
set /p input="Drag audio file here: "
set input=%input:"=%

if "%input%"=="" goto MENU
if not exist "%input%" (
    echo File not found!
    pause
    goto MENU
)

set /p output="Output filename (default: showwaves.mp4): "
if "%output%"=="" set output=showwaves.mp4

ffmpeg -i "%input%" -filter_complex "[0:a]showwaves=s=720x720:mode=cline:rate=25:colors=cyan|magenta|yellow,format=yuv420p[outv]" -map "[outv]" -map 0:a -c:v libx264 -pix_fmt yuv420p -preset fast -c:a copy "%output%"

if %errorlevel%==0 (echo Success! Saved as %output%) else (echo Error!)
pause
goto MENU

:circular_effect
cls
echo Circular Waveform Effect
echo ------------------------
set /p input="Drag audio file here: "
set input=%input:"=%

if "%input%"=="" goto MENU
if not exist "%input%" (
    echo File not found!
    pause
    goto MENU
)

set /p output="Output filename (default: circular_effect.mp4): "
if "%output%"=="" set output=circular_effect.mp4

echo Creating circular effect... This may take a moment.

REM Create a circular mask and apply to waveform
ffmpeg -i "%input%" -filter_complex ^
"color=c=black:s=720x720:r=25[bg]; ^
 [0:a]showwaves=s=720x720:mode=cline:rate=25:colors=white[waves]; ^
 [bg][waves]overlay=0:0,geq='if(between(hypot(X-360,Y-360),300,360),255,0)':cb=255:cr=128,format=yuv420p[circular]" ^
-map "[circular]" -map 0:a -c:v libx264 -pix_fmt yuv420p -preset fast -c:a copy "%output%"

if %errorlevel%==0 (echo Success! Saved as %output%) else (echo Error!)
pause
goto MENU

:exit
endlocal
exit /b 0
Script 4: Quick Test Script
Save as test_ffmpeg_features.cmd:

batch
@echo off
echo Testing available FFmpeg filters...
echo =================================

ffmpeg -filters | findstr /i "vectorscope showwaves"

echo.
echo Available avectorscope options:
echo ------------------------------
ffmpeg -h filter=avectorscope

echo.
echo Press any key to exit...
pause > nul