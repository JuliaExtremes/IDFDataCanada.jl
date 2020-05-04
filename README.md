# IDFDataCanada.jl 🇨🇦
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

A set of methods to get ECCC IDF data from .txt files.

*Work in progress: run at your own risk*

*Note: Compatible with Linux/MacOS only, sorry Windows users...* 😐

## Overview

Intensity-Duration-Frequency (IDF) data from Engineering Climate Datasets of Environment and Climate Change Canada (ECCC) are available for download in .txt format, a format that can be less convinient to use. IDFDataCanada.jl offers methods to get ECCC IDF data in NetCDF (.nc) or CSV (.csv) format automatically from the .txt files from ECCC's [Google Drive](https://drive.google.com/open?id=1VsJnWGfz2NTzT4orgTH1RL3yzZcrdYTC).

## Required dependencies 

### Julia dependencies

* CSV
* DataFrames
* Dates
* Glob
* HTTP
* LibCURL
* NCDatasets

### Command-line utilities

* unzip

## Getting started

### Installation

*IDFDataCanada* is now a registered package. It can be installed using  Julia's builtin package manager:

```
Pkg> add IDFDataCanada
```


### Extract data

The key feature of *IDFDataCanada* is the `data_download` function. It can be used directly by providing the province code (ex: "QC" for Quebec), the output directory (must be an existing folder) and the format (CSV or netCDF). CSV format is selected by default. The two keyword arguments, split and rm_temp, can be set to extract data in a subfolder for each province or to keep the temporarily downloaded zip files.

```julia
using IDFDataCanada
data_download(province::String, output_dir::String, format::String="csv"; split::Bool=false, rm_temp::Bool=true)
```

`data_download` will create output files of the specified format in the output directory.


### Format

#### NetCDF

By choosing NetCDF format, it will return a NetCDF file for each station of the selected province with station informations and ECCC Short Duration Rainfall Intensity-Duration-Frequency Data from Table 1: Annual Maximum (mm).

```
dimensions:
	station = UNLIMITED ; // (1 currently)
	obs = UNLIMITED ; // (29 currently)
	name_strlen = UNLIMITED ; // (20 currently)
	id_strlen = UNLIMITED ; // (7 currently)
variables:
	float lon(station) ;
		lon:standard_name = "longitude" ;
		lon:long_name = "station longitude" ;
		lon:units = "degrees_east" ;
	float lat(station) ;
		lat:standard_name = "latitude" ;
		lat:long_name = "station latitude" ;
		lat:units = "degrees_north" ;
	float alt(station) ;
		alt:long_name = "vertical distance above the surface" ;
		alt:standard_name = "height" ;
		alt:units = "m" ;
		alt:positive = "up" ;
		alt:axis = "Z" ;
	char station_name(name_strlen, station) ;
		station_name:long_name = "station name" ;
	char station_ID(id_strlen, station) ;
		station_ID:long_name = "station id" ;
		station_ID:cf_role = "timeseries_id" ;
	int row_size(station) ;
		row_size:long_name = "number of observations for this station" ;
		row_size:sample_dimension = "obs" ;
	double time(obs) ;
		time:standard_name = "time" ;
		time:units = "days since 1900-01-01" ;
	float max_rainfall_amount_5min(obs) ;
		max_rainfall_amount_5min:long_name = "Annual maximum rainfall amount 5-minutes" ;
		max_rainfall_amount_5min:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_5min:cell_methods = "time: sum over 5 min time: maximum within years" ;
		max_rainfall_amount_5min:units = "mm" ;
	float max_rainfall_amount_10min(obs) ;
		max_rainfall_amount_10min:long_name = "Annual maximum rainfall amount 10-minutes" ;
		max_rainfall_amount_10min:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_10min:cell_methods = "time: sum over 10 min time: maximum within years" ;
		max_rainfall_amount_10min:units = "mm" ;
	float max_rainfall_amount_15min(obs) ;
		max_rainfall_amount_15min:long_name = "Annual maximum rainfall amount 15-minutes" ;
		max_rainfall_amount_15min:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_15min:cell_methods = "time: sum over 15 min time: maximum within years" ;
		max_rainfall_amount_15min:units = "mm" ;
	float max_rainfall_amount_30min(obs) ;
		max_rainfall_amount_30min:long_name = "Annual maximum rainfall amount 30-minutes" ;
		max_rainfall_amount_30min:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_30min:cell_methods = "time: sum over 30 min time: maximum within years" ;
		max_rainfall_amount_30min:units = "mm" ;
	float max_rainfall_amount_1h(obs) ;
		max_rainfall_amount_1h:long_name = "Annual maximum rainfall amount 1-hour" ;
		max_rainfall_amount_1h:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_1h:cell_methods = "time: sum over 1 hour time: maximum within years" ;
		max_rainfall_amount_1h:units = "mm" ;
	float max_rainfall_amount_2h(obs) ;
		max_rainfall_amount_2h:long_name = "Annual maximum rainfall amount 2-hours" ;
		max_rainfall_amount_2h:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_2h:cell_methods = "time: sum over 2 hour time: maximum within years" ;
		max_rainfall_amount_2h:units = "mm" ;
	float max_rainfall_amount_6h(obs) ;
		max_rainfall_amount_6h:long_name = "Annual maximum rainfall amount 6-hours" ;
		max_rainfall_amount_6h:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_6h:cell_methods = "time: sum over 6 hours time: maximum within years" ;
		max_rainfall_amount_6h:units = "mm" ;
	float max_rainfall_amount_12h(obs) ;
		max_rainfall_amount_12h:long_name = "Annual maximum rainfall amount 12-hours" ;
		max_rainfall_amount_12h:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_12h:cell_methods = "time: sum over 12 hours time: maximum within years" ;
		max_rainfall_amount_12h:units = "mm" ;
	float max_rainfall_amount_24h(obs) ;
		max_rainfall_amount_24h:long_name = "Annual maximum rainfall amount 24-hours" ;
		max_rainfall_amount_24h:coordinates = "time lat lon alt station_ID" ;
		max_rainfall_amount_24h:cell_methods = "time: sum over 24 hours time: maximum within years" ;
		max_rainfall_amount_24h:units = "mm" ;

// global attributes:
		:featureType = "timeSeries" ;
		:title = "Short Duration Rainfall Intensity-Duration-Frequency Data (ECCC)" ;
		:Conventions = "CF-1.7" ;
		:comment = "see H.2.4. Contiguous ragged array representation of time series" ;
		:original_source = "idf_v3-00_2019_02_27_702_PROV_STATIONID_STATIONNAME.txt" 
```

#### CSV

By choosing CSV format, it will return a CSV file for each station of the selected province with ECCC Short Duration Rainfall Intensity-Duration-Frequency Data from Table 1: Annual Maximum (mm).

|Année  |5min   |10min  |15min  |30min  |1h      |2h      |6h    |12h   |24h   |
|:-----|:------:|:------:|:------:|:------:|:-------:|:-------:|:-----:|:-----:|-----:|
|      |        |        |        |        |         |         |       |       |      |

Station informations for all the province are returned in a CSV file named info_stations_{PROVINCE_CODE}.csv :

|Name  |Province|ID      |Lat     |Lon     |Elevation|Number of years|CSV filename|Original filename|
|:-----|:------:|:------:|:------:|:------:|:-------:|:-------------:|:----------:|----------------:|
|      |        |        |        |        |         |               |            |                 |

## Examples

### NetCDF

Let's say someone wants to extract IDF data for Prince Edward Island (PE) in NetCDF format in the present working directory:

```julia
julia> using IDF
julia> data_download("PE", pwd(), "netcdf")
IDF_v3.10_2020_03_27_PE.zip
Archive:  IDF_v3.10_2020_03_27_PE.zip
   creating: IDF_v3.10_2020_03_27_PE/
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A.txt  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A_qq.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A_qq.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A_r.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A_r.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A_t.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300301_CHARLOTTETOWN_A_t.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS.txt  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS_qq.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS_qq.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS_r.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS_r.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS_t.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300562_ST._PETERS_t.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE.txt  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE_qq.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE_qq.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE_r.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE_r.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE_t.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8300596_SUMMERSIDE_t.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS.txt  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS_qq.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS_qq.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS_r.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS_r.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS_t.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_8305500_MAPLE_PLAINS_t.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS.txt  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS_qq.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS_qq.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS_r.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS_r.png  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS_t.pdf  
  inflating: IDF_v3.10_2020_03_27_PE/idf_v-3.10_2020_03_27_830_PE_830P001_HARRINGTON_CDA_CS_t.png  
CHARLOTTETOWN A
8300301.nc : OK
ST. PETERS
8300562.nc : OK
SUMMERSIDE
8300596.nc : OK
MAPLE PLAINS
8305500.nc : OK
HARRINGTON CDA CS
830P001.nc : OK
```

Five netCDF files (8300301.nc, 8300562.nc, 8300596.nc, 8305500.nc and 830P001.nc) corresponding to the Prince Edward Island stations will be returned in the present working directory.

### CSV

Then, let's say someone wants to extract IDF data for Prince Edward Island (PE) in CSV format in the present working directory after having already downloaded the zip file:

```
julia> data_download("PE", pwd(), "csv")
Archive:  IDF_v3.00_2019_02_27_PE.zip
replace IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A.pdf? [y]es, [n]o, [A]ll, [N]one, [r]ename: N
CHARLOTTETOWN A
8300301.csv : OK
SUMMERSIDE
8300596.csv : OK
HARRINGTON CDA CS
830P001.csv : OK
```

Three CSV files (8300301.csv, 8300596.csv and 830P001.csv) corresponding to the Prince Edward Island stations data and another CSV file (info\_stations\_PE.csv) containing the stations information will be returned in the present working directory.
 


## TO-DO

* Add tests 
* Add ECCC weather station data (*work in progress*)




