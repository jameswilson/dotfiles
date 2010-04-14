#!/bin/sh
ifconfig | grep 'broadcast' | awk '{print "internal ip: " $2}'
curl -s www.whatismyip.com/automation/n09230945.asp | awk '{print "external ip: " $0}'
