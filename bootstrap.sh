#!/bin/env bash

# use with default ssh key 
# ./bootstrap.sh knauer@btnkx1.inf.uni-bayreuth.de

# use with alternate ssh key 
# ./bootstrap.sh knauer@btnkx1.inf.uni-bayreuth.de "$(cat ~/.ssh/authorized_keys)"

PAYLOAD="bootstrap_payload.sh"
[ -f "$PAYLOAD" ] && echo "payload $PAYLOAD is missing" && exit 1

TARGET="$1"
[ -z "$TARGET" ] && echo "no target specified" && exit 1
shift

ssh "$TARGET" "echo ok" && echo "ssh $TARGET failed" && exit 1

scp "$PAYLOAD" "$TARGET":
ssh -t "$TARGET" "./$PAYLOAD \"$@\""

ssh -A "$TARGET"

# EOF
