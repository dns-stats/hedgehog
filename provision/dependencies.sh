#!/bin/bash

start=$(date +%s)
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd /vagrant

echo "::::::::::::: REPO :::::::::::::"
add-apt-repository ppa:opencpu/rapache
apt-get update

echo "::::::::::::: C++ :::::::::::::"
apt-get install -y libboost-all-dev libtool libpqxx-dev

echo "::::::::::::: R :::::::::::::"
apt-get install -y r-base r-base-core r-base-dev libcairo2-dev libxt-dev r-cran-ggplot2 r-cran-dbi r-cran-cairodevice r-cran-reshape r-cran-digest
echo "install.packages(c('brew','Cairo','googleVis','RPostgreSQL','R.utils','yaml'), repos='http://cran.rstudio.com/')" | R --vanilla

echo "::::::::::::: POSTGRES :::::::::::::"
apt-get install -y postgresql postgresql-client postgresql-server-dev-9.3 postgresql-contrib pgbouncer

echo "::::::::::::: Apache :::::::::::::"
apt-get install -y apache2-mpm-prefork apache2-prefork-dev git libapache2-mod-r-base

echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

cd /vagrant

end=$(date +%s)

diff=$(( $end - $start ))

echo ":::::::::::::::::::::::::::::::::"
echo "::::: DEPENDENCIES: $diff s"
echo ":::::::::::::::::::::::::::::::::"
