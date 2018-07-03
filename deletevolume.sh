#!/bin/bash
aws ec2 describe-volumes --filters Name=status,Values=available --query "Volumes[*].{ID:VolumeId}" --output text > volume
while read LINE; do aws ec2 delete-volume --volume-id "$LINE"; done < volume
