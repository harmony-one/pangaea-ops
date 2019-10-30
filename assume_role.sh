#!/bin/sh

set -eu

unset -v progname progdir
progname="${0##*/}"
case "${0}" in
*/*) progdir="${0%/*}";;
*) progdir=.;;
esac

. "${progdir}/util.sh"

unset -v result
if result=$(aws sts assume-role "$@")
then
	echo "${result}" |
	jq -r '.Credentials | [.AccessKeyId, .SecretAccessKey, .SessionToken] | .[]' | \
	(
		read -r access_key_id
		read -r secret_access_key
		read -r session_token
		echo "AWS_ACCESS_KEY_ID=$(shell_quote "${access_key_id}");"
		echo "AWS_SECRET_ACCESS_KEY=$(shell_quote "${secret_access_key}");"
		echo "AWS_SESSION_TOKEN=$(shell_quote "${session_token}");"
		echo "export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN;"
	)
fi
