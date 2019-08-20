# IDF-data 🇨🇦
A set of methods to get ECCC IDF data from .txt files.

*Note: Compatible with Linux/MacOS only, sorry Windows users...* 😐

## Overview

Intensity-Duration-Frequency (IDF) data from Engineering Climate Datasets of Environment and Climate Change Canada (ECCC) are available for download in .txt format, a format that can be less convinient to use. IDF.jl offers methods to get ECCC IDF data in NetCDF (.nc) or CSV (.csv) format automatically from the .txt files from ECCC Client Climate server.

## Required dependencies 

### Julia dependencies

* CSV
* DataFrames
* Dates
* Glob
* NCDatasets
* ClimateTools (not required for data extraction)

### Command-line utilities

* unzip
* wget

## Getting started

Be sure to add the module to your path before using it :
```julia
push!(LOAD_PATH, "/path/to/dir/IDF-data/src/")
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

By choosing NetCDF format, it will return a NetCDF file for each station of the selected province with station informations and ECCC Short Duration Rainfall Intensity-Duration-Frequency Data from Table 1 : Annual Maximum (mm) :

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

By choosing CSV format, it will return a CSV file for each station of the selected province with ECCC Short Duration Rainfall Intensity-Duration-Frequency Data from Table 1 : Annual Maximum (mm) :

|Year  |5 min   |10 min  |15 min  |30 min  |1 h      |2 h      |6 h    |12 h   |24 h   |
|:-----|:------:|:------:|:------:|:------:|:-------:|:-------:|:-----:|:-----:|-----:|
|      |        |        |        |        |         |         |       |       |      |

Station informations for all the province are returned in a CSV file named info_stations_{PROVINCE_CODE}.csv :

|Name  |Province|ID      |Lat     |Lon     |Elevation|Number of years|CSV filename|Original filename|
|:-----|:------:|:------:|:------:|:------:|:-------:|:-------------:|:----------:|----------------:|
|      |        |        |        |        |         |               |            |                 |

## Examples

### NetCDF

Let's say someone wants to extract IDF data for Prince Edward Island (PE) in NetCDF format in the present working directory :

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

---
### Reading the NetCDF files with [ClimateTools](https://github.com/Balinus/ClimateTools.jl)

Methods are currently in development to load weather station netCDF files with `ClimateTools` in `weather_station` branch.

#### Installation

To install ClimateTools, follow the [installation guide](https://balinus.github.io/ClimateTools.jl/stable/installation/) and once the python dependencies are properly installed, you can then install the weather_station branch of ClimateTools :

```julia
pkg> add ClimateTools#weather_station
```

#### WeatherStation

The `WeatherStation` is a in-memory representation of a CF-compliant netCDF file for station data.

```julia
struct WeatherStation{A <: AxisArray}
    data::A
    lon::Real
    lat::Real
    alt::Real
    stationID::String # Alphanumerical ID of the weather station
    stationName::String # Name of the weather station
    filename::String # Path of the original file
    dataunits::String # Celsius, kelvin, etc.
    lonunits::String # Longitude coordinate unit
    latunits::String # Latitude coordinate unit
    altunits::String # Altitude coordinate unit
    variable::String # Type of variable
    typeofvar::String # Variable type (e.g. tasmax, tasmin, pr)
    typeofcal::String # Calendar type
    timeattrib::Dict # Time attributes (e.g. days since ... )
    varattribs::Dict # Variable attributes
    globalattribs::Dict # Global attributes
end
```

#### WeatherNetwork

The `WeatherNetwork` is a in-memory representation of a network of `WeatherStation`.

```julia
struct WeatherNetwork{A <: Array{WeatherStation}}
    data::A
    stationID::Array{String}
end
```
---
### Mapping

Mapping `WeatherNetwork` data can be done using `plotstation_data`.

```julia
plotweatherstation_data(W::WeatherNetwork, data; reg="canada", titlestr::String="", filename::String="", cs_label::String="")
```

#### Examples

British Columbia

![BC map](/images/BC_obs_24h.png)

Alberta

![AB map](/images/AB_obs_24h.png)

Saskatchewan

![SK map](/images/SK_obs_24h.png)

Manitoba

![MB map](/images/MB_obs_24h.png)

Ontario

![ON map](/images/ON_obs_24h.png)

Quebec

![QC map](/images/QC_obs_24h.png)

New Brunswick

![NB map](/images/NB_obs_24h.png)

Nova Scotia

![NS map](/images/NS_obs_24h.png)

Prince Edward Island

![PE map](/images/PE_obs_24h.png)

Newfoundland

![NL map](/images/NL_obs_24h.png)


## TO-DO

* Automatic deletion of .zip files
* Add ECCC weather station data (work in progress)
* Add tests and code coverage 




