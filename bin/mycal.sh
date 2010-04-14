#!/bin/sh
# taken from http://www.macosxhints.com/article.php?story=20040625094428394

month=`date +%m`
year=`date +%Y`
currDay=`date "+%d"`

getDate()
{
# syntax: getDate monthGap
themonth=$(($month+$1))
theyear=$year
 if [[ $themonth -gt 12 ]]
 then
    themonth=$(($themonth-12))
    theyear=$(($theyear+1))
 fi
 if [[ $themonth -lt 1 ]]
 then
    themonth=$((12-$themonth))
    theyear=$(($theyear-1))
 fi
 echo $themonth " " $theyear
}

MarkToday()
{
awk -v cday=$currDay '{ fill=(int(cday)>9?"":" "); a=$0; sub(" "fill int(cday)" ","*"fill int(cday)"*",a); print  a }'
}

doCalUS()
{
cal $(getDate -1)
echo
cal $month $year | awk '{ print " " $0 " " }' | MarkToday
echo
cal $(getDate 1)
}

doCalUS | pr -3 -t -i100 | colrm 22 23
