#!/bin/bash
function pad {
	string="$1"; num="$2"; count=$(echo -n "$string" | wc -c); ((count += 0))
	while (( count < num )); do string=" $string"; ((count += 1)); done
	echo -n "$string"
}
idx=0; mode="media"; info=$(ifconfig | fgrep -B 2 netmask)
for i in $info; do
	case "$mode" in
		media)
			case "$i" in
				en0*)	media[$idx]="Ethernet"; mode="ip";;
				en1*)	media[$idx]="WiFi"; mode="ip";;
				en*)	media[$idx]=""; mode="ip";;
			esac;;
		ip)
			if [[ "$i" == [0-9]*.[0-9]*.[0-9]*.[0-9]* ]]; then
				ip[$idx]="$i"; ((idx += 1)); mode="media"
			fi;;
	esac
done
for ((i=0; i < ${#media[*]}; i++)); do
	if [[ $ip ]]; then
		ip=$(pad ${ip[$i]:-Unknown} 15)
		echo "Internal  $ip    (via ${media[$i]})"
	fi
done
ip=$(curl -s www.whatismyip.com/automation/n09230945.asp)
ip=$(pad ${ip:-Unknown} 15)
echo "External  $ip"