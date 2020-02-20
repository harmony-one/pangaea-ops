#!/bin/bash
# Author: P-OPS soph 

# Tests all the negative scenarios
# for edit test if in this file -> assumed that your validator is already created
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



#test needs run in the same folder as the bls.key file
setUp() {
  cd ${HMYCLI_ABSOLUTE_FOLDER}
}

#create CreateValidator transaction signer with an invalid validator address format
test_HMY_Validator_Creation_Invalid_signer_address_format() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr onexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx --name John --identity john --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Invalid Signer address format which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create Invalid Signer address format' "${output}" 'not valid' 
    echo
    echo 
}
test_HMY_Validator_Edit_Invalid_signer_address_format() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr onexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx --name John2 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Invalid Signer address format which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit Invalid Signer address format' "${output}" 'not valid' 
    echo
    echo 
}

#create CreateValidator transaction signer should match the validator address present in the keystore ./hmy keys list
test_HMY_Validator_Creation_Non_Present_signer_address() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${NOT_PRESENT_VALIDATOR_ADDR} --name John --identity john --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Non Present Signer address which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create Non Present Signer address' "${output}" 'could not open local keystore'  
    echo
    echo 
}
test_HMY_Validator_Edit_Non_Present_signer_address() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${NOT_PRESENT_VALIDATOR_ADDR} --name John2  --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Non Present Signer address which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit Non Present Signer address' "${output}" 'could not open local keystore'  
    echo
    echo 
}

#name lenght above 140 chars should return an error message containing the string : Exceed Maximum Length name 140
test_HMY_Validator_Creation_Name_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John_d8RrBmktWjGhFuPdh5sr5parrcedikvMtVCMiYl712eiuZqIh0Sg4PD5N7Z5Gf6mTdqkUWTVfNKu1fOzHSwlksOwZlTEpELsnxKKKys0De3Pvo2gIzeZabvCrXFLUh0FzchGeKlt0wx8 --identity john --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Name lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create Name lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}

#CV3 Validator already exist, below assume the validator has already been created
#as 16 Feb 2020, currently not working as network doesn't return any staking failure error message
test_CV3_HMY_Validator_Creation_already_exist() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity john --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid} ${OPT_ARGS}" 
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create with existing validator should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create Create with existing validator' "${output}" 'staking validator already exists'
    echo
    echo 
}

#CV5
#Identity Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length identity 3000
test_CV5_HMY_Validator_Creation_Identity_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John_d8RrBmktWjGhFuPdh5sr5parrcedikvMtVCMiYl712eiuZqIh0Sg4PD5N7Z5Gf6mTdqkUWTVfNKu1fOzHSwlksOwZlTEpELsnxKKKys0De3Pvo2gIzeZabvCrXFLUh0FzchGeKlt0wx8 --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Identity lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit Identity lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}

#CV6
#Website Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length website 140
test_CV6_HMY_Validator_Creation_Website_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Website lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create Website lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}


#CV7
#SecurityContact Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length security-contact 140
test_CV7_HMY_Validator_Creation_SecurityContact_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create SecurityContact lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create Security Contact lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
}

#CV8
#details Lenghts above 280 chars should return an error message containing the string : Exceed Maximum Length detail 280
test_CV8_HMY_Validator_Creation_Detail_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5PgjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create detail lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create detail lenght test above 280' "${output}" 'exceeds maximum length of 280 characters'
    echo
    echo 
}

#CV15 commission rate > max rate
test_CV15_HMY_Validator_Creation_commrate_above_maxrate() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.5 --max-rate 0.1 --max-change-rate 0.05 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create commission rate > max rate which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create commission rate > max rate' "${output}" 'error: rate can not be greater than max-commission-rate'
    echo
    echo     
}

#CV16 max change rate > max rate
test_CV16_HMY_Validator_Creation_maxchangerate_above_maxrate() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.2 --max-change-rate 0.5 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create change rate > max rate which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create change rate > max rate' "${output}" 'error: max-change-rate can not be greater than max-commission-rate'
    echo
    echo     
}

#CV23	commission rate < 0
test_CV23_HMY_Validator_Creation_commrate_below_0() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate -0.1 --max-rate 0.2 --max-change-rate 0.05 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create commission rate < 0 which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create commission rate < 0' "${output}" 'error: rate can not be less than 0'
    echo
    echo     
}

#CV24	max rate < 0
test_CV24_HMY_Validator_Creation_maxrate_below_0() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate -0.4 --max-change-rate 0.05 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create max rate < 0 which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create max rate < 0' "${output}" 'error: max-commission-rate can not be less than 0'
    echo
    echo     
}

#CV25	max change rate < 0
test_CV25_HMY_Validator_Creation_maxchangerate_below_0() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.4 --max-change-rate -0.05 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create max change rate < 0 which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create max change rate < 0' "${output}" 'error: max-change-rate can not be less than 0'
    echo
    echo     
}

#CV26 commission rate > 1
test_CV26_HMY_Validator_Creation_commrate_above_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 1.1 --max-rate 0.8 --max-change-rate 0.01 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create commission rate > 1 which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create commission rate > 1' "${output}" 'error: rate can not be greater than 1'
    echo
    echo     
}

#CV27	max rate > 1
test_CV27_HMY_Validator_Creation_maxrate_above_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 1.4 --max-change-rate 0.05 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create max rate > 1 which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create max rate > 1' "${output}" 'error: max-commission-rate can not be greater than 1'
    echo
    echo     
}

#CV28	max change rate > 1
test_CV28_HMY_Validator_Creation_maxchangerate_above_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.4 --max-change-rate 1.05 --min-self-delegation 1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create max change rate > 1 which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create max change rate > 1' "${output}" 'error: max-change-rate can not be greater than 1'
    echo
    echo     
}

#CV31
#amount_below_min_self_delegation
test_CV31_HMY_Validator_Creation_amount_below_min_self_delegation() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 10 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of Create HMY_Validator_Creation_amount_below_min_self_delegation should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create HMY_Validator_Creation_amount_below_min_self_delegation' "${output}" 'amount can not be less than min-self-delegation'
    echo
    echo 
}

#CV32 MaxTotalDelegation < MinSelfDelegation
test_CV32_HMY_Validator_Creation_max_total_delegation_greater_than_min_self_delgation() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation 10 --bls-pubkeys ${BLS_PUBKEY} --amount 15 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator MaxTotalDelegation < MinSelfDelegation should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create MaxTotalDelegation < MinSelfDelegation' "${output}" 'max-total-delegation can not be less than min-self-delegation'
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

#CV33 MinSelfDelegation < 1 ONE
test_CV33_HMY_Validator_Creation_min_self_delegation_greater_than_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 0 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create MinSelfDelegation < 1 ONE which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create MinSelfDelegation < 1 ONE' "${output}" 'min-self-delegation can not be less than 1 ONE'
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

#CV34	MinSelfDelegation not specified
test_CV34_HMY_Validator_Creation_MinSelfDelegation_not_specified() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation  --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create MinSelfDelegation not specified which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create MinSelfDelegation not specified' "${output}" 'error'
    echo
    echo 
}

#CV35	MinSelfDelegation < 0
test_CV35_HMY_Validator_Creation_MinSelfDelegation_below_0() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation -1 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create MinSelfDelegation < 0 which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create MinSelfDelegation < 0' "${output}" 'error'
    echo
    echo 
}

#CV36	amount > MaxTotalDelegation
test_CV36_HMY_Validator_Creation_amount_above_MaxTotalDelegation() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 40 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of Create HMY_Validator_Creation amount > MaxTotalDelegation should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create HMY_Validator_Creation amount > MaxTotalDelegation' "${output}" 'amount can not be greater than max-total-delegation'
    echo
    echo 
}

#CV39	MaxTotalDelegation < 0
test_CV39_HMY_Validator_Creation_MaxTotalDelegation_below_0() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation -30 --bls-pubkeys ${BLS_PUBKEY} --amount 40 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of Create HMY_Validator_Creation MaxTotalDelegation < 0 should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create HMY_Validator_Creation MaxTotalDelegation < 0' "${output}" 'error'
    echo
    echo 
}

#CV41 no bls key specified
test_CV41_HMY_Validator_Creation_no_bls_key_specified() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity john --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create no bls key specified which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create no bls key specified' "${output}" 'error: required flag(s) "bls-pubkeys" not set'  
    echo
    echo 
}

#CV45 negative amount
test_CV45_HMY_Validator_Creation_negative_amount() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity john --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount -3 --chain-id ${chainid} ${OPT_ARGS}" 
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create negative amount should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create negative amount' "${output}" 'error'  
    echo
    echo 
}

#CV46 amount > account balance
# need to make sure your current validator account use for the test has less than the amount tested
test_CV46_HMY_Validator_Creation_amount_above_balance() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity john --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 900000000 --bls-pubkeys ${BLS_PUBKEY} --amount 9000000 --chain-id ${chainid} ${OPT_ARGS}" 
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create amount > account balance should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create amount > account balance' "${output}" 'error: insufficient funds for gas * price + value'
    echo
    echo 
}

# Load and run shUnit2.
shift $#
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNITPATH}
