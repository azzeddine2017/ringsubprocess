load "../subprocess.ring"

? "YouTube Video Information Example using yt-dlp"
? "====================================="

proc = new ProcessManager()


# Example video URL (you can change this)
videoUrl = "https://www.youtube.com/watch?v=uhUht6vAsMY"

? "Getting video information..."
info = getVideoInfo(videoUrl)
if len(info) > 0 {
    ? "Video found!"
    ? "Starting download process..."
    if downloadVideo(videoUrl) {
        ? "Download completed successfully!"
        ? "Exit code: " + proc.getExitCode()
    else
        ? "Download failed!"
        ? "Error code: " + proc.getExitCode()
        error = proc.getStderr()
        if len(error) > 0 {
            ? "Error details: " + error
        }
    }
else
    ? "Failed to get video information"
}

# Clean up
proc.kill()


func getVideoInfo videoUrl
    command = 'yt-dlp --get-description ' + videoUrl
    
    if proc.runCommand(command) {
        proc.waitForComplete()
        return proc.readOutput()
    }
    return ""

func downloadVideo videoUrl
    ? "\nStarting download..."
    # Using yt-dlp with better default options
    command = 'yt-dlp -f "bv+ba/b" ' + videoUrl
    
    if proc.runCommandAsync(command) {
        while true {
            output = proc.readOutputAsync()
            if len(output) = 0 { exit }
            ? output  # Progress will be shown line by line
        }
        proc.waitForComplete()
        return proc.getExitCode() = 0
    }
    return false

