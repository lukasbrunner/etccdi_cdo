#!/bin/bash

# default settings for the caclulation of ETCCDI indices

mm=y  # output frequency: m=monthly, y=yearly
freq=ann  # NOTE: also adjust! mon or ann

# mm=m  # output frequency: m=monthly, y=yearly
# freq=mon  # NOTE: also adjust! mon or ann

# percentile-based indices
window=5  # running window size
startboot=2020  # start base period
endboot=2049  # end base period

tas=tas
tasmax=tasmax
tasmin=tasmin
pr=pr

unit_pr_input="kg m-2 s-1"
pr_factor=86400

# unit_tas_input="K"
# tas_subtract="273.15"