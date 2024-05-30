#!/bin/bash

#$ -wd /data/home/sethg/example-projects/page32-merge-workshop/model/pk/199

/opt/NONMEM/nm75/run/nmfe75 199.ctl  199.lst  -maxlim=2
