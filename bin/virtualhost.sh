#!/bin/bash
# $Id: virtualhost.sh 13 2008-04-23 17:19:55Z patrickg.com $
#================================================================================
# virtualhost.sh                                                $Revision: 1.17 $
#
# A fancy little script to setup a new virtualhost in Mac OS X.
#
# If you want to delete a virtualhost that you've created, you need to:
#
# sudo ./virtualhost.sh --delete <site>
#
# where <site> is the site name you used when you first created the host.
#
# CHANGES SINCE v1.16
# - You can now store any configuration values in ~/.virtualhost.sh.conf.
#   This way, you can update the script without losing your settings.
#
# CHANGES SINCE v1.15
# - Add feature to support a ServerAlias using a wildcard DNS host. See the
#   Wiki at http://code.google.com/p/virtualhost-sh/wiki/Wildcard_Hosts
#
# CHANGES SINCE v1.14
# - Fix a bug in host_exists() that caused it never to work (thanks to Daniel
#   Jewett for finding that).
#
# CHANGES SINCE v1.13
# - Fix check in /etc/hosts to better match the supplied virtualhost.
# - Fix check for existing folder in your Sites folder.
#
# CHANGES SINCE v1.05
# - Support for Leopard. In fact, this version only supports Leopard, and 1.05
#   will be the last version for Tiger and below.
#
# CHANGES SINCE v1.04
# - The $APACHECTL variable wasn't been used. (Thanks to Thomas of webtypes.com)
#
# CHANGES SINCE v1.03
# - An oversight in the change in v1.03 caused the ownership to be incorrect for
#   a tree of folders that was created. If your site folder is a few levels deep
#   we now fix the ownership properly of each nested folder.  (Thanks again to
#   Michael Allan for pointing this out.)
#
# - Improved the confirmation page for when you create a new virtual host. Not
#   only is it more informative, but it is also much more attractive.
#
# CHANGES SINCE v1.02
# - When creating the website folder, we now create all the intermediate folders
#   in the case where a user sets their folder to something like 
#   clients/project_a/mysite. (Thanks to Michael Allan for pointing this out.)
#
# CHANGES SINCE v1.01
# - Allow for the configuration of the Apache configuration path and the path to
#   apachectl.
#
# CHANGES SINCE v1.0
# - Use absolute path to apachectl, as it looks like systems that were upgraded
#   from Jaguar to Panther don't seem to have it in the PATH.
#
#
# by Patrick Gibson <patrick@patrickg.com>
#================================================================================
#
# No point going any farther if we're not running correctly...
if [ `whoami` != 'root' ]; then

	echo "You must be running with root privileges to run this script."
	echo "Rerun using: sudo $0 $*"
	exit

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If you are using this script on a production machine with a static IP address,
# and you wish to setup a "live" virtualhost, you can change the following IP
# address to the IP address of your machine.
#
IP_ADDRESS="127.0.0.1"

# By default, this script places files in /Users/[you]/Sites. If you would like
# to change this, like to how Apple does things by default, uncomment the
# following line:
#
#DOC_ROOT_PREFIX="/Library/WebServer/Documents"

# Configure the apache-related paths
#
APACHE_CONFIG="/private/etc/apache2"
APACHECTL="/usr/sbin/apachectl"

# By default, use the site folders that get created will be 0wn3d by this group
OWNER_GROUP="$SUDO_USER"

# If defined, a ServerAlias os $1.$WILDCARD_ZONE will be added to the virtual
# host file. This is useful if you, for example, have setup a wildcard domain
# either on your own DNS server or using a server like dyndns.org. For example,
# if my local IP of 10.0.42.42 is static (which can still be achieved using a
# well-configured DHCP server or an Apple Airport Extreme 802.11n base station)
# and I create a host on dyndns.org of patrickdev.dyndns.org with wildcard
# hostnames turned on, then defining my WILDCARD_ZONE to "patrickdev.dyndns.org"
# will enable access to my virtual host from any machine on the network. Note
# that this would also work with a public IP too, and the virtual hosts on your
# machine would be accessible to anyone on the internets.
#WILDCARD_ZONE="my.wildcard.host.address"

# You can now store your configuration directions in a ~/.virtualhost.sh.conf
# file so that you can download new versions of the script without having to
# redo your own settings.
if [ -e /Users/$SUDO_USER/.virtualhost.sh.conf ]; then
	. /Users/$SUDO_USER/.virtualhost.sh.conf
fi



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

host_exists()
{
	if grep -q -e "^$IP_ADDRESS	$1$" /etc/hosts ; then
		return 0
	else
		return 1
	fi
}

create_virtualhost()
{
	if [ ! -z $WILDCARD_ZONE ]; then
		SERVER_ALIAS="ServerAlias $1.$WILDCARD_ZONE"
	else
		SERVER_ALIAS="#ServerAlias your.alias.here"
	fi
	date=`/bin/date`
	cat << __EOF >$APACHE_CONFIG/virtualhosts/$1
# Created $date
<VirtualHost *:80>
  DocumentRoot $2
  ServerName $1
  $SERVER_ALIAS

  ScriptAlias /cgi-bin $2/cgi-bin

  <Directory $2>
    Options All
    AllowOverride All
    Order allow,deny
    Allow from all
  </Directory>
</VirtualHost>
__EOF
}

cleanup()
{
	echo
	echo "Cleaning up..."
	exit
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Make sure this is an Apache 2.x / Leopard machine
if [ ! -d /etc/apache2 ]; then
	echo "Sorry, this version of virtualhost.sh only works with Leopard. You can download an older version which works with previous versions of Mac OS X here:"
	echo
	echo "http://patrickgibson.com/news/andsuch/virtualhost.tgz"
	echo
	
	exit 1
fi


# catch Ctrl-C
#trap 'cleanup' 2

# restore it
#trap '' 2

if [ -z $USER -o $USER = "root" ]; then
	if [ ! -z $SUDO_USER ]; then
		USER=$SUDO_USER
	else
		USER=""

		echo "ALERT! Your root shell did not provide your username."

		while : ; do
			if [ -z $USER ]; then
				while : ; do
					echo -n "Please enter *your* username: "
					read USER
					if [ -d /Users/$USER ]; then
						break
					else
						echo "$USER is not a valid username."
					fi
				done
			else
				break
			fi
		done
	fi
fi

if [ -z $DOC_ROOT_PREFIX ]; then
	DOC_ROOT_PREFIX="/Users/$USER/Sites"
fi

usage()
{
	cat << __EOT
Usage: sudo virtualhost.sh <name>
       sudo virtualhost.sh --delete <name>
   where <name> is the one-word name you'd like to use. (e.g. mysite)
   
   Note that if "virtualhost.sh" is not in your PATH, you will have to write
   out the full path to it: eg. /Users/$USER/Desktop/virtualhost.sh <name>

__EOT
	exit 1
}

if [ -z $1 ]; then
	usage
else
	if [ $1 = "--delete" ]; then
		if [ -z $2 ]; then
			usage
		else
			VIRTUALHOST=$2
			DELETE=0
		fi		
	else
		VIRTUALHOST=$1
	fi
fi

# Test that the virtualhost name is valid (starts with a number or letter)
if ! echo $VIRTUALHOST | grep -q -E '^[A-Za-z0-9]+' ; then
	echo "Sorry, '$VIRTUALHOST' is not a valid host name to use. It must start with a letter or number."
	exit 1
fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete the virtualhost if that's the requested action
#
if [ ! -z $DELETE ]; then
	echo -n "- Deleting virtualhost, $VIRTUALHOST... Continue? [Y/n]: "

	read continue
	
	case $continue in
	n*|N*) exit
	esac

	if host_exists $VIRTUALHOST ; then
		echo -n "  - Removing $VIRTUALHOST from /etc/hosts... "
				
		cat /etc/hosts | grep -v $VIRTUALHOST > /tmp/hosts.tmp
	
		if [ -s /tmp/hosts.tmp ]; then
			mv /tmp/hosts.tmp /etc/hosts
		fi

		echo "done"
		
		if [ -e $APACHE_CONFIG/virtualhosts/$VIRTUALHOST ]; then
			DOCUMENT_ROOT=`grep DocumentRoot $APACHE_CONFIG/virtualhosts/$VIRTUALHOST | awk '{print $2}'`

			if [ -d $DOCUMENT_ROOT ]; then
				echo -n "  + Found DocumentRoot $DOCUMENT_ROOT. Delete this folder? [y/N]: "

				read resp
			
				case $resp in
				y*|Y*)
					echo -n "  - Deleting folder... "
					if rm -rf $DOCUMENT_ROOT ; then
						echo "done"
					else
						echo "Could not delete $DOCUMENT_ROOT"
					fi
				;;
				esac
			fi
				
			echo -n "  - Deleting virtualhost file... ($APACHE_CONFIG/virtualhosts/$VIRTUALHOST) "
			rm $APACHE_CONFIG/virtualhosts/$VIRTUALHOST
			echo "done"

			echo -n "+ Restarting Apache... "
			$APACHECTL graceful 1>/dev/null 2>/dev/null
			echo "done"
		fi
	else
		echo "- Virtualhost $VIRTUALHOST does not currently exist. Aborting..."
	fi

	exit
fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure $APACHE_CONFIG/httpd.conf is ready for virtual hosting...
#
# If it's not, we will:
#
# a) Backup the original to $APACHE_CONFIG/httpd.conf.original
# b) Add a NameVirtualHost 127.0.0.1 line
# c) Create $APACHE_CONFIG/virtualhosts/ (virtualhost definition files reside here)
# d) Add a line to include all files in $APACHE_CONFIG/virtualhosts/
# e) Create a _localhost file for the default "localhost" virtualhost
#

if ! grep -q -e "^DocumentRoot \"$DOC_ROOT_PREFIX\"" $APACHE_CONFIG/httpd.conf ; then
	echo "httpd.conf's DocumentRoot does not point where it should."
	echo -n "Do you with to set it to $DOC_ROOT_PREFIX? [Y/n]: "	
	read DOCUMENT_ROOT
	case $DOCUMENT_ROOT in
	n*|N*)
		echo "Okay, just re-run this script if you change your mind."
	;;
	*)
		cat << __EOT | ed $APACHE_CONFIG/httpd.conf 1>/dev/null 2>/dev/null
/^DocumentRoot
i
#
.
j
+
i
DocumentRoot "$DOC_ROOT_PREFIX"
.
w
q
__EOT
	;;
	esac
fi

if ! grep -q -E "^NameVirtualHost \*:80" $APACHE_CONFIG/httpd.conf ; then

	echo "httpd.conf not ready for virtual hosting. Fixing..."
	cp $APACHE_CONFIG/httpd.conf $APACHE_CONFIG/httpd.conf.original
	echo "NameVirtualHost *:80" >> $APACHE_CONFIG/httpd.conf
	
	if [ ! -d $APACHE_CONFIG/virtualhosts ]; then
		mkdir $APACHE_CONFIG/virtualhosts
		create_virtualhost localhost $DOC_ROOT_PREFIX
	fi

	echo "Include $APACHE_CONFIG/virtualhosts"  >> $APACHE_CONFIG/httpd.conf


fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Look for hosts created in Tiger
#
if [ -d /etc/httpd/virtualhosts ]; then

	echo -n "Do you want to port the hosts you previously created in Tiger to the new system? [Y/n]: "
	read PORT_HOSTS
	case $PORT_HOSTS in
	n*|N*)
		echo "Okay, just re-run this script if you change your mind."
	;;

	*)
		for host in `ls -1 /etc/httpd/virtualhosts | grep -v _localhost`; do
			echo -n "  + Creating $host... "
			if ! host_exists $host ; then
				echo "$IP_ADDRESS	$host" >> /etc/hosts
			fi
			docroot=`grep DocumentRoot /etc/httpd/virtualhosts/$host | awk '{print $2}'`
			create_virtualhost $host $docroot
			echo "done"
		done
		
		mv /etc/httpd/virtualhosts /etc/httpd/virtualhosts-ported
	;;
	esac


fi


echo -n "Create http://$VIRTUALHOST/? [Y/n]: "

read continue

case $continue in
n*|N*) exit
esac


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If the host is not already defined in /etc/hosts, define it...
#

if ! host_exists $VIRTUALHOST ; then

	echo "Creating a virtualhost for $VIRTUALHOST..."
	echo -n "+ Adding $VIRTUALHOST to /etc/hosts... "
	echo "$IP_ADDRESS	$1" >> /etc/hosts
	echo "done"
fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ask the user where they would like to put the files for this virtual host
#
echo -n "+ Checking for $DOC_ROOT_PREFIX/$VIRTUALHOST... "

if [ ! -d $DOC_ROOT_PREFIX/$VIRTUALHOST ]; then
	echo "not found"
else
	echo "found"
fi
	
# See if we can find an appropriate folder
if ls -1 $DOC_ROOT_PREFIX | grep -q -e ^$VIRTUALHOST; then
	DOC_ROOT_FOLDER_MATCH=`ls -1 $DOC_ROOT_PREFIX | grep -e ^$VIRTUALHOST | head -n 1`
	echo -n "  - Use $DOC_ROOT_PREFIX/$DOC_ROOT_FOLDER_MATCH as the virtualhost folder? [Y/n] "
else
	echo -n "  - Use $DOC_ROOT_PREFIX/$VIRTUALHOST as the virtualhost folder? [Y/n] "
fi


read resp

case $resp in

	n*|N*) 
		while : ; do
			if [ -z $FOLDER ]; then
				echo -n "  - Enter new folder name (located in Sites): "
				read FOLDER
			else
				break
			fi
		done
	;;

	*)
		if [ -z $DOC_ROOT_FOLDER_MATCH ]; then
			FOLDER=$VIRTUALHOST
		else
			FOLDER=$DOC_ROOT_FOLDER_MATCH
		fi
	;;
esac


# Create the folder if we need to...
if [ ! -d $DOC_ROOT_PREFIX/$FOLDER ]; then
	echo -n "  + Creating folder $DOC_ROOT_PREFIX/$FOLDER... "
	# su $USER -c "mkdir -p $DOC_ROOT_PREFIX/$FOLDER"
	mkdir -p $DOC_ROOT_PREFIX/$FOLDER
	
	# If $FOLDER is deeper than one level, we need to fix permissions properly
	case $FOLDER in
		*/*)
			subfolder=0
		;;
	
		*)
			subfolder=1
		;;
	esac

	if [ $subfolder != 1 ]; then
		# Loop through all the subfolders, fixing permissions as we go
		#
		# Note to fellow shell-scripters: I realize that I could avoid doing
		# this by just creating the folders with `su $USER -c mkdir ...`, but
		# I didn't think of it until about five minutes after I wrote this. I
		# decided to keep with this method so that I have a reference for myself
		# of a loop that moves down a tree of folders, as it may come in handy
		# in the future for me.
		dir=$FOLDER
		while [ $dir != "." ]; do
			chown $USER:$OWNER_GROUP $DOC_ROOT_PREFIX/$dir
			dir=`dirname $dir`
		done
	else
		chown $USER:$OWNER_GROUP $DOC_ROOT_PREFIX/$FOLDER
	fi
	
	echo "done"
fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a default index.html if there isn't already one there
#
if [ ! -e $DOC_ROOT_PREFIX/$FOLDER/index.html -a ! -e $DOC_ROOT_PREFIX/$FOLDER/index.php ]; then

	cat << __EOF >$DOC_ROOT_PREFIX/$FOLDER/index.html
<html>
<head>
<title>Welcome to $VIRTUALHOST</title>
<style type="text/css">
 body, div, td { font-family: "Lucida Grande"; font-size: 12px; color: #666666; }
 b { color: #333333; }
 .indent { margin-left: 10px; }
</style>
</head>
<body link="#993300" vlink="#771100" alink="#ff6600">

<table border="0" width="100%" height="95%"><tr><td align="center" valign="middle">
<div style="width: 500px; background-color: #eeeeee; border: 1px dotted #cccccc; padding: 20px; padding-top: 15px;">
 <div align="center" style="font-size: 14px; font-weight: bold;">
  Congratulations!
 </div>

 <div align="left">
  <p>If you are reading this in your web browser, then the only logical conclusion is that the <b><a href="http://$VIRTUALHOST/">http://$VIRTUALHOST/</a></b> virtualhost was setup correctly. :)</p>
  
  <p>You can find the configuration file for this virtual host in:<br>
  <table class="indent" border="0" cellspacing="3">
   <tr>
    <td><img src="/icons/script.gif" width="20" height="22" border="0"></td>
    <td><b>$APACHE_CONFIG/virtualhosts/$VIRTUALHOST</b></td>
   </tr>
  </table>
  </p>
  
  <p>You will need to place all of your website files in:<br>
  <table class="indent" border="0" cellspacing="3">
   <tr>
    <td><img src="/icons/dir.gif" width="20" height="22" border="0"></td>
    <td><b><a href="file://$DOC_ROOT_PREFIX/$FOLDER">$DOC_ROOT_PREFIX/$FOLDER</b></a></td>
   </tr>
  </table>
  </p>
  
  <p>For the latest version of this script, tips, comments, <span style="font-size: 10px; color: #999999;">donations,</span> etc. visit:<br>
  <table class="indent" border="0" cellspacing="3">
   <tr>
    <td><img src="/icons/forward.gif" width="20" height="22" border="0"></td>
    <td><b><a href="http://patrickg.com/virtualhost">http://patrickg.com/virtualhost</a></b></td>
   </tr>
  </table>
  </p>
 </div>

</div>
</td></tr></table>

</body>
</html>
__EOF
	chown $USER:$OWNER_GROUP $DOC_ROOT_PREFIX/$FOLDER/index.html

fi	


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a default virtualhost file
#
echo -n "+ Creating virtualhost file... "
create_virtualhost $VIRTUALHOST $DOC_ROOT_PREFIX/$FOLDER
echo "done"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Restart apache for the changes to take effect
#
echo -n "+ Flushing cache... "
dscacheutil -flushcache
sleep 1
echo "done"

dscacheutil -q host | grep -q $VIRTUALHOST

echo -n "+ Restarting Apache... "
$APACHECTL graceful 1>/dev/null 2>/dev/null
echo "done"

cat << __EOF

http://$VIRTUALHOST/ is setup and ready for use.

__EOF


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Launch the new URL in the browser
#
echo -n "Launching virtualhost... "
open http://$VIRTUALHOST/
echo "done"

