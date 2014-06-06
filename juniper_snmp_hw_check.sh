#!/bin/bash
 
: '
Written for SNMP v2c and Juniper MX*.  Season to taste.
 
Sample raw snippet -
   SNMPv2-SMI::enterprises.2636.3.1.13.1.5.4.1.2.0 = STRING: "Fan 2"
   SNMPv2-SMI::enterprises.2636.3.1.13.1.5.4.1.3.0 = STRING: "Fan 3"
   SNMPv2-SMI::enterprises.2636.3.1.13.1.5.4.1.4.0 = STRING: "Fan 4"
   SNMPv2-SMI::enterprises.2636.3.1.13.1.6.4.1.2.0 = INTEGER: 2
   SNMPv2-SMI::enterprises.2636.3.1.13.1.6.4.1.3.0 = INTEGER: 2
   SNMPv2-SMI::enterprises.2636.3.1.13.1.6.4.1.4.0 = INTEGER: 2
 
Status Codes -
   1 = Unknown
   2 = Running
   3 = Ready
   4 = Reset
   5 = Running At Full Speed
   6 = Down
   7 = Standby
'
 
env_oid="1.3.6.1.4.1.2636.3.1.13.1"
 
if [ $# -ne 3 ] ; then
   echo ""
   echo "Usage: juniper_snmp_hw_check.sh <ip_addr> <community_string> <sub_oid>
   echo "   ex. juniper_snmp_hw_check.sh 10.102.1.231 snmppass1 4.1.2.0
   echo "       --> [OK] Fan 2 - State: Running"
   echo ""
   exit
fi
 
desc=`/usr/bin/snmpget -v2c -Onq -c $2 $1 $env_oid.5.$3 | awk -F\" '{print $2}'`
if [ $? -ne 0 ] ; then
   echo "[CRITICAL] SNMP poll failed"
   exit 2
else
   status=`/usr/bin/snmpget -v2c -Onq -c $2 $1 $env_oid.6.$3 | awk '{print $2}'`
fi
 
case $status in
   1) echo "[WARNING] $desc - State: Unkown"                ; exit 1 ;;
   2) echo      "[OK] $desc - State: Running"               ; exit 0 ;;
   3) echo "[WARNING] $desc - State: Ready"                 ; exit 1 ;;
   4) echo "[WARNING] $desc - State: Reset"                 ; exit 1 ;;
   5) echo "[WARNING] $desc - State: Running At Full Speed" ; exit 1 ;;
   6) echo "[WARNING] $desc - State: Down"                  ; exit 1 ;;
   7) echo "[WARNING] $desc - State: Standby"               ; exit 1 ;;
esac
