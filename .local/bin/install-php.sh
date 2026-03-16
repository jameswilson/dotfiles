#!/usr/bin/env bash

# Install Composer tools.
mkdir -p ~/.local/bin
cd ~/.local/bin
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --filename=composer
rm -f composer-setup.php
chmod +x composer
