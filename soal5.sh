#!/bin/bash

awk '!/[Ss][Uu][Dd][Oo]/ && /[Cc][Rr][Oo][Nn]/ {if(NF<13) print}' /var/log/syslog >> /home/Penunggu/modul1/logs
