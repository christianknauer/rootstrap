#!/bin/env bash

# use with default ssh key 
# ./setup.sh 

# use with ssh key 
# ./setup.sh "$(cat ~/.ssh/authorized_keys)"

echo -n "Transfering "
scp payload.sh knauer@btnkx1.inf.uni-bayreuth.de:
ssh -t knauer@btnkx1.inf.uni-bayreuth.de "./payload.sh \"$@\""
ssh knauer@btnkx1.inf.uni-bayreuth.de "rm ./payload.sh"
ssh -A knauer@btnkx1.inf.uni-bayreuth.de 
