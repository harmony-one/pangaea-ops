# Automated Testing Harmony CLI using shunit2

## Prerequesites

shell binaries/script required by the test script the same folder as node.sh and hmy binary

```bash
apt-get install -y jq bc awk
git clone https://github.com/harmony-one/pangaea-ops.git
git clone https://github.com/kward/shunit2.git
```

ONE account imported to the keystore and funded

### Create a new wallet

```bash
curl -LO https://harmony.one/hmycli && mv hmycli hmy && chmod +x hmy
./hmy keys add example-account --use-own-passphrase
```

### locate the keystore file and import it

```bash
./hmy keys import-ks ${pwd}/keystore/UTC--2019-11.....
```

take note of your one address (ie one1u6c4wer2dkm767hmjeehnwu6tqqur62gx9vqsd) and BLS pub Key (ie 7a43b05c6a2d9ba06bafdc22c4ef48a0e414775ab5b73de3fa34f8537260e8e82a70676326f2b4e8e9af086de36f1018) 

## Update the config variable file

in pangaea-ops/hmy-test/config.sh if you wanna use staking test without argument

If not, then just skip that section

## Execute the test

by default test would use the config.sh
```bash
bash pangaea-ops/hmy-test/basic-test.sh
bash pangaea-ops/hmy-test/staking-test.sh
bash pangaea-ops/hmy-test/staking-edit.sh
```

or bash pangaea-ops/hmy-test/staking-create.sh <VALIDATOR_ONE_ACCOUNT> <VALIDATOR_BLS_PUBKEY> 

bash pangaea-ops/hmy-test/staking-edit.sh <VALIDATOR_ONE_ACCOUNT> <VALIDATOR_BLS_PUBKEY> 

to overwrite values in config.sh example:

```
bash pangaea-ops/hmy-test/staking-create.sh one1u6c4wer2dkm767hmjeehnwu6tqqur62gx9vqsd 7a43b05c6a2d9ba06bafdc22c4ef48a0e414775ab5b73de3fa34f8537260e8e82a70676326f2b4e8e9af086de36f1018
```

the above allows you to recall the command after a git pull/git merge that could have eventually overwritten your config.sh
