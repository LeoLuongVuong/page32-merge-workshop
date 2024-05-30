#!/bin/bash

#$ -wd /data/home/sethg/example-projects/page32-merge-workshop/model/pk/102

/opt/NONMEM/nm75/run/nmfe75 102.ctl  102.lst  -maxlim=2
