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

unset -v input
case "${progroot}" in
instance-ids) input=instances;;
explorer-node-instance-ids) input=explorer-node-instances;;
*) msg_exit 69 "unrecognized program root ${progroot}";;
esac

jq -c < "${input}.json" '
	to_entries |
	.[] |
	.key as $region |
	.value |
	to_entries[] |
	{"region": $region, "instance_id": .key}
' | shuf > "${progroot}.json"
chmod a-w "${progroot}.json"
