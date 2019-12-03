#Automated Testing Harmony using shunit2
```
How to perform test:
in the same folder as node.sh and hmy binary

https://github.com/harmony-one/pangaea-ops.git
mkdir test
cd test
git clone https://github.com/kward/shunit2.git
cd shunit2
cp -R ../../pangaea-ops/hmy-test .

executing basictest.sh : 
requirement
jq, bc
bash basictest.sh

for staking-test.sh there are some pre-requisites which is to have your one wallet account imported (if not done already):

Create a new wallet
curl -LO https://harmony.one/wallet.sh && chmod +x wallet.sh
./wallet.sh new
locate the keystore file and import it so hmy can use it in all the below command
./hmy keys import-ks /root/.hmy/keystore/UTC--2019-11.....
take note of your one address and update VALIDATOR_ADDR variable.
```

