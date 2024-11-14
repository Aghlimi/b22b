text=$(lsblk |awk '{print $6}' |grep lvm)
if [ -n "$text" ];then
	echo $text;
else
	echo "is empty"
fi
