@echo off
setlocal enabledelayedexpansion

set "OUT=final_tutorial"
set "SOURCE_FILE=content.txt"

if not exist "%OUT%" mkdir "%OUT%"
if not exist "%SOURCE_FILE%" (
    echo ❌ Error: %SOURCE_FILE% not found!
    pause
    exit /b
)

echo 🎙️ Reading tutorial content from %SOURCE_FILE%...

:: Loop through each line in the text file
for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%SOURCE_FILE%") do (
    set "fname=%%a"
    set "voice=%%b"
    set "display=%%c"
    
    echo 🎤 Processing !fname!...

    :: 1. Generate Voice using PowerShell 
    powershell -Command "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.SetOutputToWaveFile('%OUT%\temp.wav'); $speak.Speak('!voice!'); $speak.Dispose()"

    :: 2. Get Duration [cite: 6]
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "%OUT%\temp.wav" > dur.tmp
    set /p dur=<dur.tmp
    del dur.tmp
    if "!dur!"=="" set "dur=5"

    :: 3. Create Video 
    :: Using the simple 'Arial' path to avoid the Fontconfig errors seen in your logs 
    ffmpeg -y -f lavfi -i color=c=0x1e1e1e:s=1920x1080:d=!dur! -i "%OUT%\temp.wav" ^
    -vf "drawtext=fontfile='C\:/Windows/Fonts/pantalone.ttf':text='!display!':fontcolor=white:fontsize=60:x=(W-tw)/2:y=(H-th)/2" ^
    -c:v libx264 -c:a aac -pix_fmt yuv420p "%OUT%\!fname!.mp4"

    del "%OUT%\temp.wav"
)

echo ✨ All scenes generated from file!
pause