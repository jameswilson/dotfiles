#!/bin/bash

echo `date "+%d %B %Y"` | awk '{ print substr(" ",1,(21-length($0))/2) $0; }';
cal | awk -v cday=`date "+%d"` '{ fill=(int(cday)>9?"":" "); a=$0; sub(" "fill int(cday)" ","*"fill int(cday)"*",a); print a }'

