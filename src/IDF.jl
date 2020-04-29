module IDF

using CSV, DataFrames, Dates, Glob, NCDatasets
#using ClimateTools

include("functions.jl")
#include("mapping.jl")

export get_idf, txt2csv, txt2netcdf, data_download, netcdf_generator
#export plotweatherstation, plotweatherstation_data
#export network_calculator
#export mapweathernetwork

end
