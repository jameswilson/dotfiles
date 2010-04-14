#!/bin/bash

# OS X Rails Auto Installation Pak
# Latest documentation: http://wearesakuzaku.com/goodie_basket/os_x_rails_auto_installation_pak
#
# By: Sakuzaku
# Author: Cody Robbins (cody@wearesakuzaku.com)
# Location: $URL$
# Date: $Date$
# Revision: $Revision$
#
# Released under the MIT License. Copyright (c) 2006-2007 Sakuzaku, LLC.

echo 'Creating a directory for sources...'
sudo mkdir -p /usr/local/src
sudo chgrp admin /usr/local/src
sudo chmod -R 775 /usr/local/src
cd /usr/local/src

echo 'Downloading sources...'
curl -O ftp://ftp.gnu.org/gnu/readline/readline-5.2.tar.gz -O ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.6.tar.gz -O http://files.rubyforge.mmmultiworks.com/rubygems/rubygems-0.9.4.tgz -O http://subversion.tigris.org/downloads/subversion-1.4.5.tar.gz -O http://subversion.tigris.org/downloads/subversion-deps-1.4.5.tar.gz #-o mysql.dmg ftp://mirror.services.wisc.edu/mirrors/mysql/Downloads/MySQL-5.0/mysql-5.0.45-osx10.4-i686.dmg
for file in *gz
do
 tar -xzf $file
done
rm *gz

echo 'Installing readline...'
cd readline-*
./configure --prefix=/usr/local
make
sudo make install
cd ..

echo 'Installing Ruby...'
cd ruby-*
./configure --prefix=/usr/local --enable-pthread --with-readline-dir=/usr/local --enable-shared
make
sudo make install
sudo make install-doc
cd ..

echo 'Installing Rubygems...'
cd rubygems-*
sudo /usr/local/bin/ruby setup.rb
cd ..

echo 'Installing Subversion...'
cd subversion-*
./configure --prefix=/usr/local --with-openssl --with-ssl --with-zlib
make
sudo make install
cd ..

echo 'Installing the Rails, Mongrel, and Capistrano gems...'
sudo gem install rails mongrel capistrano termios --remote --include-dependencies

echo 'Installing MySQL...'
cd ..
volume=`hdiutil attach mysql.dmg | cut -f 3 | grep .`
echo 'volume is: ' $volume
open $volume/mysql-5.0.45-osx10.4-i686.pkg
open $volume/MySQL.prefPane
echo 'Please hit [ENTER] after MySQL and the MySQL Preference Pane have been successfully installed...'
read
hdiutil detach $volume

echo 'Installing the MySQL gem...'
sudo gem install mysql --remote --include-dependencies -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

echo 'Done!'
