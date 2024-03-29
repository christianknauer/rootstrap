#!/bin/env bash

# rootstrap.sh 

# root user bootstrap code for system setup

[ "$(id -u)" -ne 0 ] && echo "Must be run as root!" && exit 1

ADMIN_USERNAME="$1"
ADMIN_NAME="$2"
ADMIN_PASSWORD="$3"

if ! id -u "$ADMIN_USERNAME" >/dev/null 2>&1; then
    echo "creating user $ADMIN_NAME ($ADMIN_USERNAME)"
    adduser "$ADMIN_USERNAME" --gecos "$ADMIN_USERNAME" --disabled-password
else
  echo "the user $ADMIN_NAME already exists"
fi

echo "${ADMIN_USERNAME}:${ADMIN_PASSWORD}" | chpasswd

rm -f "$0"

# EOF
