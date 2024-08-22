#!/bin/bash

process_input() {
    # read flags: https://linuxconfig.org/bash-script-flags-usage-with-arguments-examples
    overwrite=false
    ARGS=()
    while [ $# -gt 0 ]; do
        unset OPTIND
        unset OPTARG
        while getopts 'o' options; do
            case "$options" in 
                o)
                    overwrite=true
                    ;;
                ?)
                    echo "Usage: $(basename $0) <infile> [<infile2>] <outdir> [-o]"
                    exit 1
            esac
        done
        shift $((OPTIND-1))
        if [ $# -gt 0 ]; then
            ARGS+=("$1")
        fi
        shift
    done

    # save positional arguments to appropriate variables
    if [ ${#ARGS[@]} -eq 2 ]; then
        infile="${ARGS[0]}"
        outdir="${ARGS[1]}"
    elif [ ${#ARGS[@]} -eq 3 ]; then
        infile="${ARGS[0]}"
        infile2="${ARGS[1]}"
        outdir="${ARGS[2]}"
    else
        echo "Usage: $(basename $0) <infile> [<infile2>] <outdir> [-o]"
        exit 1
    fi

    outdir=${outdir%/}  # remove tailing '/' if included
    mkdir -p $outdir
    
    outfile_base=$(basename ${infile%.nc})  
}

create_filename() {
    if [[ $# -ne 7 ]]; then
        echo "Wrong number of input arguments"
        exit 1
    fi
    local outdir=$1
    local outfile_base=$2
    local index=$3
    local freq=$4
    local window=$5
    local startboot=$6
    local endboot=$7

    local base="b${startboot}-${endboot}"

    is_perc_index=false
    perc_indices=('10p' '90p' 'r95p' 'r99p' 'tn10p' 'tn90p' 'tx10p' 'tx90p')
    for perc_index in "${perc_indices[@]}"; do
        if [ $index == ${perc_index}ETCCDI ]; then
            is_perc_index=true
            break
        fi
    done

    if [ $is_perc_index == true ]; then
        local outfile=$outdir/${index}_w${window}_${base}_${freq}__${outfile_base}
        echo $outfile
    else
        local outfile=$outdir/${index}_${freq}__${outfile_base}
        echo $outfile
    fi
}


skip_existing() {
    local outfile=$1
    local overwrite=$2
    
    if [ -f ${outfile}.nc ] && [ $overwrite == false ]; then
        echo "File already exists, skipping."
        echo ${outfile}.nc
        exit 1
    fi
}

check_pr_unit() {
    module load netcdf-c
    infile=$1
    pr=$2
    unit_pr_input="$3"
    
    unit=$(ncdump -h $infile | grep -A 1 "${pr}:" | grep units | awk -F\" '{print $2}')
    if [ "$unit" != "$unit_pr_input" ]; then
        echo "infile unit ($unit) does not match expected unit ($unit_pr_input)"
        echo $infile
        exit 1
    fi
}

# check_tas_unit() {
#     module load 
#     source default_settings.sh
#     infile=$1
#     unit=$(ncdump -h $infile | grep -A 1 "${pr}:" | grep units | awk -F\" '{print $2}')
#     if [ "$unit" != "$unit_tas_input" ]; then
#         echo "infile unit ($unit) does not match expected unit ($unit_tas_input)"
#         exit 1
#     fi
# }


# process_input() {
#     if [ -n "$1" ]; then
#       infile="$1"
#     else
#       echo "Usage: $(basename $0) <infile> <outdir>"
#       exit 1
#     fi
    
#     if [ -n "$2" ]; then
#       outdir="$2"
#     else
#       echo "Usage: $(basename $0) <infile> <outdir>"
#       exit 1
#     fi
    
#     if [[ ! $infile == *.nc ]]; then
#       echo "infile must be a .nc file not ${infile}"
#       exit 1
#     fi
    
#     outdir=${outdir%/}  # remove tailing '/' if included
#     mkdir -p $outdir
    
#     outfile_base=$(basename ${infile%.nc})    
# }

# process_input2() {
#     if [ -n "$1" ]; then
#       infile1="$1"
#     else
#       echo "Usage: $(basename $0) <infile> <infile> <outdir>"
#       exit 1
#     fi
    
#     if [ -n "$2" ]; then
#       infile2="$2"
#     else
#       echo "Usage: $(basename $0) <infile> <infile> <outdir>"
#       exit 1
#     fi

#     if [ -n "$3" ]; then
#       outdir="$3"
#     else
#       echo "Usage: $(basename $0) <infile> <infile> <outdir>"
#       exit 1
#     fi
    
#     if [[ ! $infile1 == *.nc ]]; then
#       echo "infile1 must be a .nc file not ${infile1}"
#       exit 1
#     fi

#     if [[ ! $infile2 == *.nc ]]; then
#       echo "infile2 must be a .nc file not ${infile2}"
#       exit 1
#     fi
    
#     outdir=${outdir%/}  # remove tailing '/' if included
#     mkdir -p $outdir
    
#     outfile_base=$(basename ${infile1%.nc})    
# }
    
