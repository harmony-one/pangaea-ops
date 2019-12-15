#absolute path of the harmony folder
HARMONYPATH="/root/hmy-devnet/"

#path to shunit2:
SHUNITPATH=${HARMONYPATH}"shunit2/shunit2"

#path to hmy binary
HMYCLI_ABSOLUTE_FOLDER=${HARMONYPATH}
HMYCLIBIN="./hmy"

#chain-id this test file is supposed run against
#available chain-id
#[ #As of 7 Dec 2019
#  "mainnet",
#  "testnet", ==> pangaea/testnet
#  "devnet" ==> devnet
#]
chainid="devnet"

#api endpoints
#Pangaea: --node=https://api.s0.p.hmny.io
#Devnet: --node=https://api.s0.pga.hmny.io
apiendpoint="localhost:9500"