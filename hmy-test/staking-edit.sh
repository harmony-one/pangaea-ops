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
    assertEquals 'Testing edit validator name should succeed with 0' "0" "${returncode}"
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
    assertEquals 'Testing edit validator identity should succeed with 0' "0" "${returncode}"
    assertContains 'Testing edit validator identity should have "status": "0x1"' "${output}" '"status": "0x1"' 
    echo
    echo 
}

#EV3 Edit website - Valid test
test_EV3_HMY_Validator_Edit_website() {
    test_cmd="${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --website website_auto_edited --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing edit validator website should succeed with 0' "0" "${returncode}"
    assertContains 'Testing edit validator website should have "status": "0x1"' "${output}" '"status": "0x1"' 
    echo
    echo 
}

#EV4 Edit security contact - Valid test
test_EV4_HMY_Validator_Edit_security_contact() {
    test_cmd="${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --security-contact security-contact_auto_edited --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing edit validator security contact should succeed with 0' "0" "${returncode}"
    assertContains 'Testing edit validator security contact should have "status": "0x1"' "${output}" '"status": "0x1"' 
    echo
    echo 
}

#EV5 Edit details - Valid test
test_EV5_HMY_Validator_Edit_details() {
    test_cmd="${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --details details_auto_edited --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing edit validator details should succeed with 0' "0" "${returncode}"
    assertContains 'Testing edit validator details should have "status": "0x1"' "${output}" '"status": "0x1"' 
    echo
    echo 
}

#EV6 - Valid test
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

#EV7 name longer than 140 characters - Fail test
test_EV7_HMY_Validator_Edit_Name_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name John_d8RrBmktWjGhFuPdh5sr5parrcedikvMtVCMiYl712eiuZqIh0Sg4PD5N7Z5Gf6mTdqkUWTVfNKu1fOzHSwlksOwZlTEpELsnxKKKys0De3Pvo2gIzeZabvCrXFLUh0FzchGeKlt0wx8 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator edit Name lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator edit Name lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}

#EV8 - Fail test
test_EV8_HMY_Validator_Edit_Identity_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --identity John_d8RrBmktWjGhFuPdh5sr5parrcedikvMtVCMiYl712eiuZqIh0Sg4PD5N7Z5Gf6mTdqkUWTVfNKu1fOzHSwlksOwZlTEpELsnxKKKys0De3Pvo2gIzeZabvCrXFLUh0FzchGeKlt0wx8 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Identity lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit Identity lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}

#EV9 - Fail test
test_EV9_HMY_Validator_Edit_Website_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --website john@harmony.one_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Website lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit Website lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}

#EV10 - Fail test
test_EV10_HMY_Validator_Edit_SecurityContact_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --security-contact Alex_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create SecurityContact lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit Security Contact lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}

#EV11 - Fail test
test_EV11_HMY_Validator_Edit_Detail_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --details 'John the validator gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5PgjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P' --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create detail lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit detail lenght test above 280' "${output}" 'exceeds maximum length of 280 characters'
    echo
    echo 
}

#EV12 Edit commission rate - Valid test
#note if you executed that test less than 1 epoch ago, it will fail
#assumed you are not at the max-rate
test_EV12_HMY_Validator_Edit_rate() {
    rate=$(echo ${validator_information} | jq -r ".result.commission.rate")
    new_rate=$(echo ${rate} + 0.01 | bc | awk '{printf "%f", $0}')
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --rate ${new_rate} --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Edit commission rate which should succeed with 0' "0" "${returncode}"
    assertContains 'Testing Validator Edit commission rate' "${output}" '"status": "0x1"'
    echo
    echo     
}

#EV13 Commission rate change > max change rate (within the same epoch should not be allowed) - fail test
test_EV13_HMY_Validator_Edit_rate_within_same_epoch() {
    rate=$(echo ${validator_information} | jq -r ".result.commission.rate")
    maxchangerate=$(echo ${validator_information} | jq -r ".result.commission.max-change-rate")
    new_rate=$(echo ${rate} + ${maxchangerate} | bc | awk '{printf "%f", $0}')
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --rate ${new_rate} --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Edit commission rate which should succeed with 0' "0" "${returncode}"
    assertContains 'Testing Validator Edit commission rate' "${output}" 'change on commission rate can not be more than max change rate within the same epoch'
    echo
    echo     
}

#EV20
test_EV20_HMY_Validator_Edit_min_self_delegation_greater_than_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --min-self-delegation 0 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create min self delegation test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit -min-self-delegation 0 (should be greater than 1)' "${output}" 'min-self-delegation can not be less than 1 ONE'
    echo
    echo 
}

#EV25 MaxTotalDelegation < MinSelfDelegation
test_EV25_HMY_Validator_Edit_max_total_delegation_greater_than_min_self_delgation() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR}  --min-self-delegation 20 --max-total-delegation 10 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Edit MaxTotalDelegation < MinSelfDelegation should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit MaxTotalDelegation < MinSelfDelegation' "${output}" 'max-total-delegation can not be less than min-self-delegation'
    echo
    echo 
}

# Load and run shUnit2.
shift $#
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNITPATH}