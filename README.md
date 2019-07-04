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

#### CSV

### Mapping

![Example map](/images/nbobs_max_rainfall_amount_24h_qc.png)
