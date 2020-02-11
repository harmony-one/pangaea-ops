#!/bin/bash
# Author: P-OPS soph 

source $(dirname "$0")/config.sh


BLS_PASSPHRASE=""


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

#name lenght above 70 chars should return an error message containing the string : Exceed Maximum Length name 70
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
test_HMY_Validator_Edit_Name_lenght() {
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


#Identity Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length identity 3000
test_HMY_Validator_Creation_Identity_lenght() {
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
test_HMY_Validator_Edit_Identity_lenght() {
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

#Website Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length website 140
test_HMY_Validator_Creation_Website_lenght() {
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
test_HMY_Validator_Edit_Website_lenght() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --website john@harmony.one_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create Website lenght test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Edit Website lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
    echo
    echo 
};





#SecurityContact Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length security-contact 140
test_HMY_Validator_Creation_SecurityContact_lenght() {
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
test_HMY_Validator_Edit_SecurityContact_lenght() {
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




#details Lenghts above 280 chars should return an error message containing the string : Exceed Maximum Length detail 280
test_HMY_Validator_Creation_Detail_lenght() {
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
test_HMY_Validator_Edit_Detail_lenght() {
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



#min self delegation should be greater than 1
test_HMY_Validator_Creation_min_self_delegation_greater_than_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 0 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 3 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create min self delegation test which should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create -min-self-delegation 0 (should be greater than 1)' "${output}" 'min-self-delegation can not be less than 1 ONE'
    echo
    echo 
}
test_HMY_Validator_Edit_min_self_delegation_greater_than_1() {
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

#max-total-delegation cannot be less than min-self-delegation
test_HMY_Validator_Creation_max_total_delegation_greater_than_min_self_delgation() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation 10 --bls-pubkeys ${BLS_PUBKEY} --amount 15 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of hmy Validator Create max_total_delegation_greater_than_min_self_delgation should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create max_total_delegation should be greater than min self delgation' "${output}" 'max-total-delegation can not be less than min-self-delegation'
    echo
    echo 
}
# test_HMY_Validator_Edit_max_total_delegation_greater_than_min_self_delgation() {
#     test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --min-self-delegation 20 --max-total-delegation 10 --remove-bls-key ${BLS_PUBKEY} --add-bls-key ${BLS_PUBKEY} --chain-id ${chainid}"
#     echo "command executed : ${test_cmd}"
#     output=$((eval "${test_cmd}") 2>&1)
#     returncode=$?
#     echo "command output : ${output}"
#     assertEquals 'Testing error code of hmy Validator Edit max_total_delegation_greater_than_min_self_delgation' "1" "${returncode}"
#     #Need to ask Harmony what is the expected error
#     #assertEquals 'Testing Validator Edit max_total_delegation_greater_than_min_self_delgation' "Exceed Maximum Length details 280" "${output}"
#     assertContains 'Testing Validator Edit max_total_delegation_greater_than_min_self_delgation' "${output}" 'max_total_delegation can not be less than min_self_delegation'
#     echo
#     echo 
# }

#amount_below_min_self_delegation
test_HMY_Validator_Creation_amount_below_min_self_delegation() {
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
#amount can't be edited since this represent the self delegation amount we are putting during the creation. Subsequent self delegation, should be done via the delegation staking action

#amount_above_max_total_delegation
test_HMY_Validator_Creation_amount_above_total_max_delegation() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 40 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of Create HMY_Validator_Creation_amount_above_total_max_delegation should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create HMY_Validator_Creation_amount_above_total_max_delegation' "${output}" 'amount can not be greater than max-total-delegation'
    echo
    echo 
}
#amount can't be edited since this represent the self delegation amount we are putting during the creation. Subsequent self delegation, should be done via the delegation staking action




#rate_above_1
test_HMY_Validator_Creation_rate_above_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 1.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 25 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of Create HMY_Validator_Creation_rate_above_1 should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create HMY_Validator_Creation_rate_above_1' "${output}" 'rate can not be greater than 1'
    echo
    echo 
}

#max_rate_above_1
test_HMY_Validator_Creation_max_rate_above_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 1.1 --max-change-rate 0.05 --min-self-delegation 20 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 25 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of Create HMY_Validator_Creation_max_rate_above_1 should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create HMY_Validator_Creation_max_rate_above_1' "${output}" 'max-commission-rate can not be greater than 1'
    echo
    echo 
}

#max_change_rate_above_1
test_HMY_Validator_Creation_max_change_rate_above_1() {
    test_cmd="echo ${BLS_PASSPHRASE} | ${HMYCLIBIN} --node=https://${apiendpoint} staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details 'John the validator' --rate 0.1 --max-rate 0.9 --max-change-rate 1.1 --min-self-delegation 20 --max-total-delegation 30 --bls-pubkeys ${BLS_PUBKEY} --amount 25 --chain-id ${chainid}"
    echo "command executed : ${test_cmd}"
    output=$((eval "${test_cmd}") 2>&1)
    returncode=$?
    echo "command output : ${output}"
    assertEquals 'Testing error code of Create HMY_Validator_Creation_max_change_rate_above_1 should be 1' "1" "${returncode}"
    assertContains 'Testing Validator Create HMY_Validator_Creation_max_change_rate_above_1' "${output}" 'max-change-rate can not be greater than 1'
    echo
    echo 
}


# Load and run shUnit2.
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNITPATH}
