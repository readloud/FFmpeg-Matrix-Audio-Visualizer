@echo off
setlocal enabledelayedexpansion

set "OUT=final_tutorial"
if not exist "%OUT%" mkdir "%OUT%"

echo 🎙️ Starting Fixed Windows Native Tutorial Engine...

:: Define your scenes 
set "s1=scene_1|Welcome to the Music Factory.|Welcome to the Music Factory."
set "s2=scene_2|Step one. Match your audio and images.|Step 1\: Match your audio and images."

for %%S in ("%s1%" "%s2%") do ( 
    for /f "tokens=1,2,3 delims=|" %%a in (%%S) do (
        set "fname=%%a"
        set "voice=%%b"
        set "display=%%c"
        
        echo 🎤 Processing !fname!...

        :: 1. Generate Voice
        powershell -Command "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.SetOutputToWaveFile('%OUT%\temp.wav'); $speak.Speak('!voice!'); $speak.Dispose()"

        :: 2. Get Duration 
        ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "%OUT%\temp.wav" > dur.tmp
        set /p dur=<dur.tmp
        del dur.tmp

        if "!dur!"=="" set "dur=5"
        
        echo 🕒 Duration detected: !dur! seconds 

        :: 3. Create Video (Using DIRECT font path to fix Fontconfig error)
        ffmpeg -y -f lavfi -i color=c=0x1e1e1e:s=1920x1080:d=!dur! -i "%OUT%\temp.wav" ^
        -vf "drawtext=fontfile='C\:/Windows/Fonts/pantalone.ttf':text='!display!':fontcolor=white:fontsize=60:x=(W-tw)/2:y=(H-th)/2:enable='lte(n,t*30)'" ^
        -c:v libx264 -c:a aac -pix_fmt yuv420p "%OUT%\!fname!.mp4"

        del "%OUT%\temp.wav"
    )
)
pause