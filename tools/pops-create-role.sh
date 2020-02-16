#!/bin/sh

set -eu

unset -v progname progdir
progname="${0##*/}"
case "${0}" in
*/*) progdir="${0%/*}";;
*) progdir=.;;
esac

. "${progdir}/msg.sh"
. "${progdir}/usage.sh"
. "${progdir}/util.sh"

print_usage() {
	cat <<- ENDEND
		usage: ${progname} role_name aws_account
		ENDEND
}

unset -v opt
OPTIND=1
while getopts : opt
do
	case "${opt}" in
	'?') usage "unrecognized option -${OPTARG}";;
	':') usage "missing argument for -${OPTARG}";;
	*) msg_exit 67 "unhandled option -${opt}";;
	esac
done
shift $((${OPTIND} - 1))

unset -v role_name aws_account
role_name="${1-}"
aws_account="${2-}"
shift 2> /dev/null || usage "missing role name"
shift 2> /dev/null || usage "missing AWS account number"
case $# in
[1-9]*) usage "extra argument(s) given: $*";;
esac

unset -v policy_doc
policy_doc="$(
	jq < "${progdir}/pops-assume-role-policy.json" \
		--arg acct "${aws_account}" \
		-c \
		'.Statement[0].Principal.AWS = ("arn:aws:iam::" + $acct + ":root")'
)"
aws iam create-role --path=/PangaeaOps/ --role-name="${role_name}" --assume-role-policy-document="${policy_doc}"
aws iam attach-role-policy --role-name="${role_name}" --policy-arn=arn:aws:iam::412979239381:policy/EC2ReadOnlyAccess
