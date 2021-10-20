module IDFDataCanada

using AxisArrays, CSV, DataFrames, Dates, NCDatasets, PyCall, InfoZIP

include("functions.jl")

export data_download, get_idf, netcdf_generator, txt2csv, txt2netcdf

end
