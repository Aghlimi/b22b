#!/bin/bash
total=$(free -mt|grep ^Total|awk '{print $2}');
used=$(free -mt|grep ^Total|awk '{print $2}');
mem=$(awk "BEGIN {printf \"%.2f\", ($used / $total) * 100}")

echo "
Broadcast message from root@wil (tty1) (Sun Apr 25 15:45:00 2021):
        #Architecture: $(uname -a)
        #CPU physical : $(lscpu | grep -c '^Core(s) per socket:')
        #vCPU : $(lscpu | grep -c '^CPU(s):')
        #Memory Usage: $used/$totalMB ($mem%)
        #Disk Usage: 1009/2Gb (49%)
        #CPU load: 6.7%
        #Last boot: 2021-04-25 14:45
        #LVM use: yes
        #Connections TCP : 1 ESTABLISHED
        #User log: 1
        #Network: IP 10.0.2.15 (08:00:27:51:9b:a5)
        #Sudo : 42 cmd
"