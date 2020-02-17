# absolute path of the harmony folder
HARMONYPATH="/root/harmony/"

# path to shunit2:
SHUNITPATH=${HARMONYPATH}"shunit2/shunit2"

# path to hmy binary
HMYCLI_ABSOLUTE_FOLDER=${HARMONYPATH}
HMYCLIBIN="./hmy"
# hmy cli version
HMYCLIVERSION="v279-8b78c50"

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


#validator address to be imported in the keystore
VALIDATOR_ADDR="one1u6c4wer2dkm767hmjeehnwu6tqqur62gx9vqsd"
#the above account will be used to signed all the transaction related to validator creation

#address not present in your local keystore ./hmy keys list
#address generated previously but not imported
NOT_PRESENT_VALIDATOR_ADDR="one143fyg8yu2pvxuq84qehwjtvlvxlpfvwe5z2y97" 

#BLS KEY associate with the validator for testing, the key needs to exist in the same folder as hmy
BLS_PUBKEY="7a43b05c6a2d9ba06bafdc22c4ef48a0e414775ab5b73de3fa34f8537260e8e82a70676326f2b4e8e9af086de36f1018"