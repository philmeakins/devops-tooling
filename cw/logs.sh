#!/bin/bash

region=us-east-1

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



# for log in $(cat cw_logs |awk '{print $6","$NF}')
for log in $(aws --region $region logs describe-log-groups --output text  |awk '{print $6","$NF}')
do

    log_group=$(echo $log | cut -d, -f1)
    log_size=$(echo $log | cut -d, -f2)

    size_hr=$(human_readable_size "$log_size")

    echo "$log_group,$size_hr,$log_size"

done

