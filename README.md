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
````julia
push!(LOAD_PATH, "/path/to/dir/IDF-data/src/")
using IDF
```
### Extract data

### Mapping

![Example map](/images/nbobs_max_rainfall_amount_24h_qc.png)
