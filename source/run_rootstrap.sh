#!/usr/bin/env bash

# run_rootstrap.sh 

# run root bootstrap code on target

# init 

source config.global
source tools

SCRIPT=`basename "$0"`

USAGE="\"$SCRIPT hostname\""

Begin run_rootstrap

if [ -z ${1+x} ]; then ErrorMsg "no target given, usage is $USAGE"; exit 1; fi;               TARGET_SPEC=$1

InfoMsg "run root bootstrap code on target $TARGET_SPEC"

InfoMsg "cloning admin bootstrap code to target"

ssh root@$TARGET_SPEC "rm -rf rootstrap; git clone https://github.com/christianknauer/rootstrap.git"
if [ ! $? == 0 ]; then
    ErrorMsg "could not clone rootstrap code"; exit 1;
fi

InfoMsg "run root bootstrap code on target"
ssh -t root@$TARGET_SPEC ". rootstrap/rootstrap.sh"

# EOF
