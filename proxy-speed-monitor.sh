#!/bin/bash

# Defined some arrays
declare -A proxy

# Defined proxy hostname and ip address
# proxy["proxy-ix01"]="192.168.1.61"
proxy["proxy-ix02"]="192.168.1.62"
# proxy["proxy-ix03"]="192.168.1.63"

# Defined http request url
url="http://www.yahoo.co.jp/"

# Defined log
log_dir="/var/log"
log_file="proxy.log"

# Check lock file
lockfile=".proxy.lock"

if [ -f ${lockfile} ]; then
  exit 1
fi

# Create lock file
touch ${lockfile}

# Run
for proxy_ip in ${!proxy[@]}
do
  # Timestamp
  timestamp=`date "+%Y-%m-%d %T"`
  echo $proxy_ip

  # Execute curl via proxies defined
curl -kL ${url} -x ${proxy[proxy_ip]}:3128 \
-o /dev/null \
-w "${timestamp},${proxy_ip},\
%{http_code},\
%{size_download},\
%{speed_download},\
%{time_connect},\
%{time_namelookup},\
%{time_redirect},\
%{time_pretransfer},\
%{time_starttransfer},\
%{time_total},\
${url}\n" 1>&2 >> ${log_dir}/${log_file}

  sleep 1;
done

rm -f ${lockfile}
