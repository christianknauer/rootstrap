#!/usr/bin/env bash

# run_rootstrap.sh 

# run root bootstrap code on target

# init 

source config.global
source tools

SCRIPT=`basename "$0"`

USAGE="\"$SCRIPT hostname\""

Begin run_rootstrap

if [ -z ${1+x} ]; then ErrorMsg "no target given, usage is $USAGE [admin password]"; exit 1; fi; TARGET_SPEC=$1

ADMIN_PASSWORD=$(openssl rand 32 | base32)
if [ -z ${2+x} ]; then 
	InfoMsg "password for admin user not specified, generating random password"
else
	ADMIN_PASSWORD=$2
fi
InfoMsg "password for admin user: $ADMIN_PASSWORD"

InfoMsg "run root bootstrap code on target $TARGET_SPEC"

InfoMsg "cloning admin bootstrap code to target"

ssh root@$TARGET_SPEC "rm -rf rootstrap; git clone https://github.com/christianknauer/rootstrap.git"
if [ ! $? == 0 ]; then
    ErrorMsg "could not clone rootstrap code"; exit 1;
fi

InfoMsg "run root bootstrap code on target"
ssh -t root@$TARGET_SPEC ". rootstrap/rootstrap.sh $ADMIN_PASSWORD"

# EOF
