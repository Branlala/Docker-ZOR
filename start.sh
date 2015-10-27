#!/bin/bash

if [[ ! -f /data/.installed ]]
then
  cp -rp /data.ori /data
fi  

service apache2 start