#!/usr/bin/env bash

set -eu

unset -v explorer_host explorer_port
explorer_host=explorer.pangaea.harmony.one
explorer_port=8888

unset -v progname progroot progdir
progname="${0##*/}"
progroot="${progname%.*}"
case "${0}" in
*/*) progdir="${0%/*}";;
*) progdir=.;;
esac

. "${progdir}/msg.sh"

unset -v payload
payload=$(jq < "explorer-node-list.json" -s -c 'sort_by(."hmy:Shard") | {"secret":"426669","leaders":map(.PublicIpAddress + ":5000")}')

curl -X POST -H "Content-Type: application/json" -d "${payload}" -s -f "https://${explorer_host}:${explorer_port}/reset" | jq -c .
