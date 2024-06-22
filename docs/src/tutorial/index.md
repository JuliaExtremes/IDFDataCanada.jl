# Getting started

## Installation

*IDFDataCanada* is a registered package. It can be installed using Julia's builtin package manager:

```julia
Pkg> add IDFDataCanada
```

## Extract data

The key feature of *IDFDataCanada* is the `data_download` function. It can be used directly by providing the province code (ex: `"QC"` for Quebec), the output directory (must be an existing folder) and the format (`CSV` or `netCDF`). By default, `CSV` format is selected and all provinces will be downloaded if no province code is provided. The two keyword arguments, `split` and `rm_temp`, can be set to extract data in a subfolder for each province or to keep the temporarily downloaded zip files. To download more than one province at the time, an array of province codes can by used (ex: `["QC", "ON"]` for Quebec and Ontario).

```julia
data_download(output_dir::String, province::String="all", format::String="csv"; split::Bool=false, rm_temp::Bool=true)
data_download(output_dir::String, provinces::Array{String,N} where N, format::String="csv"; split::Bool=false, rm_temp::Bool=true)
```

`data_download` will create output files of the specified format in the output directory and a CSV a file containing station information named `info_stations.csv`.