#!/bin/bash

# default settings for the caclulation of ETCCDI indices

mm=m  # output frequency: m=monthly
freq=mon

# percentile-based indices
window=5  # running window size
startboot=1961  # start base period
endboot=1990  # end base period

tas=tas
tasmax=tasmax
tasmin=tasmin
pr=pr

unit_pr_input="kg m-2 s-1"
pr_factor=86400

# unit_tas_input="K"
# tas_subtract="273.15"