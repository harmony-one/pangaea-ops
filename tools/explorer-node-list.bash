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

jq < "explorer-node-instance-ids.json" --slurpfile instances explorer-node-instances.json -c '
	$instances[0] as $instances |
	(
		.region as $region |
		.instance_id as $instance_id |
		$instances[$region][$instance_id] |
		."hmy:RegionName" = $region |
		.InstanceId = $instance_id |
		."hmy:Shard" = (input_line_number - 1)
	)
' > "${progroot}.json"
