@echo off
set "FOLDER=final_tutorial"
set "OUT_FILE=master_tutorial_with_fades.mp4"

echo 🎬 Merging scenes with smooth transitions...

:: 1. Identify your scenes
set "S1=%FOLDER%\scene_1.mp4"
set "S2=%FOLDER%\scene_2.mp4"

:: 2. Check if files exist 
if not exist "%S1%" (
    echo ❌ Missing %S1%. Run Tutorial_Maker.bat first.
    pause & exit /b
)

:: 3. Run the XFADE command
:: offset is the time (in seconds) when the transition starts. 
:: If Scene 1 is 4 seconds, offset=3 starts the fade 1 second before it ends.
ffmpeg -y -i "%S1%" -i "%S2%" -filter_complex "[0:v][1:v]xfade=transition=fade:duration=1:offset=3[v];[0:a][1:a]acrossfade=d=1[a]" -map "[v]" -map "[a]" -pix_fmt yuv420p "%OUT_FILE%"

echo ✨ Master Tutorial with Fades Finished!
pause