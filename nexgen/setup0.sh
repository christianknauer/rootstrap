#!/usr/bin/env bash

scp payload0.sh root@btnkx1.inf.uni-bayreuth.de:
ssh -t root@btnkx1.inf.uni-bayreuth.de ./payload0.sh
ssh root@btnkx1.inf.uni-bayreuth.de "rm ./payload0.sh"

# EOF
