using ClimateTools, Glob
include("functions.jl")
ClimateTools.PyPlot.pygui(true)  # to allow plot displaying in the REPL

data_dir = "/Users/houton199/Documents/Stage_2019/data/QC"
files = glob("*.nc", data_dir)
vari = "max_rainfall_amount_5min"

C = loadstation(files, vari)

map_stations = plotstation(C, reg="quebec")
