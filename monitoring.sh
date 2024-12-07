#!/bin/bash
physical_processors=$(nproc --all)
virtual_processors=$(nproc)
lvm() {
    g=$(lsblk | awk '{print $6}' | grep lvm)
    if [ -z "$g" ]; then
        echo "no"
    else
        echo "yes"
    fi
}
total_memory=$(free -m | grep ^Mem | awk '{print $2}')
used_memory=$(free -m | grep ^Mem | awk '{print $3}')
mem_usage=$(echo "$used_memory $total_memory"|awk '{print ($1 / $2) * 100}')
cpu_load=$(top -bn1|grep "Cpu(s)" | cut -d ':' -f 2 | tr ',' '\n' | grep id |awk '{print 100 - $1"%"}')
last_boot=$(uptime -s)
lvm_status=$(lvm)
active_connections=$(( $(ss -tn state established | wc -l) -1 ))
users_logged_in=$(who | wc -l)
ip_address=$(hostname -I)
mac_address=$(ip a | grep -w link/ether | awk '{print $2}')
sudo_cmd_count=$(cat /var/log/sudo/sudo.log | grep -c COMMAND=)
wall  "
	#Architecture: $(uname -a)
        #CPU physical : $physical_processors
        #vCPU : $virtual_processors
        #Memory Usage: $used_memory/$total_memory MB ($mem_usage%) MB ($mem_usage%)
        #Disk Usage: $(df -m --total|grep total | awk '{print $3}')/$(df -h --total|grep total | awk '{print $2}')b ($(df -h --total|grep total | awk '{print $5}'))
        #CPU load:$cpu_load
        #Last boot: $last_boot
        #LVM use: $lvm_status
        #Connections TCP : $active_connections ESTABLISHED
        #User log: $users_logged_in
        #Network: IP $ip_address ($mac_address)
        #Sudo : $sudo_cmd_count cmd
"
