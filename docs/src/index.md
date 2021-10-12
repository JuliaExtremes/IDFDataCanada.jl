# IDFDataCanada.jl

*[IDFDataCanada.jl](https://github.com/houton199/IDFDataCanada.jl)* provides a set of methods to get ECCC IDF data from .txt files.

## Overview

Intensity-Duration-Frequency (IDF) data from Engineering Climate Datasets of Environment and Climate Change Canada (ECCC) are available for download in .txt format, a format that can be less convinient to use. IDFDataCanada.jl offers methods to get ECCC IDF data in NetCDF (.nc) or CSV (.csv) format automatically from the .txt files from ECCC's [Google Drive](https://drive.google.com/open?id=1VsJnWGfz2NTzT4orgTH1RL3yzZcrdYTC).

## Required dependencies 

### Julia dependencies

* CSV
* DataFrames
* Dates
* PyCall
* NCDatasets

### Python dependencies

* gdown : to download large files from Google Drive without failing because of the security warning.

### Command-line utilities

* unzip