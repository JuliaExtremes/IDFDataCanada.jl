# Examples

## CSV

Let's say someone wants to extract IDF data for Prince Edward Island (PE) in CSV format in the present working directory:

```julia
julia> using IDFDataCanada
julia> data_download(pwd(), "PE")
Archive:  PE.zip
  inflating: PE/idf_v3-30_2022_10_31_830_PE_8300301_CHARLOTTETOWN_A.txt  
  inflating: PE/idf_v3-30_2022_10_31_830_PE_8300418_EAST_POINT_(AUT).txt  
  inflating: PE/idf_v3-30_2022_10_31_830_PE_8300516_NORTH_CAPE.txt  
  inflating: PE/idf_v3-30_2022_10_31_830_PE_8300562_ST._PETERS.txt  
  inflating: PE/idf_v3-30_2022_10_31_830_PE_8300596_SUMMERSIDE.txt  
  inflating: PE/idf_v3-30_2022_10_31_830_PE_8305500_MAPLE_PLAINS.txt  
  inflating: PE/idf_v3-30_2022_10_31_830_PE_830P001_HARRINGTON_CDA_CS.txt  
CHARLOTTETOWN A
8300301.csv : OK
EAST POINT (AUT)
8300418.csv : OK
NORTH CAPE
8300516.csv : OK
ST. PETERS
8300562.csv : OK
SUMMERSIDE
8300596.csv : OK
MAPLE PLAINS
8305500.csv : OK
HARRINGTON CDA CS
830P001.csv : OK
```

Seven CSV files (`8300301.csv`, `8300418.nc`, `8300516.csv`, `8300562.nc`, `8300596.nc`, `8305500.nc` and `830P001.nc`) corresponding to the Prince Edward Island stations and a station information file (`info_stations.csv`) will be returned in the present working directory.