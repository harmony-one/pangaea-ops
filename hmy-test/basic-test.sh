#!/bin/sh
# Author: P-OPS soph 

#requirement
# jq, bc

#path to shunit2:
SHUNITPATH="../../shunit2/shunit2"

#path to hmy binary
HMYCLI_ABSOLUTE_FOLDER="/root/hmy-devnet"


test_HMY_version() {
  #note the current hmy version v138 shows the version in the stderr
  output=$((${HMYCLIPATH} version) 2>&1)
  returncode=$?
  assertEquals 'Testing error code of hmy version which should be 0' "0" "${returncode}"
  assertContains 'Testing hmy version' "${output}" 'v138-3ef3b5c'
  #assertEquals 'Harmony (C) 2019. hmy, version v138-3ef3b5c (@harmony.one 2019-11-26T22:27:26-0800)' "${output}"
}

test_HMY_Check_Balance() {
  output=$(${HMYCLIPATH} --node="https://api.s1.b.hmny.io/" balances one1yc06ghr2p8xnl2380kpfayweguuhxdtupkhqzw | jq ".[0].amount")
  returncode=$?
  assertEquals 'Testing error code of hmy balance check which should be 0' "0" "${returncode}"
  assertEquals "testing balance above 0 for one1yc06ghr2p8xnl2380kpfayweguuhxdtupkhqzw in pangaea" "1" "$(echo "${output} > 0" | bc -l)"
}

test_HMY_Known_Chain() {
  output=$(${HMYCLIPATH} blockchain known-chains --no-pretty)
  returncode=$?
  assertEquals 'Testing error code of hmy known chain test which should be 0' "0" "${returncode}"
  assertEquals '["mainnet","testnet","devnet"]' "${output}"
}

# Load and run shUnit2.
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNITPATH}
