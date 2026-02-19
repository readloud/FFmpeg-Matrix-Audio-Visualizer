:: Solid Background Logic (Styles 1-8)
if %wave_style% equ 1 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=black:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=white[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%" ]
    goto :WAVEFORM_DONE
)
if %wave_style% equ 2 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=black:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=line:rate=25:colors=cyan[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%" ]
    goto :WAVEFORM_DONE
)
if %wave_style% equ 3 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=black:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=point:rate=25:colors=yellow[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style% equ 4 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=blue:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=white[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style% equ 5 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=black:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=red|blue[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%" 
    goto :WAVEFORM_DONE
)
if %wave_style% equ 6 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=black:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=p2p:rate=25:colors=green[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style% equ 7 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=black:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=white[wave];[bg][wave]overlay=shortest=1,boxblur=2:1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style% equ 8 (
    ffmpeg -i "%input_mp3%" -filter_complex "color=c=black:s=1280x720:d=300[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=0x00FFFF|0xFF00FF[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%" 
    goto :WAVEFORM_DONE
)

:: Image Background Logic (Styles 9-15)
if %wave_style_1% equ 1 (
    ffmpeg -i "%input_mp3%" -loop 1 -i "%input_img%" -filter_complex "[1:v]scale=1280:720[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=white[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%" 
    goto :WAVEFORM_DONE
)
if %wave_style_1% equ 2 (
    ffmpeg -i "%input_mp3%" -loop 1 -i "%input_img%" -filter_complex "[1:v]scale=1280:720[bg];[0:a]showwaves=s=1280x720:mode=line:rate=25:colors=cyan[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%" 
    goto :WAVEFORM_DONE
)
if %wave_style_1% equ 3 (
    ffmpeg -i "%input_mp3%" -loop 1 -i "%input_img%" -filter_complex "[1:v]scale=1280:720[bg];[0:a]showwaves=s=1280x720:mode=point:rate=25:colors=yellow[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style_1% equ 4 (
    ffmpeg -i "%input_mp3%" -loop 1 -i "%input_img%" -filter_complex "[1:v]scale=1280:720[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=0x00FFFF|0xFF00FF[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style_1% equ 5 (
    ffmpeg -i "%input_mp3%" -loop 1 -i "%input_img%" -filter_complex "[1:v]scale=1280:720[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=red|blue[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style_1% equ 6 (
    ffmpeg -i "%input_mp3%" -loop 1 -i "%input_img%" -filter_complex "[1:v]scale=1280:720[bg];[0:a]showwaves=s=1280x720:mode=p2p:rate=25:colors=green[wave];[bg][wave]overlay=shortest=1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)
if %wave_style% equ 0 (
    ffmpeg -i "%input_mp3%" -loop 1 -i "%input_img%" -filter_complex "[1:v]scale=1280:720[bg];[0:a]showwaves=s=1280x720:mode=cline:rate=25:colors=white[wave];[bg][wave]overlay=shortest=1,boxblur=2:1" -c:v libx264 -c:a aac -shortest -y "%output_file%"
    goto :WAVEFORM_DONE
)