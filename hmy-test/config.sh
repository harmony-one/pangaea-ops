# absolute path of the harmony folder
HARMONYPATH="/root/hmy-devnet/"

# path to shunit2:
SHUNITPATH=${HARMONYPATH}"shunit2/shunit2"

# path to hmy binary
HMYCLI_ABSOLUTE_FOLDER=${HARMONYPATH}
HMYCLIBIN="./hmy"
# hmy cli version
HMYCLIVERSION="v246-c28ff50"

#chain-id this test file is supposed run against
#available chain-id
#[ #As of 7 Dec 2019
#  "mainnet",
#  "testnet", ==> pangaea/testnet
#  "devnet" ==> devnet
#]
chainid="testnet"

#api endpoints
#mainnet: --node=https://api.s0.t.hmny.io
#Pangaea: --node=https://api.s0.p.hmny.io
#Devnet: --node=https://api.s0.pga.hmny.io
apiendpoint="api.s0.os.hmny.io"


#this address need to be imported to the keystore
VALIDATOR_ADDR="one1u6c4wer2dkm767hmjeehnwu6tqqur62gx9vqsd"
#address not present in your local keystore ./hmy keys list
NOT_PRESENT_VALIDATOR_ADDR="one143fyg8yu2pvxuq84qehwjtvlvxlpfvwe5z2y97" #address generated but not imported
#the above account will be used to signed all the transaction related to validator creation