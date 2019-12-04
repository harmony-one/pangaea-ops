#!/bin/bash
# Author: P-OPS soph 

#path to shnit2:
SHUNITPATH="../shunit2"

#path to hmy binary
HMYCLIPATH="../../../hmy" 

#requirement as per initial testing
# need a one wallet associated on the validator
# curl -LO https://harmony.one/wallet.sh && chmod +x wallet.sh
# ./wallet.sh new
# locate the keystore file 
# and import it so hmy can use it in all the below command
# ./hmy keys import-ks /root/.hmy/keystore/UTC--2019-11.....
#this address need to be linked with the validator account
VALIDATOR_ADDR=one15knq45tf5psjze6q65dpm4lumqhm8jny997mph
#address not present in your local keystore ./hmy keys list
NOT_PRESENT_VALIDATOR_ADDR=one143fyg8yu2pvxuq84qehwjtvlvxlpfvwe5z2y97 #address generated but not imported

#the above account will be used to signed all the transaction related to validator creation

#create CreateValidator transaction signer with an invalid validator address format
test_HMY_Validator_Creation_Invalid_signer_address_format() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr onexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx --name John --identity john --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create Invalid Signer address format which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator Create Invalid Signer address format' 'Error: invalid argument "onexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" for "--validator-addr" flag: The address you supplied (onexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) is in an invalid format. Please provide a valid address.' "${output}"
    assertContains 'Testing Validator Create Invalid Signer address format' "${output}" 'invalid format'  
}

#create CreateValidator transaction signer should match the validator address present in the keystore ./hmy keys list
Error: invalid argument "--name" for "--validator-addr" flag: The address you supplied (--name) is in an invalid format. Please provide a valid address.>
test_HMY_Validator_Creation_Non_Present_signer_address() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr ${NOT_PRESENT_VALIDATOR_ADDR} --name John --identity john --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create Non Present Signer address which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator Create Non Present Signer address' "Error: could not open local keystore for ${NOT_PRESENT_VALIDATOR_ADDR}" "${output}"
    assertContains 'Testing Validator Create Non Present Signer address' "${output}" 'could not open local keystore'  
}

#name lenght above 70 chars should return an error message containing the string : Exceed Maximum Length name 70
test_HMY_Validator_Creation_Name_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr ${VALIDATOR_ADDR} --name JohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohns --identity john --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create Name lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator Create Name lenght test above 70' "exceeds maximum length of 70" "${output}"
    assertContains 'Testing Validator Create Name lenght test above 70' "${output}" 'exceeds maximum length of 70 characters'
}
test_HMY_Validator_Edit_Name_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name JohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohnsJohns --identity john --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --min-self-delegation 2 --max-total-delegation 30 --remove-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --add-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator edit Name lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator edit Name lenght test above 70' "exceeds maximum length of 70" "${output}"
    assertContains 'Testing Validator edit Name lenght test above 70' "${output}" 'exceeds maximum length of 70 characters'
}

#Identity Lenghts above 3000 chars should return an error message containing the string : Exceed Maximum Length identity 3000
test_HMY_Validator_Creation_Identity_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John_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 --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create Identity lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator Create Identity lenght test above 3000' "Exceed Maximum Length identity 3000" "${output}"
    assertContains 'Testing Validator Create Identity lenght test above 3000' "${output}" 'exceeds maximum length of 3000 characters'
}
test_HMY_Validator_Edit_Identity_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John_6f4QzfDDeT0nHs6xnkRZpAl51X1isr7Oyg6VyTkA2tmyxqcCmCZR3nliKkZMagcyM3ZwmAHdzk9T9hxbtdywH1KoQIDsafI500o5ZIN2wW4BE5BT1r4mkdPG9xp9u6IzqGBE90ycjn8mb4QXe56PABeE3awskemog3zueBNb9pXc3pvAVMZvoTisVn2kSq3EwhF4Ca9YUhkaFaU13CnsLLAnBIBTSGgOfW0FL3Ojt58lOHBOOgiJudDfMxdNLCVAwN6x6fTLdALeHiUngwjJG0e681owDLNSbkHTB2txpVRexSmsBpPfURaZuC5RK9AeNulj6pqp2bYFXvu4Ln0ZmOeNUHLddeSHKchJTg3pnTLFUCANbztrNgHiLpjo2wiO9VV6MMiQ6VeSjEd0GWosOYdoiO25asQIv7Q1bLiHxIQ6ljtuLwouFK2u1v0gPzyIV4KvPTl2OmhFvanUBxE39Ez068tkGOIYZnmb2C65HyjTI77debcjxpzqOHOAuqtvCDYqy1orqqWTozHMycfIgB0ZCBLpQB3NfOCGBBD4oE4aT97nNGgzyxfB3CiYBvIFzi7w2a0ezQqSSYqY5IrnHXPC8bdvc1C9AYcjelD91tp0rgtg9dNbPXoj1I4PNus53RP1uDzqAHed6IlGN2fUqHDApJLFThUJKSTTrRvUkphh8tKbJnnvxj6O2GMg8zreYRWaGwPIlv15xO8FTxdLLcNfXFtnWgIrq4TNPME9CmhXLBd8lSvrUxH4OeNrm07XfjBVWyttt2SBNXM0fO9SNWCP5txLXukxW2pwi7v4IiqUcfYTYd3PejhTwfRrUHQHJ5rXvADlnV7DNvDscCNMY98LUG1hAjTFxOEZBWKvH8GriZviLAIfzkNAcSNBKxK4dQIejr4bGLCz9j9VDY07vxNBha2MQTYbYBv4Jw6S5dBNrcytF3kQN1xm5BFFM76EmsyX3XucNhKNggYKEs6dzBSkDsHMETcm21hRrBPffzJZKGojkxbZ9aF87HuNLOh9iaQfNI5n9L6MLhBi4QqEFAqNXi3qzIvjEU2c080kSgys0IRcGbbLrlcj9AHU6cWHufPHnwKaNHUpHXXqur8xzjlHF6ppwDBigjakv9uyNV8zbK2E0Hq2f4viRpffucXa8xHhPgj3ul4iM8GuRsTL2aqLxPEOweZ9B3xwGsaPD7Mzkz911u3MQouHxzoKw5pdUWs17CTKIVZMLehTfGRvkxay7SK3GEQ4kZ6Gs7gcy2Xz0kw0da3Q2iyo0IFSelqQSnsB87QrT3d9NLUz7u5ea3Rrw26xjkHVNRvB8hwu9KcDqglSn00B1B5vRgtHVaFVwzxnHTFXhYXMAuzROn7OBUPqaFQiAgR00yWXeGcogOixpXnEZrhWJeEYZlDc46red7X8grLb8nhufLbZR2ppdu9sqfy0zUGQKizMGTtMCxxd85LjtkOUhFENWASLbZLew6ryE8vd0vwz4MZoPplEXqqBAbV4ZHz6OWQo8kIcHLHezBzSeurrdkBKeuu4FZtWvMdmrhZHIc7OC7GoAxYr5C5LN4xRQFk3JFnYbHVksCbqoj4HiWv4yUyDQNGSblshjkmPUVxAjR7ljadEtSEptjER5vSvN7u2fMVe86P7TLrRxHYdJ05Op5iRr0BJWrxoFQPtZ0uYVYvleRuzJKq79bWYwhLZV80Q5KmCU6dfIAdv5IanLRmZLsFkFFmoeU4vyC8LlHvrodQwVu9KSQS7BFChLcb3nx57mw4mFtZb7sbJdDzOMleNexREZoSuwtBFPBqTZctauttsITZMphoFYlp37LnbMkQXlS4pCaSWfSZEVYy9Qg3fD5AG4qlExPrsB39zC61pSaxMIjLrpb7NYU0Eqic8G5jpU8zTU1OZEAcTEY8v9DK4RKiDZPQt63iIeFQQPjNgU3rt6NTKU2euESmwxB0KpmUygd6Zunq2OhFt7klr4KiCFfZUygVfMLeEYdoKlo6sixH4GVX0tqnK4OYskEAiTtx0B2UoP13KPC9yXb4stR8wroS2kDxkBvXKxIzOrBStIVf5FJu97AHbeOIlFmYkxYy5X9VPK76F8BBnE4kqN8RuLiB7Bv8NtK8v5k45pxktt9L1dW8GJwcd1ZTTvKJVsLDJJhMZYqvzWzSN0AOP4qnfovZwS6KXW2Er0vFidlh8XIS4whi7ypA6gJ9DCc92T6qqNtCN5LdDgd4YPLNGYlx6fRQE5hpFmSXBvbd86CQZwfWsCNQD4a1Wu5S68zTSk7HDzTu0SIVrarPzEPSTntJ2j7hjrezTW6zH2i1PAY0otvXgHQRTy6yoWjSY5rYtpu5SWiGGKwieXHag7rp2uwDnIkubW3UvC6LNwQs1LdMVn7zgpRvZDHIuv5ylgT5eNjFg28OCzgqJj7wfi8SwoyJNNJukT9JtdwtnTcZFMnzh8synlBHqQS1blyHlRd2srLsJkSUCrvOTSGgEGbKEDxf51CWRRP6bARt6AGfvnhFHlIoYjLm2kuFhbp5BSaL9HRklSVjMSzEalNJ9SoKgBWhsJcZRYhiNfFpqSZV99U4JwGQN62Vz6V96cqwAuSywWW9WWXDMg9P3kT9Axvtuay6I4wa7wEdMRefnrQvDQq9rMa8JYyqocDlRLHFiOJYeWuzxmZyolNWgt8xCjL91fl8nlijAy2zimbnRJN4uIdPaItCazshmfEx8DIW7UwHVHVzTgKp71N5ooHLxPfywnoNY0syZH0bVvmtdv8LtkKHva8VcUJEjt5sSUMhEbfdqOVaf4CthTApQjrt2IwPWEB4K36HzaiaKLOViByQFP0EID5pnF1NlUs99nMCvy4g5IzLqf25qUZ09olvOsZpLAEh66SKVqnNPT9iSEsasbuVaQy1CG0vHrv4mVm1uRCs9Unjs6j9JWIas4SlKW1YJ7Q8PDTPkysQ4zmpgI2lzowdVtw5X9r8GwUlV19qTdZ1wWdsPF9s4AxAC6G9HP1rCltQyydh0 --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --min-self-delegation 2 --max-total-delegation 30 --remove-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --add-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator edit Identity lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator edit Identity lenght test above 3000' "Exceed Maximum Length identity 3000" "${output}"
    assertContains 'Testing Validator edit Identity lenght test above 3000' "${output}" 'exceeds maximum length of 3000 characters'
}
#Website Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length website 140
test_HMY_Validator_Creation_Website_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --security-contact Alex --details "John the validator" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create Website lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator Create Website lenght test above 140' "Exceed Maximum Length website 140" "${output}"
    assertContains 'Testing Validator Create Website lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
}
test_HMY_Validator_Edit_Website_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --security-contact Alex --details "John the validator" --rate 0.1 --min-self-delegation 2 --max-total-delegation 30 --remove-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --add-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator edit Website lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator edit Website lenght test above 140' "Exceed Maximum Length website 140" "${output}"
    assertContains 'Testing Validator edit Website lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
}

#SecurityContact Lenghts above 140 chars should return an error message containing the string : Exceed Maximum Length security-contact 140
test_HMY_Validator_Creation_SecurityContact_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --details "John the validator" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create SecurityContact lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator Create WebSecurityContactsite lenght test above 140' "Exceed Maximum Length security-contact 140" "${output}"
    assertContains 'Testing Validator Create WebSecurityContactsite lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
}
test_HMY_Validator_Edit_SecurityContact_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex_gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P --details "John the validator" --rate 0.1 --min-self-delegation 2 --max-total-delegation 30 --remove-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --add-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator edit SecurityContact lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator edit WebSecurityContactsite lenght test above 140' "Exceed Maximum Length security-contact 140" "${output}"
    assertContains 'Testing Validator edit WebSecurityContactsite lenght test above 140' "${output}" 'exceeds maximum length of 140 characters'
}

#details Lenghts above 280 chars should return an error message containing the string : Exceed Maximum Length detail 280
test_HMY_Validator_Creation_Detail_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details "John the validator gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5PgjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 2 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create detail lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator Create detail lenght test above 280' "Exceed Maximum Length details 280" "${output}"
    assertContains 'Testing Validator Create detail lenght test above 280' "${output}" 'exceeds maximum length of 280 characters'
}
test_HMY_Validator_Edit_Detail_lenght() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details "John the validator gjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5PgjuDthEfXKsguvVih7WEFGgQRbolcgAeg40lO6zz0pHsfbh2sdMarB9mmopL6WdQlCJ3CJmp2437Qw4Hcyp47L2gBhNTZ8D6DjQ0UkK42Q5JkB3GuDUiyMNtMEVNXiN5ddTWQtcfuJ5P" --rate 0.1  --min-self-delegation 2 --max-total-delegation 30 --remove-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --add-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator edit detail lenght test which should be 1' "1" "${returncode}"
    #assertEquals 'Testing Validator edit detail lenght test above 280' "Exceed Maximum Length details 280" "${output}"
    assertContains 'Testing Validator edit detail lenght test above 280' "${output}" 'exceeds maximum length of 280 characters'
}
#min self delegation should be greater than 1
test_HMY_Validator_Creation_min_self_delegation_greater_than_1() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking create-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --max-rate 0.9 --max-change-rate 0.05 --min-self-delegation 0 --max-total-delegation 30 --bls-pubkeys 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --amount 3 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Create min self delegation test which should be 1' "1" "${returncode}"
    #Need to ask Harmony what is the expected error
    #assertEquals 'Testing Validator Create -min-self-delegation 0 (shoul be greater than 1)' "Exceed Maximum Length details 280" "${output}"
    assertContains 'Testing Validator Create -min-self-delegation 0 (shoul be greater than 1)' "${output}" 'min_self_delegation has to be greater than 1 ONE'
}
test_HMY_Validator_Edit_min_self_delegation_greater_than_1() {
    output=$((${HMYCLIPATH} --node=http://localhost:9500 staking edit-validator --validator-addr ${VALIDATOR_ADDR} --name John --identity John --website john@harmony.one --security-contact Alex --details "John the validator" --rate 0.1 --min-self-delegation 0 --max-total-delegation 30 --remove-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --add-bls-key 0xb9486167ab9087ab818dc4ce026edb5bf216863364c32e42df2af03c5ced1ad181e7d12f0e6dd5307a73b62247608611 --chain-id pangaea) 2>&1)
    returncode=$?
    assertEquals 'Testing error code of hmy Validator Edit min self delegation test which should be 1' "1" "${returncode}"
    #Need to ask Harmony what is the expected error
    #assertEquals 'Testing Validator Edit -min-self-delegation 0 (shoul be greater than 1)' "Exceed Maximum Length details 280" "${output}"
    assertContains 'Testing Validator Edit -min-self-delegation 0 (shoul be greater than 1)' "${output}" 'min_self_delegation has to be greater than 1 ONE'
}

# Load and run shUnit2.
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNITPATH}
