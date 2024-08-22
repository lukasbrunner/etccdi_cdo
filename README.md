# Calculating the ETCCDI indices using cdo

Lukas Brunner (lukas.brunner@uni-hamburg.de) and Vidur Mithal

This repository provides the scripts to calculate 26 (of the 27) core climate change indices as suggested by the Expert Team on Climate Change Detection and Indices ([ETCCDI](http://etccdi.pacificclimate.org/list_27_indices.shtml)) using the Climate Data Operators ([cdo](https://code.mpimet.mpg.de/projects/cdo/embedded/index.html)). It follows a layered approach, meaning it provies scripts to calculate individual indices for a single dataset, a master script to calculate all indices for a single dataset, as well as all indices for multiple datasets. 

The calculation of the indieces is implemented partly using the cdo native functions for the indices (see [here](https://code.mpimet.mpg.de/projects/cdo/embedded/cdo_eca.pdf)) and partly manually using standard cdo functions. The version provided here was mainly implemented by Lukas Brunner heavily based on earlier work by Vidur Mithal. 

The implementation was evaluated against results from an R implementation of the same indices provided by the [ClimDexCalc2](https://bm1159.gitlab-pages.dkrz.de/plugins4freva/climdexcalc2/) tool as part of the Freva system on the German HPC system Levante. As test case the first member of the historical run of MPI-ESM1-2-LR in the period 1961-2014 is used. 

The repository is freely available under the [MPI License](./license)

## Usage

### Settings

By default the [`default_settings.sh`](default_settings.sh) file will be used, which might not work for all input files. For example, the variable names and unit for the precipitation variable can be changed here. For temperature Kelvin as well as degree Celsius work. Other settings that can be changed are the output frequency (monthly or annual) as well as the base-period and window size for seasonally running windows. The latter two are only used for percentile-based indices and ignored for the other indices. NOTE: some indices are only available for annual output, for these annual output will be enforces even when setting the frequency to monthly. 

NOTE: it is recommened to not change the `default_settings.sh` file but create a copy and link it, e.g.:

```bash
cp default_settings.sh manual_settings.sh
# change manual_settings.sh
unlink settings.sh
ln -s manual_settings.sh settings.sh
```

The naming convention for output files can be adjusted by updating the `create_filename` function in [`functions.sh`](functions.sh). By default the filename of the output is

```bash
index_frequency__input-filename.nc  # or
index_running-window_base-period_frequency__input-filename.nc  # for percentile-based files
```

### Calculate individual indices

To calculate an indidual index, the scripts in [`index_scripts`](index_scripts) can be used. For the example of TXX (warmest day in a year/month)

```bash
./calculate_etccdi_txx.sh infile.nc outpath [-o]
```

- `infile.nc`: The full path to the input file, which is expected to contain only a single variable, namely the daily maximum temperature `tasmax`. 
- `outpath`: The path where the results will be save, it can be identical to the path of the input file, the input will not be overwritten.
- `-o`: An uptional flag, if set existing output will be overwritten.

A few indices (WSDI, CSDI, GSL, DTR) need more than one input file, in this case the format is:

```bash
./calculate_etccdi_wsdi.sh infile.nc threshold_file.nc outpath [-o]
```

The threshold file for the WSDI can be calculated using

```bash
./_calculate_etccdi_90p_threshold.sh infile.nc outpath
```

### Calculate all indices

The calculate all indices the script [`calculate_etccdi_all.sh`](calculate_etccdi_all.sh) can be used. If only a subset of indices are needed, they can be commented in or out there as needed. 

```bash
./calculate_etccdi_all.sh tasmax.nc tasmin.nc tas.nc pr.nc land_sea_fraction.nc outpath [-o, '']
```

NOTE: all 7 inputs need to be given in that exact order. THERE IS CURRENTLY NO CHECKS FOR WONG ORDERS AND THE SCRIPTS WILL CALCUATE TXX ALSO BASED ON TASMIN IF PROVIDED WRONGLY!

### Calculate all indices for multiple models or memebers

This is as easy as calling [`calculate_etccdi_all.sh`](calculate_etccdi_all.sh) in a separate script multiple times, potentially using a loop. An example is given in the file [`calculate_etccdi_mpi-esm1-2-lr.sh`](calculate_etccdi_mpi-esm1-2-lr.sh) for a single model. 

## Performance

Calculate all indices for MPI-ESM1-2-LR (192x96 = 18'432 grid cells) in the period 1850-2014 (60'265 days) on Levante takes about 1 hour (TODO). See [`run_calculate_etccdi_mpi-esm1-2-lr.sh`](run_calculate_etccdi_mpi-esm1-2-lr.sh) for details about the ressources requested.   

## Testing and known bugs

There are several indices with slighly larger devaitions between cdo and ClimDexCalc2 but only one index with considerably differences: 

- GSL is highly likely to be slightly wrong in cdo for regions with an year-round growing season. The suspected reason is that a 6 consequtive days criterion is used leading to the first 5 days in a given year never being assigned as growing season. The cdo version hence has a maximum growing season length of 360 for MPI-ESM and GSL is undersetimated compared to ClimDexCalc2 in most of the southern hemisphre. 

- SDII has small but spatially coherent deviations between the two calculation methods of up to 0.5 mm/day for regions with very little precipitation (Sahara and Antarctica)
- r95p and r99p both show spatially random deviations of up to 2mm/day
- CSDI and WSDI both show spatially coherent deviations of up to 1 day

Maps and time-series of all variables can be found under [`tests/compare_mpi-esm1-2-lr_cdo-climdexcalc2.ipynb`](tests/compare_mpi-esm1-2-lr_cdo-climdexcalc2.ipynb)

Example data can be found at `/work/uc1275/LukasBrunner/data/etccdi_cdo`

