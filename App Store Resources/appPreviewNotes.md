# App Preview

Notes on app preview

## Video

- Video must have audio
	- ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -i preview.mp4 -shortest -c:v copy -c:a aac previewWithSilence.mp4
	
- Must be 30fps
	- ffmpeg -i preview.mp4 -filter:v fps=fps=30 preview30fps.mp4