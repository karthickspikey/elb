#!/bin/bash
REGION="ap-south-1"
OWNER="080631660430"
DATE=$(date +%Y-%m-%d --date '30 days ago')
echo "$REGION"
echo "$OWNER"
echo "$DATE"
echo "====================Generate list of all snapshots to snapall.txt============================"
aws ec2 describe-snapshots --owner "$OWNER" --region "$REGION" --query 'Snapshots[?StartTime<=`$DATE`].SnapshotId' | grep --line-buffered snap-*  | awk '{print $1}' | sed 's/\"//g' | sed  's/,//g' > snapall.txt
echo "====================Generating all ami attached snapshots to snapexclude.txt============================"
aws ec2 describe-snapshots --owner "$OWNER" --region "$REGION" --query 'Snapshots[?StartTime<=`$DATE`].SnapshotId' --filters "Name=description,Values=Created *" | grep --line-buffered snap-*  | awk '{print $1}' | sed 's/\"//g' | sed  's/,//g' > snapexclude.txt
echo "====================Generate list of diff to sorted.txt============================"
comm -3 <(sort snapall.txt) <(sort snapexclude.txt) > sorted.txt
echo "====================delete all snapshots============================"
while read LINE; do aws ec2 delete-snapshot --snapshot-id "$LINE"; done < sorted.txt
