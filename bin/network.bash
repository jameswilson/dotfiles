#!/bin/bash

# isp [ip.address] [whois.server.tld]
isp() {
	
	whoisserver=$2;
	if [ -z "$2" ]; then
		whoisserver="whois.arin.net";
	fi
	lookup="whois -h $whoisserver $1";
	referralserver=`$lookup | grep -e 'ReferralServer: whois://' | sed 's/ReferralServer: whois:\/\///g'`;#
	
	if [ -n "$referralserver" ]; then
		isp $1 $referralserver;
		return;
	fi
	
	#else ...
	isp1=`$lookup | grep -e "netname:"  | awk '{print $2}'`;
	if [ -z "$isp1" ]; then
		isp1=`$lookup | grep -e "owner:" | awk '{print $2}'`;
	fi
	if [ -z "$isp1" ]; then
		isp1=`$lookup | grep -e "OrgId:" | awk '{print $2}'`;
	fi
	if [ -z "$isp1" ]; then
		isp1=`$lookup | grep -e "OrgName:" | awk '{print $2}'`;
	fi
	return;
}


myen0=`ifconfig en0 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
myen1=`ifconfig en1 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
myvar1=`system_profiler SPAirPortDataType | grep -e "Current Wireless Network:" | awk '{print $4}'`
myvar2=`system_profiler SPAirPortDataType | grep -e "Wireless Channel:" | awk '{print $3}'`
router=`netstat -rn | grep -e "default" | awk '{print $2}'`
dns=`cat /etc/resolv.conf | grep -e "nameserver" | awk '{print $2}'`
network=1;
if [ -n "$myen0" ]; then 
	if [ -n "$myen1" ]; then 
		echo "Connection : Ethernet | Airport [$myvar1 : $myvar2]";
		echo "IP Address : $myen0 | $myen1" ;
	else 
		echo "Connection : Ethernet";
		echo "IP Address : $myen0" ; 
	fi
else 
	if [ -n "$myen1" ]; then 
		echo "Connection : Airport [$myvar1 : $myvar2]" ;
		echo "IP Address : $myen1" ;
	else 
		echo "Connection : No Network" ;
		echo "IP Address : No Network" ;
		network=0;
	fi
fi
if [ "$network" = "1" ]; then
	ext1=`curl -s ipecho.net/plain`
	echo "External : $ext1";
	isp $ext1
	echo "ISP : $isp1";
fi
echo "Router : $router"
if [ "$router" != "$dns" ]; then 
	dns=`system_profiler SPNetworkDataType | grep -e "Server Addresses: " | awk '{print $3, $4}'` ;
	echo "DNS Servers: $dns" ;
else 
	echo "DNS Servers: No DNS Detected"
fi




