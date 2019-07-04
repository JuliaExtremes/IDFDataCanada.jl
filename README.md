# IDF-data
A set of methods to get ECCC IDF data from .txt files

## Required dependencies 

### Julia dependencies

* ClimateTools
* CSV
* DataFrames
* Dates
* Glob
* NCDatasets

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

There is two ways to execute data extraction. The first one is to call the `data_download` function directly by providing the province code (ex: "QC" for Quebec), the output directory (existing folder) and the format (CSV or netCDF). The url (ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Engineering_Climate_Dataset/IDF/idf_v3-00_2019_02_27/IDF_Files_Fichiers/) and the basename of the files (IDF_v3.00_2019_02_27) are set by default but can be entered as keyword arguments (they will change with data update).

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
		:original_source = "idf_v3-00_2019_02_27_702_QC_7027320_MONTREAL_ST-HUBERT_A.txt" 
```

#### CSV

By choosing CSV format, it will return a CSV file for each station of the selected province with ECCC Short Duration Rainfall Intensity-Duration-Frequency Data from Table 1 : Annual Maximum (mm) :

|Year  |5 min   |10 min  |15 min  |30 min  |1 h      |2 h      |6 h    |12 h   |24h   |
|:-----|:------:|:------:|:------:|:------:|:-------:|:-------:|:-----:|:-----:|-----:|
|      |        |        |        |        |         |         |       |       |      |

Station informations for all the province are returned in a CSV file named info_stations_{PROVINCE_CODE}.csv :

|Name  |Province|ID      |Lat     |Lon     |Elevation|Number of years|CSV filename|Original filename|
|:-----|:------:|:------:|:------:|:------:|:-------:|:-------------:|:----------:|----------------:|
|      |        |        |        |        |         |               |            |                 |




### Mapping

![Example map](/images/nbobs_max_rainfall_amount_24h_qc.png)
