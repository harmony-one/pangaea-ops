#!/usr/bin/env bash

unset -v progname progdir
progname="${0##*/}"
case "$0" in
*/*) progdir="${0%/*}";;
*) progdir=.;;
esac

. "${progdir}/util.sh"
. "${progdir}/msg.sh"
. "${progdir}/usage.sh"

unset -v cmdfile
