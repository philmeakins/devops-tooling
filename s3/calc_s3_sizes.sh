#!/bin/bash

# Function to convert bytes to a human-readable format
human_readable_size() {
    local size=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0

    while ((size > 1024 && unit < ${#units[@]} - 1)); do
        size=$((size / 1024))
        ((unit++))
    done

    echo "$size ${units[$unit]}"
}

# Get the list of all buckets
buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# Iterate over each bucket to calculate its size
for bucket in $buckets; do

    # Get the total size of the bucket
    size=0
    size_hr="0 B"
    size=$(aws s3api list-objects --bucket "$bucket" --output json --query "sum(Contents[].Size)" 2>  /dev/null)
    if [[ $? -eq 0 ]] ; then
      size_hr=$(human_readable_size "$size")
    else
     size=0
    fi

    echo "${bucket},${size_hr},${size}"
done

