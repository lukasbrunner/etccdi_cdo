#!/bin/bash

# default settings for the caclulation of ETCCDI indices

mm=y  # output frequency: m=monthly, y=yearly
freq=ann  # NOTE: also adjust! mon or ann

# mm=m  # output frequency: m=monthly, y=yearly
# freq=mon  # NOTE: also adjust! mon or ann

# percentile-based indices
window=5  # running window size
# NOTE: first year (2020) is missing first 20 days -> don't use
startboot=2021  # start base period
endboot=2049  # end base period

# startboot=1990  # start base period
# endboot=2019  # end base period

tas=tas
tasmax=tasmax
tasmin=tasmin
pr=pr

unit_pr_input="m"
pr_factor=1000

# unit_tas_input="K"
# tas_subtract="273.15"