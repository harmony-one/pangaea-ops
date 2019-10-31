#!/usr/bin/env bash

set -eu

unset -v pwd
pwd=$(/bin/pwd)

unset -v progname progroot progdir
progname="${0##*/}"
progroot="${progname%.*}"
case "${0}" in
*/*) progdir="${0%/*}";;
*) progdir=.;;
esac

progdir=$(realpath "${progdir}")

. "${progdir}/msg.sh"

unset -v aws_cmd
aws_cmd=$(which aws) || msg_exit 69 "aws command not found"

aws() {
	case "${HMY_AWS_PROFILE+set}" in
	set) set -- --profile "${HMY_AWS_PROFILE}" "$@";;
	esac
	"${aws_cmd}" "$@"
}

unset -v tmpdir
tmpdir=$(mktemp -d "${TMPDIR-/tmp}/${progname}.XXXXXX")
echo "${tmpdir}"
cd "${tmpdir}"

. "${progdir}/regions.bash"

unset -v instance_name_tag
case "${progroot}" in
instances) instance_name_tag='Pangaea Node';;
explorer-node-instances) instance_name_tag='Pangaea Explorer Node';;
*) msg_exit 69 "unknown program root ${progroot}";;
esac

unset -v region
for region in "${regions[@]}"
do
	aws ec2 describe-instances --region "${region}" --filters "$(
		jq -R <<< "${instance_name_tag}" -c '[
			{"Name": "tag:Name", "Values": [.]},
			{"Name": "instance-state-name", "Values": ["running"]}
		]'
	)" --output json > "${progroot}.${region}.json" &
done
wait

for region in "${regions[@]}"
do
	jq < "${progroot}.${region}.json" -c '
		.Reservations[].Instances[] |
		.Tags |= from_entries |
		{"Name": .InstanceId, "Value": . | del(.InstanceId)}
	' |
	jq --arg region "${region}" -s '{"Name": $region, "Value": . | from_entries}'
	rm "${progroot}.${region}.json"
done |
jq -s -c 'from_entries' > "${pwd}/${progroot}.json"

rmdir "${tmpdir}" || ls -la "${tmpdir}"
