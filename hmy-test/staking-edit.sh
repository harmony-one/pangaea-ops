#!/bin/bash
# Author: P-OPS soph 

# success and failure Tests on edit
# assumed your validator is already created 

# the bls and validator one account defined in the config.sh
# in those variable :  ${VALIDATOR_ADDR} and ${BLS_PUBKEY}

source $(dirname "$0")/config.sh

#enter your BLS passphrase if you have one, but not recommended here for the test
BLS_PASSPHRASE=""

#optional argument tag to allow faster execution of the test while dev are fixing it https://github.com/harmony-one/harmony/issues/2276
OPT_ARGS="" #"--timeout 8" now fixed as of 19 Feb

# overwrite VALIDATOR_ADDR and BLS_PUBKEY if they are passed in argument
if [ $# -eq 2 ]; then
    VALIDATOR_ADDR=$1
    BLS_PUBKEY=$2
fi

# capturing the current validator information so after all the edit are done, we do a final edit and set it back
validator_information=$((eval "${HMYCLIBIN} -n https://${apiendpoint}  blockchain validator information ${VALIDATOR_ADDR}") 2>&1)

#test needs run in the same folder as the bls.key file
setUp() {
  cd ${HMYCLI_ABSOLUTE_FOLDER}
}

#EV1 Edit name - Valid test
test_EV1_HMY_Validator_Edit_name() {
    test_cmd="${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name Name_auto_edited --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing edit validator name which should succeed with 0' "0" "${returncode}"
    assertContains 'Testing edit validator name should have "status": "0x1"' "${output}" '"status": "0x1"' 
    echo
    echo 
}

#EV2 Edit identity - Valid test
test_EV2_HMY_Validator_Edit_identity() {
    test_cmd="${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --identity Identity_auto_edited --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing edit validator identity which should succeed with 0' "0" "${returncode}"
    assertContains 'Testing edit validator identity should have "status": "0x1"' "${output}" '"status": "0x1"' 
    echo
    echo 
}

#EV6
test_EV6_edit_all_back()
{
    original_name=$(echo ${validator_information} |  jq -r ".result.description.name")
    original_identity=$(echo ${validator_information} |  jq -r ".result.description.identity")
    original_details=$(echo ${validator_information} |  jq -r ".result.description.details")
    original_security_contact=$(echo ${validator_information} |  jq -r ".result.description.security_contact")
    original_website=$(echo ${validator_information} |  jq -r ".result.description.website")

    test_cmd="${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name ${original_name} --identity ${original_identity} --details ${original_details} --security-contact ${original_security_contact} --website ${original_website} --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing edit validator identity which should succeed with 0' "0" "${returncode}"
    assertContains 'Testing edit validator identity should have "status": "0x1"' "${output}" '"status": "0x1"' 
    echo
    echo    
}
# Load and run shUnit2.
shift $#
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNITPATH}