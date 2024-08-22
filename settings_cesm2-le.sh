#!/bin/bash

# default settings for the caclulation of ETCCDI indices

mm=m  # output frequency: m=monthly, y=yearly
freq=mon  # NOTE: also adjust! mon or ann

# percentile-based indices
window=5  # running window size
startboot=1981  # start base period
endboot=2010  # end base period

tas=''
tasmax=TREFHTMX
tasmin=TREFHTMN
pr=PRECT

unit_pr_input="m/s"
pr_factor=86400000
