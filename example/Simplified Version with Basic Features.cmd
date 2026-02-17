@echo off
for %%f in (*.mp3) do (
    echo Converting: %%f
    
    ffmpeg -loop 1 -i images.webp -i "%%f" -filter_complex ^
    "[0:v]scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720[bg];^
    [1:a]showwaves=s=1280x100:mode=cline:rate=25:colors=white[waves];^
    color=c=black:s=1280x100,format=rgba[wave_bg];^
    [wave_bg][waves]overlay=0:0[waves_final];^
    [bg]drawtext=text='%%~nf':fontcolor=white:fontsize=36:fontweight=bold:x=(w-text_w)/2:y=((h-100)/2)-20,^
    drawtext=text='%%{pts\:hms}':fontcolor=yellow:fontsize=14:x=10:y=10[title_video];^
    [title_video][waves_final]overlay=0:H-100" ^
    -c:v libx264 -tune stillimage -preset fast -c:a aac -pix_fmt yuv420p -shortest "%%~nf_wave.mp4" -y
    
    echo Done: %%~nf_wave.mp4
)
pause