#!/bin/bash

# Check if a pattern is provided as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_pattern>"
    echo "Example: $0 '*.mp4' or $0 'video*.webm'"
    exit 1
fi

pattern="$1"

# Find all matching video files
for video_file in $pattern; do
    # Skip if pattern doesn't match any files
    [ -f "$video_file" ] || continue
    
    # Generate output filename
    thumb_file="${video_file%.*}_thumb.jpg"
    
    echo "Processing: $video_file"
    
    # Generate thumbnail from first frame using ffmpeg, directly to jpg
    ffmpeg -y -i "$video_file" -vframes 1 -an -ss 0 "$thumb_file" -loglevel error
    
    if [ $? -eq 0 ]; then
        echo "Generated thumbnail: $thumb_file"
    else
        echo "Error generating thumbnail for $video_file"
    fi
done
