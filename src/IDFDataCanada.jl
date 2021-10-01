module IDFDataCanada

using AxisArrays, CSV, DataFrames, Dates, Glob, NCDatasets, PyCall

include("functions.jl")

export get_idf, txt2csv, txt2netcdf, data_download, netcdf_generator

end
