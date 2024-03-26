#!/bin/env bash

# rootstrap.sh 

# root user bootstrap code for system setup

[ "`id -u`" -ne 0 ] && echo "Must be run as root!" && exit 1

read -p "Enter admin username [administrator]: " ADMIN_USERNAME
ADMIN_USERNAME=${ADMIN_USERNAME:-administrator}

# check if the admin user already exists
if ! id -u "$ADMIN_USERNAME" >/dev/null 2>&1; then
    read -p "Enter admin full name [Administrator]: " ADMIN_NAME
    ADMIN_NAME=${ADMIN_NAME:-Administrator}
    echo "Creating admin user $ADMIN_NAME ($ADMIN_USERNAME)"
    #adduser ${ADMIN_USERNAME} --gecos "$ADMIN_USERNAME"
    adduser ${ADMIN_USERNAME} --gecos "$ADMIN_USERNAME" --disabled-password
fi

ADMIN_PASSWORD=$(openssl rand 32 | base32)
if [ -z ${1+x} ]; then 
	echo "password for admin user not specified, generating random password"
else
	ADMIN_PASSWORD=$1
fi
echo "password for admin user: $ADMIN_PASSWORD"

echo "${ADMIN_USERNAME}:${ADMIN_PASSWORD}" | chpasswd

# EOF
