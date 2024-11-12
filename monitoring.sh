#!/bin/bash
total=$(free -b|grep ^Mem|awk '{print $2}');
used=$(free -b|grep ^Mem|awk '{print $3}');
mem=$(awk "BEGIN {printf \"%.2f\", ($used / $total) * 100}")
echo "
Broadcast message from root@wil (tty1) (Sun Apr 25 15:45:00 2021):
        #Architecture: $(uname -a)
        #CPU physical : $(lscpu | grep -c '^Core(s) per socket:')
        #vCPU : $(lscpu | grep -c '^CPU(s):')
        #Memory Usage: $(free -h|grep ^Mem|awk '{print $3}')/$(free -h|grep ^Mem|awk '{print $2}') ($mem%)
        #Disk Usage: $(df -m --total|grep total | awk '{print $3}')/$(df -h --total|grep total | awk '{print $2}')b ($(df -h --total|grep total | awk '{print $5}'))
        #CPU load: $(lscpu |grep "CPU(s) scaling MHz"| awk '{print $4}')
        #Last boot: 2021-04-25 14:45
        #LVM use: yes
        #Connections TCP : 1 ESTABLISHED
        #User log: 1
        #Network: IP 10.0.2.15 (08:00:27:51:9b:a5)
        #Sudo : 42 cmd
"