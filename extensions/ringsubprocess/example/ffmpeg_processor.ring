load "subprocess.ring"

/*
    Advanced FFmpeg Video Processing Example
    Features:
    1. Video concatenation
    2. Image sequence to video
    3. Complex filters
    4. Audio processing
    5. Video compression
    6. Watermark addition
    7. Video information extraction
    8. GIF creation
    9. Video trimming
    10. Format conversion
*/



? "FFmpeg Processing Examples"
? "======================="

processor = new FFmpegProcessor()

# Basic Examples
videos = ["video1.mp4", "video2.mp4", "video3.mp4"]
processor.concatenateVideos(videos, "output_concat.mp4")

processor.createVideoFromImages(
    "frames/img%03d.jpg",
    "timelapse.mp4",
    "24"
)

# Advanced Examples
processor.extractAudio("input.mp4", "audio.mp3")

processor.compressVideo("input.mp4", "compressed.mp4", "23")

processor.addWatermark(
    "input.mp4",
    "logo.png",
    "watermarked.mp4",
    "main_w-overlay_w-10:main_h-overlay_h-10"
)

? "Video Information:"
? processor.getVideoInfo("input.mp4")

processor.createGif(
    "input.mp4",
    "output.gif",
    "10",
    "320"
)

processor.trimVideo(
    "input.mp4",
    "trimmed.mp4",
    "00:00:10",
    "00:00:30"
)

processor.convertFormat(
    "input.mp4",
    "output.mkv"
)

processor.addSubtitles(
    "input.mp4",
    "subtitles.srt",
    "with_subtitles.mp4"
)

processor.mergeVideoAudio(
    "video.mp4",
    "audio.mp3",
    "final.mp4"
)

? nl + "Processing complete!"
? "Check the output files in your directory"


Class FFmpegProcessor {
    proc
    
    func init
        proc = new ProcessManager()
    
    func createConcatList files
        content = ""
        for file in files
            content += "file '" + file + "'" + nl
        next
        return content
    
    func concatenateVideos inputFiles, output
        ? "Concatenating videos..."
        proc.runCommand('ffmpeg -f concat -safe 0 -protocol_whitelist "file,pipe" -i pipe:0 -c copy ' + output)
        proc.setStdin(createConcatList(inputFiles))
        see proc.readOutput() + nl
        proc.kill()
    
    func createVideoFromImages pattern, output, fps
        ? "Creating video from images..."
        cmd = 'ffmpeg -framerate ' + fps + ' -i "' + pattern + 
              '" -c:v libx264 -pix_fmt yuv420p ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func applyComplexFilter input, output, filter
        ? "Applying complex filter..."
        cmd = 'ffmpeg -i "' + input + '" -vf "' + filter + '" ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    # New Functions

    func extractAudio input, output
        ? "Extracting audio..."
        cmd = 'ffmpeg -i "' + input + '" -vn -acodec copy ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func compressVideo input, output, crf
        ? "Compressing video..."
        cmd = 'ffmpeg -i "' + input + '" -c:v libx264 -crf ' + crf + ' -c:a aac ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func addWatermark video, watermark, output, position
        ? "Adding watermark..."
        cmd = 'ffmpeg -i "' + video + '" -i "' + watermark + 
              '" -filter_complex "overlay=' + position + '" ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func getVideoInfo video
        ? "Getting video information..."
        cmd = 'ffprobe -v quiet -print_format json -show_format -show_streams "' + video + '"'
        proc.runCommand(cmd)
        return proc.readOutput()
    
    func createGif input, output, fps, scale
        ? "Creating GIF..."
        cmd = 'ffmpeg -i "' + input + '" -vf "fps=' + fps + ',scale=' + scale + 
              '::-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func trimVideo input, output, start, duration
        ? "Trimming video..."
        cmd = 'ffmpeg -i "' + input + '" -ss ' + start + ' -t ' + duration + 
              ' -c:v copy -c:a copy ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func convertFormat input, output
        ? "Converting format..."
        cmd = 'ffmpeg -i "' + input + '" -c:v libx264 -c:a aac ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func addSubtitles video, subtitles, output
        ? "Adding subtitles..."
        cmd = 'ffmpeg -i "' + video + '" -vf "subtitles=' + subtitles + '" ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
    
    func mergeVideoAudio video, audio, output
        ? "Merging video and audio..."
        cmd = 'ffmpeg -i "' + video + '" -i "' + audio + 
              '" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 ' + output
        proc.runCommand(cmd)
        see proc.readOutput() + nl
        proc.kill()
}
