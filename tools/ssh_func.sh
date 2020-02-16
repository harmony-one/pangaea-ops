PSSH() { pssh -p 300 -x '-F/data/pangaea-ops/tools/ssh_config' "$@"; }
SSH() { ssh -F /data/pangaea-ops/tools/ssh_config "$@"; }
SCP() { scp -F /data/pangaea-ops/tools/ssh_config "$@"; }
