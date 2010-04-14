#Install subversion on a shared host


curl -O http://subversion.tigris.org/downloads/subversion-1.6.9.tar.gz
curl -O http://subversion.tigris.org/downloads/subversion-deps-1.6.9.tar.gz
curl -O http://www.openssl.org/source/openssl-0.9.8l.tar.gz

tar zxvf openssl-0.9.8l.tar.gz
tar zxvf subversion-1.6.9.tar.gz
tar zxvf subversion-deps-1.6.9.tar.gz

cd openssl-0.9.8l/
./config shared --prefix=$HOME/installs && make clean && make && make install
cd ../

export CFLAGS="-O2 -g -I$HOME/installs/include"
export LDFLAGS="-L$HOME/installs/lib"
export CPP="gcc -E -I$HOME/installs/include"

cd subversion-1.6.9/neon/
./configure --with-ssl=openssl --prefix=$HOME/installs
cd ../
./configure --with-ssl --prefix=$HOME/installs --with-neon=$HOME/installs/bin/neon-config
