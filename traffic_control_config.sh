tc qdisc del dev enp0s3 root

tc qdisc add dev enp0s3 root handle 1:0 htb
tc class add dev enp0s3 parent 1:0 classid 1:1 htb rate 10mbit ceil 10mbit

tc filter add dev enp0s3 parent 1:0 protocol ip prio 1 u32 match ip protocol 1 0xff flowid 1:0 action drop

tc class add dev enp0s3 parent 1:1 classid 1:10 htb rate 4mbit ceil 10mbit
tc filter add dev enp0s3 parent 1:1 protocol ip prio 1 u32 match ip src 0.0.0.0/30 flowid 1:10

tc class add dev enp0s3 parent 1:1 classid 1:20 htb rate 2mbit ceil 10mbit
tc filter add dev enp0s3 protocol ip parent 1:1 prio 1 u32 match ip src 1.0.0.0/30 flowid 1:20
tc qdisc add dev enp0s3 parent 1:20 handle 200: htb default 2
tc class add dev enp0s3 parent 200: classid 200:1 htb rate 80kbit prio 1
tc class add dev enp0s3 parent 200: classid 200:2 htb rate 20kbit prio 2
tc filter add dev enp0s3 parent 1:20 protocol ip prio 1 u32 match ip protocol 17 0xff flowid 200:1

tc class add dev enp0s3 parent 1:1 classid 1:30 htb rate 2mbit ceil 10mbit
tc filter add dev enp0s3 parent 1:1 u32 match ip protocol 6 0xff match ip src 2.0.0.0/30 flowid 1:30 action drop

tc class add dev enp0s3 parent 1:1 classid 1:40 htb rate 2mbit ceil 10mbit
tc filter add dev enp0s3 protocol ip parent 1:1 prio 1 u32 match ip src 3.0.0.0/30 flowid 1:40