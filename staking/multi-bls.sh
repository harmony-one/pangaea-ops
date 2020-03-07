#! /bin/bash

hmybin="hmy"
currentdir=$(dirname "$0")
count=1
max=80 
mkdir -p ${currentdir}/.hmy/blskeys
while [ $count -le $max ]
do
    echo $count
    pubkey=$($hmybin keys generate-bls-key | grep public-key | cut -d '"' -f 4)
    shardgen=$($hmybin utility shard-for-bls $pubkey -n http://34.228.217.167:9500 | jq '.["shard-id"]')
    if [ $shardgen -eq 1 ]
    then
        cp ${currentdir}/${pubkey}.key ${currentdir}/.hmy/blskeys
        count=$(( $count + 1 ))
   else
        rm $pubkey.key
    fi
done
echo done