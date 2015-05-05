#!/bin/bash

start=$(date +%s)
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd /vagrant

echo "::::::::::::: COMPILE HEDGEHOG :::::::::::::"
cd /vagrant
./autogen.sh
mkdir build
cd build
../configure
make

echo "::::::::::::: INSTALL HEDGEHOG :::::::::::::"
make install
make install-rpg


echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

cd /vagrant

end=$(date +%s)

diff=$(( $end - $start ))


echo ":::::::::::::::::::::::::::::::::"
echo "::::: COMPILATION: $diff s"
echo ":::::::::::::::::::::::::::::::::"
