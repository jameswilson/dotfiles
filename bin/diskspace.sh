#!/bin/bash

df -h | grep disk0s2 | awk '{print "System:", $3, "of", $2, "-", $4, "available"}' | sed 's/Gi/Gb/g';
df -h | grep disk0s3 | awk '{print "UserHD:", $3, "of", $2, "-", $4, "available"}' | sed 's/Gi/Gb/g';
exit 0;