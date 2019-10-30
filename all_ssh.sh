#!/bin/sh

unset -v progname progdir
progname="${0##*/}"
case "${0}" in
*/*) progdir="${0%/*}";;
*) progdir=.;;
esac

. "${progdir}/util.sh"
. "${progdir}/usage.sh"

print_usage() {
	cat <<- ENDEND
	usage: ${progname} [-s shard] cmd

	options:
	-s shard	shard on which to run command; e for explorer nodes
	 		(may be given many times, default: all shards)

	args:
	cmd		command to run
	ENDEND
}

unset -v shards cmd

unset -v opt
OPTIND=1
while getopts :s: opt
do
	case "${opt}" in
	s) shards="${shards-} ${OPTARG}";;
	'?') usage 64 "unrecognized option -${OPTARG}";;
	':') usage 64 "missing argument for -${OPTARG}";;
	esac
done
shift $((${OPTIND} - 1))
case $# in
0) usage "missing cmd";;
esac
cmd="${1}"
shift 1
case $# in
[1-9]*) usage "extra arguments: $*";;
esac

print_instances() {
	local shard
	case "${shards+set}" in
	set)
		for shard in ${shards}
		do
			case "${shard}" in
			e) cat "explorer-node-list.json";;
			*) cat "shard-${shard}.json";;
			esac
		done
		;;
	*)
		shard=0
		while [ -f "shard-${shard}.json" ]
		do
			cat "shard-${shard}.json"
			shard=$((${shard} + 1))
		done
		;;
	esac 
}

cd "${progdir}"
print_instances |
jq -r '.PublicIpAddress + "	" + (. | tojson)' |
(
	unset -v ip instance_json cmd1
	while IFS='	' read -r ip instance_json
	do
		instance_json_q=$(shell_quote "${instance_json}")
		cmd1='
			instance_json='"$(shell_quote "${instance_json}")"'
			jqi() { echo "${instance_json}" | jq "$@"; }
		'"${cmd}"
		if ssh -F ssh_config -O check "ec2-user@${ip}" 2> /dev/null
		then
			ssh -F ssh_config -n "ec2-user@${ip}" "${cmd1}"
		else
			"${progdir}/hssh" "ec2-user@${ip}" -- -F ssh_config -n - "${cmd1}"
		fi 2>&1 | sed "s/^/${ip}	/" &
	done
	wait
)
