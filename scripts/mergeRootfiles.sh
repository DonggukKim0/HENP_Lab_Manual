#!/bin/bash

# Check arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <directory_to_search> <target_filename>"
  exit 1
fi

SEARCH_DIR="$1"
TARGET_FILENAME="$2"
OUTPUT_FILENAME="merged_AnalysisResults.root"

FILE_COUNT=$(find "$SEARCH_DIR" -type f -name "$TARGET_FILENAME" | wc -l)
echo "Number of files to merge: $FILE_COUNT"

# Collect files to merge
files=( $(find "$SEARCH_DIR" -type f -name "$TARGET_FILENAME") )
total=${#files[@]}
echo "Merging $total files with progress bar..."

# Iteratively merge and update progress
for idx in "${!files[@]}"; do
  file="${files[$idx]}"
  if [ "$idx" -eq 0 ]; then
    cp "$file" "$OUTPUT_FILENAME"
  else
    hadd -f temp.root "$OUTPUT_FILENAME" "$file"
    mv temp.root "$OUTPUT_FILENAME"
  fi
  done_count=$((idx + 1))
  percent=$(( done_count * 100 / total ))
  bar_width=40
  filled=$(( percent * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  bar=$(printf "%0.s#" $(seq 1 $filled))
  dash=$(printf "%0.s-" $(seq 1 $empty))
  printf "\r[%s%s] %3d%% (%d/%d)" "$bar" "$dash" "$percent" "$done_count" "$total"
done

# Final newline and completion message
echo -e "\nMerged files saved to: $OUTPUT_FILENAME"