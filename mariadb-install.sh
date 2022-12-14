#!/bin/bash
# https://mariadb.org/download/?t=repo-config&d=20.04+%22focal%22&v=10.8&r_m=djvg

sudo apt-get install apt-transport-https curl
sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c "echo 'deb https://mirror.djvg.sg/mariadb/repo/10.8/ubuntu focal main' >>/etc/apt/sources.list"
sudo apt-get update -y
sudo apt-get install mariadb-server -y
