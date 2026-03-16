#!/usr/bin/env bash

# Install Composer tools.
mkdir -p ~/.local/bin
cd ~/.local/bin
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --filename=composer
rm -f composer-setup.php
chmod +x composer

# Install Drupal.org CLI tools.
curl -OL https://github.com/mglaman/drupalorg-cli/releases/latest/download/drupalorg.phar
chmod +x drupalorg.phar
mv drupalorg.phar /usr/local/bin/drupalorg
mkdir -p ~/.zsh/completions
cd ~/.zsh/completions
curl -L https://raw.githubusercontent.com/jameswilson/drupalorg-cli/8546af00100fb6107171f0ca64a926d67320bb08/drupalorg-cli-completion.zsh -o _drupalorg
chmod +x _drupalorg
