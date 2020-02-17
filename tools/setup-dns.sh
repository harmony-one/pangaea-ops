#!/bin/sh

unset -v network stride
network=p
stride=8

unset -v shard
shard=0
while [ -f "shard-${shard}.json" ]
do
	jq < "shard-${shard}.json" -r '.PublicIpAddress' |
	awk -v stride="${stride}" '
		(NR - 1) % stride == 0
	' |
	xargs python3 -m r53update "${network}" "${shard}"
	shard=$((${shard} + 1))
done
