module IDFDataCanada

using AxisArrays, CSV, DataFrames, Dates, Downloads, Glob, NCDatasets

include("functions.jl")

export get_idf, txt2csv, txt2netcdf, data_download, netcdf_generator

end
