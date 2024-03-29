#!/usr/bin/env bash

PAYLOAD="rootstrap_payload.sh"
[ -f "$PAYLOAD" ] && echo "payload $PAYLOAD is missing" && exit 1

TARGET="$1"

ADMIN_USERNAME="$2"
ADMIN_PASSWORD="$3"

[ -z "$TARGET" ] && echo "no target host specified" && exit 1

TARGET="root@$TARGET" 

if [ -z "$ADMIN_USERNAME" ]; then
  read -r -p "Enter admin username [administrator]: " ADMIN_USERNAME
  read -r -p "Enter admin full name [Administrator]: " ADMIN_NAME
fi
ADMIN_USERNAME=${ADMIN_USERNAME:-administrator}
ADMIN_NAME=${ADMIN_NAME:-Administrator}

if [ -z "$ADMIN_PASSWORD" ]; then
  read -r -p "Enter admin password: " ADMIN_PASSWORD
  [ -z "$ADMIN_PASSWORD" ] && ADMIN_PASSWORD=$(openssl rand 32 | base32)
fi
 
echo "creating $ADMIN_USERNAME ($ADMIN_NAME) with password $ADMIN_PASSWORD"

ssh "$TARGET" "echo ok" && echo "ssh $TARGET failed" && exit 1

scp "$PAYLOAD" "$TARGET":
ssh -t "$TARGET" "./$PAYLOAD \"$ADMIN_USERNAME\" \"$ADMIN_NAME\" \"$ADMIN_PASSWORD\""

# EOF
