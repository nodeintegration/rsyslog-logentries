#!/bin/sh
set -e

PORT=80
if [ "${USE_TLS}" != 'false' ]; then
  PORT=443
  sed -i -e "s/#USE_TLS#//g" /etc/rsyslog.conf
fi

CONFIG=""
for cfg in ${LOGENTRIES_CONFIG}; do
  name=$(echo $cfg | cut -f1 -d ':')
  token=$(echo $cfg | cut -f2 -d ':')
  filter=$(echo $cfg | cut -f3 -d ':')
  value=$(echo $cfg | cut -f4 -d ':')

  if [ -z "${name}" -o -z "${token}" -o -z "${filter}" -o -z "${value}" ]; then
    echo "[ERROR]: must supply LOGENTRIES_CONFIG in the format of 'name:token:(hostname|fromip):value'"
    exit 1
  fi

  if [ "${filter}" = 'hostname' -o "${filter}" = 'fromip' ]; then
    CONFIG="${CONFIG}\n\$template Logentries-${name},\"${token} %HOSTNAME% %syslogtag%%msg%\\\n\"\n"
    if [ "${filter}" = 'hostname' ]; then
      CONFIG="${CONFIG}if \$hostname == '${value}' then { *.* @@data.logentries.com:${PORT};Logentries-${name} }"
    elif [ "${filter}" = 'fromip' ]; then
      CONFIG="${CONFIG}if \$fromhost-ip startswith '${value}' then { *.* @@data.logentries.com:${PORT};Logentries-${name} }"
    fi

  else
    echo "[ERROR]: LOGENTRIES_CONFIG filter must be one of hostname|fromip"
    exit 1
  fi
done

CONFIG=
echo -e "${CONFIG}" > /etc/rsyslog.d/logentries.conf
echo "[INFO]: starting rsyslog"

exec "$@"

