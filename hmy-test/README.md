# Automated Testing Harmony using shunit2

## Prerequesites

- shell binaries/script required by the test script the same folder as node.sh and hmy binary

```bash
apt-get install -y jq bc
git clone https://github.com/harmony-one/pangaea-ops.git
git clone https://github.com/kward/shunit2.git
```

- account imported to the keystore

### Create a new wallet

```bash
curl -LO <https://harmony.one/wallet.sh> && chmod +x wallet.sh
./wallet.sh new
```

### locate the keystore file and import it

```bash
./hmy keys import-ks ${pwd}/keystore/UTC--2019-11.....
```

take note of your one address and update VALIDATOR_ADDR variable.

## Update the config variable file

in pangaea-ops/hmy-test/config.sh

## Execute the test

```bash
bash pangaea-ops/hmy-test/basic-test.sh
or
bash pangaea-ops/hmy-test/staking-test.sh
```
