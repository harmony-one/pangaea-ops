#!/usr/bin/env bash

set -eu

unset -v progname progroot progdir
progname="${0##*/}"
progroot="${progname%.*}"
case "${0}" in
*/*) progdir="${0%/*}";;
*) progdir=.;;
esac

. "${progdir}/msg.sh"

unset -v num_shards shard_size key_list
num_shards=3
shard_size=100
key_list=keys.txt

unset -v key_json
key_json=$(jq -c -R < "${key_list}" . | jq -c -s .)

unset -v shard start end
shard=0
while ((${shard} < ${num_shards}))
do
	start=$((${shard} * ${shard_size} + 1))
	end=$(((${shard} + 1) * ${shard_size}))
	sed -n "${start},${end}p" < instance-ids.json |
	jq \
		--argjson shard "${shard}" \
		--argjson num_shards "${num_shards}" \
		--argjson keys "${key_json}" \
		--arg node_type validator \
		--slurpfile instances instances.json \
		-c '
		$instances[0] as $instances |
		(
			.region as $region |
			((input_line_number - 1) * $num_shards + $shard) as $account_index |
			.instance_id as $instance_id |
			$instances[$region][$instance_id] |
			."hmy:RegionName" = $region |
			."hmy:NodeType" = $node_type |
			."hmy:Shard" = $shard |
			.InstanceId = $instance_id |
			."hmy:BLSPubKey" = $keys[$account_index]
		)
	' > "shard-${shard}.json"
	shard=$((${shard} + 1))
done
