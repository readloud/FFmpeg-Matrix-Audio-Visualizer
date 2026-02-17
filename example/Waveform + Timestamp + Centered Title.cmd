@echo off
setlocal enabledelayedexpansion

:: Set your title (use %%~nf for filename as title, or set custom text)
set CUSTOM_TITLE=My Music Video

for %%f in (*.mp3) do (
    echo Processing: %%f
    
    ffmpeg -loop 1 -i images.webp -i "%%f" -filter_complex ^
    "[0:v]scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1[bg];^
    [1:a]showwaves=s=1200x100:mode=cline:rate=25:colors=cyan|white[waves];^
    color=c=#222222:s=1280x120,format=rgba[wave_bg];^
    [wave_bg][waves]overlay=40:10[waves_final];^
    [bg]drawtext=text='%%~nf':fontcolor=white:fontsize=48:fontweight=bold:x=(w-text_w)/2:y=(h/2)-60:shadowcolor=black@0.8:shadowx=3:shadowy=3,^
    drawtext=text='Music Video':fontcolor=#CCCCCC:fontsize=24:x=(w-text_w)/2:y=(h/2)+20,^
    drawtext=text='%%{pts\:hms}':fontcolor=yellow:fontsize=18:x=20:y=20,^
    drawtext=text='Duration: ???':fontcolor=green:fontsize=18:x=w-200:y=20[title_video];^
    [title_video][waves_final]overlay=0:H-120" ^
    -c:v libx264 -tune stillimage -preset fast -c:a aac -b:a 192k -pix_fmt yuv420p -shortest "%%~nf_with_wave.mp4" -y
    
    echo Completed: %%~nf_with_wave.mp4
    echo ----------------------------------------
)

echo All files processed!
pause
