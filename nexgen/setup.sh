#!/bin/env bash

scp payload.sh knauer@btnkx1.inf.uni-bayreuth.de:
ssh -t knauer@btnkx1.inf.uni-bayreuth.de ./payload.sh
ssh knauer@btnkx1.inf.uni-bayreuth.de "rm ./payload.sh"
