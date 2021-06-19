#!/system/bin/sh

product_list=(20221 20222 20223 20224 20225 20226 20227 20228 20229 20211 20212 20213 20214 20215)
product=`getprop "ro.separate.soft"`
dev_life=`getprop "persist.sys.oppo.nandswap.devlife"`

for i in ${product_list[*]}; do
	if [ "$i" == "$product" ]; then
		if [ "$dev_life" == "false" ]; then
			echo 1 > /proc/nandswap/dev_life
		else
			fn_enable=`getprop "persist.sys.oppo.nandswap"`
			echo 0 > /proc/nandswap/dev_life
		fi
	fi
done

if [ "$fn_enable" == "true" ]; then
	if [ ! -f "/data/nandswap/swapfile" ]; then
		total=`df |grep -E " /data$" |awk '{print $2}'`
		avail=`df |grep -E " /data$" |awk '{print $4}'`
		threshold=total

		#64G > 4.5+1G, 128G > 7+1G
		if [ $total -gt 73400320 ]; then
			threshold=8388608
		#elif [ $total -gt 36700160 ]; then
		#	threshold=5767168
		fi

		if [ $avail -gt $threshold ]; then
			dd if=/dev/zero of=/data/nandswap/swapfile bs=1M count=1024
		fi
	fi

	if [ -f "/data/nandswap/swapfile" ]; then
		chmod 600 /data/nandswap/swapfile
		mkswap /data/nandswap/swapfile
		# 2020 is just a magic number, must be consistent with the definition SWAP_NANDSWAP_PRIO in include/linux/swap.h
		swapon -d /data/nandswap/swapfile -p 2020
		echo 1 > /proc/nandswap/fn_enable
	fi
else
	echo 0 > /proc/nandswap/fn_enable
	if [ -f "/data/nandswap/swapfile" ]; then
		rm -rf /data/nandswap/swapfile
	fi
fi
