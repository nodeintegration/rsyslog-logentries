#!/bin/sh
set -e

if [ "${USE_TLS}" != 'false' ]; then
  sed -i -e "s/#USE_TLS#//g" /etc/rsyslog.conf
fi

#$template Logentries-scentregroup-dev,"c932399f-a17e-4efb-bf95-b6a35a45bfea %HOSTNAME% %syslogtag%%msg%\n"
#*.* @@data.logentries.com:443;Logentries-scentregroup-dev
##if $fromhost-ip startswith '10.130.' then *.* @@data.logentries.com:443;Logentries-scentregroup-dev
##stop
##*.* @@data.logentries.com:80;Logentries-scentregroup-dev

