#!/bin/bash
rm -fr $HOME/.composer
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
rm -r ufmg/
rm -r smilespay/
rm -r timpay/