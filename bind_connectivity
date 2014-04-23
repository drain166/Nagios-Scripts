#!/bin/bash

PROGNAME=`/bin/basename $0`

. $PROGPATH/utils.sh

print_usage() {
        echo "Usage: $PROGNAME"
}

if [ $# -gt 0 ]; then
        print_usage
        exit $STATE_UNKNOWN
fi

ip_count=0      # count of ip addresses checked
gc=0            # count of reachable and fast response time hosts

# BIND Servers
ip_list=( "192.168.206.11" "192.168.206.12" )
ip_count=${#ip_list[*]}

for i in "${ip_list[@]}"
do
        dig_resp=`/usr/bin/dig +nocmd @$i in A nagios-check.localhost +noall +authority +stats | egrep "Query time:" | awk '{print $4}'`
        if [[ "`echo $dig_resp`" != "" ]] && [ `echo $dig_resp` -le 30 ]
        then
                ((gc++))
        fi
done

if [ ${gc} -ne ${ip_count} ]
then
        echo "CRITICAL: $gc of $ip_count BIND systems are reachable or responding within 30ms."
        exit $STATE_CRITICAL
else
        echo "OK: All BIND systems are reachable and responding within 30ms."
        exit $STATE_OK
fi
