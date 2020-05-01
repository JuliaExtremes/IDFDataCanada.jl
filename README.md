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

*IDF-data* is not (yet) a registered package, so installing it directly with Julia's builtin package manager (Pkg) is not possible. Thus, there is two ways to use the package after having it cloned:

```
$ git clone https://github.com/houton199/IDF-data.git /path/to/dir/
```

#### 1) Add the module to Julia's loading path:

If all the required dependencies are installed, one can simply add the module to Julia's loading path before using it:

```julia
push!(LOAD_PATH, "/path/to/dir/IDF-data/src/")
using IDF
```

#### 2) Activate the environnement and install the required dependencies:

If all the required dependencies are **not** installed, running Pkg's *instantiate* will download all the required dependencies:

```
$ cd /path/to/dir/IDF-data
$ julia
pkg> activate .
pkg> instantiate
```

```julia
using IDF
```

### Extract data

There is two ways to execute data extraction. The first one is to call the `data_download` function directly by providing the province code (ex: "QC" for Quebec), the output directory (must be an existing folder) and the format (CSV or netCDF).

The url (**ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Engineering_Climate_Dataset/IDF/idf_v3-00_2019_02_27/IDF_Files_Fichiers/**) and the basename of the files (**IDF_v3.00_2019_02_27**) are set by default but can be entered as keyword arguments (as they will change with data update).

```julia
data_download(province, output_dir, format; url, basename)
```

`data_download` will create output files of the specified format in the output directory.


The second way is to call the `extract.jl` script.
```console
julia extract.jl
```

The extract script will ask you which province data you want to download, its output directory and its format. It will automatically download the data and create output files of the specified format in the output directory.

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

|Year  |5 min   |10 min  |15 min  |30 min  |1 h      |2 h      |6 h    |12 h   |24 h   |
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
unzip:  cannot find or open IDF_v3.00_2019_02_27_PE.zip, IDF_v3.00_2019_02_27_PE.zip.zip or IDF_v3.00_2019_02_27_PE.zip.ZIP.
--2019-08-20 10:16:55--  ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Engineering_Climate_Dataset/IDF/idf_v3-00_2019_02_27/IDF_Files_Fichiers/IDF_v3.00_2019_02_27_PE.zip
           => « IDF_v3.00_2019_02_27_PE.zip »
Résolution de ftp.tor.ec.gc.ca (ftp.tor.ec.gc.ca)… 199.212.19.56
Connexion à ftp.tor.ec.gc.ca (ftp.tor.ec.gc.ca)|199.212.19.56|:21… connecté.
Ouverture de session en tant que client_climate… Session établie.
==> SYST ... terminé.    ==> PWD ... terminé.
==> TYPE I ... terminé.  ==> CWD (1) /Pub/Engineering_Climate_Dataset/IDF/idf_v3-00_2019_02_27/IDF_Files_Fichiers ... terminé.
==> SIZE IDF_v3.00_2019_02_27_PE.zip ... 2899710
==> PASV ... terminé.    ==> RETR IDF_v3.00_2019_02_27_PE.zip ... terminé.
Taille : 2899710 (2,8M) (non certifiée)

IDF_v3.00_2019_02_2 100%[===================>]   2,76M  3,26MB/s    ds 0,8s    

2019-08-20 10:16:56 (3,26 MB/s) - « IDF_v3.00_2019_02_27_PE.zip » sauvegardé [2899710]

Archive:  IDF_v3.00_2019_02_27_PE.zip
   creating: IDF_v3.00_2019_02_27_PE/
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A.txt  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A_qq.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A_qq.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A_r.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A_r.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A_t.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300301_CHARLOTTETOWN_A_t.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE.txt  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE_qq.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE_qq.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE_r.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE_r.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE_t.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_8300596_SUMMERSIDE_t.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS.txt  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS_qq.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS_qq.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS_r.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS_r.png  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS_t.pdf  
  inflating: IDF_v3.00_2019_02_27_PE/idf_v3-00_2019_02_27_830_PE_830P001_HARRINGTON_CDA_CS_t.png  
CHARLOTTETOWN A
8300301.nc : OK
SUMMERSIDE
8300596.nc : OK
HARRINGTON CDA CS
830P001.nc : OK
```

Three netCDF files (8300301.nc, 8300596.nc and 830P001.nc) corresponding to the Prince Edward Island stations will be returned in the present working directory.

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




