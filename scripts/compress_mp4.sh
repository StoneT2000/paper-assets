#!/bin/bash

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 input_video"
    exit 1
fi

input_file="$1"
output_file="${input_file%.*}_compressed.mp4"

# Compress video using ffmpeg with reasonable defaults for compression
ffmpeg -i "$input_file" \
    -c:v libx264 \
    -preset medium \
    -crf 23 \
    -c:a aac \
    -b:a 128k \
    "$output_file"
# Calculate and display compression ratio
original_size=$(stat --format="%s" "$input_file")
compressed_size=$(stat --format="%s" "$output_file")
compression_ratio=$(echo "scale=2; 100 - ($compressed_size * 100 / $original_size)" | bc)
echo "Compression: $(numfmt --to=iec-i --suffix=B ${original_size}) -> $(numfmt --to=iec-i --suffix=B ${compressed_size}), $(if (( $(echo "$compression_ratio < 0" | bc -l) )); then echo ""; else echo "+"; fi)${compression_ratio}%"

echo "Compressed video saved as: $output_file"
