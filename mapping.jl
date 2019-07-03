using ClimateTools, Glob
#ClimateTools.PyPlot.pygui(true)

function plotstation_data(W::WeatherNetwork{<:Any}, data; reg="canada", N=12, titlestr::String="", filename::String="")
      vmin, vmax = ClimateTools.getcslimits([], data, false)
      vmin2 = round(Int, vmin[1]/10)*10
      vmax2 = round(Int, vmax[1]/10)*10
      range_data = vmax2-vmin2
      while (range_data/N)%1 != 0 || (range_data/N)%.5 != 0
            N += 1
      end
      steps=range_data/N

      cm = "viridis_r"
      cmap = ClimateTools.mpl.cm.get_cmap(cm, N)
      status, fig, ax, m2 = mapclimgrid(region=reg)

      lon, lat = ClimateTools.getnetworkcoords(W)
      x, y = m2(lon, lat)
      bounds = collect(vmin2:steps:vmax2)
      norm = ClimateTools.mpl.colors.BoundaryNorm(bounds, cmap.N)
      cs = m2.scatter(x, y, c=data, cmap=cmap, vmin=vmin2, vmax=vmax2)
      cbar = ClimateTools.colorbar(cs, orientation = "vertical", shrink = 1, label=W[1].dataunits, norm=norm, ticks=bounds)

      ClimateTools.title(titlestr)
      ClimateTools.PyPlot.savefig(filename, dpi=300)
      return true, fig, ax, cbar
end

data_dir = "/Users/houton199/Documents/Stage_2019/data/QC"
files = glob("*.nc", data_dir)

vari = "max_rainfall_amount_24h"
stripchar = (s, r) -> replace(s, Regex("[$r]") => " ")
title = "$(stripchar(vari, "_"))"

A = loadstation(files, vari)
lon, lat = ClimateTools.getnetworkcoords(A)

#-----------------------------------------------------------------------------------------
# Map of QC stations
status, fig, ax, m1 = mapclimgrid(region="quebec")
x, y = m1(lon, lat)
cs = m1.scatter(x, y)
ClimateTools.title("QC Weather stations")
ClimateTools.PyPlot.savefig("/Users/houton199/Documents/Stage_2019/maps/stations_qc.png", dpi=300)

#-----------------------------------------------------------------------------------------
# Mean
data = []
for i=1:length(A)
      mm = mean(A[i])
      push!(data, mm)
end
titlestr = "Mean $(title) QC"
filename = "/Users/houton199/Documents/Stage_2019/maps/mean_$(vari)_qc.png"
plotstation_data(A, data, titlestr=titlestr, filename=filename, N=8, reg="quebec")

#-----------------------------------------------------------------------------------------
# Maximum
data = []
for i=1:length(A)
      mm = maximum(A[i])
      push!(data, mm)
end
titlestr = "Maximum $(title) QC"
filename = "/Users/houton199/Documents/Stage_2019/maps/max_$(vari)_qc.png"
plotstation_data(A, data, titlestr=titlestr, filename=filename, N=8, reg="quebec")

#-----------------------------------------------------------------------------------------
# Minimum
data = []
for i=1:length(A)
      mm = minimum(A[i])
      push!(data, mm)
end
titlestr = "Minimum $(title) QC"
filename = "/Users/houton199/Documents/Stage_2019/maps/min_$(vari)_qc.png"
plotstation_data(A, data, titlestr=titlestr, filename=filename, N=8, reg="quebec")

#-----------------------------------------------------------------------------------------
# Std dev
data = []
for i=1:length(A)
      mm = std(A[i])
      push!(data, mm)
end
titlestr = "Standard deviation $(title) QC"
filename = "/Users/houton199/Documents/Stage_2019/maps/std_$(vari)_qc.png"
plotstation_data(A, data, titlestr=titlestr, filename=filename, N=8, reg="quebec")

#-----------------------------------------------------------------------------------------
# Variance
data = []
for i=1:length(A)
      mm = var(A[i])
      push!(data, mm)
end
titlestr = "Variance $(title) QC"
filename = "/Users/houton199/Documents/Stage_2019/maps/var_$(vari)_qc.png"
plotstation_data(A, data, titlestr=titlestr, filename=filename, N=8, reg="quebec")

#-----------------------------------------------------------------------------------------
# Number of obs
data = []
for i=1:length(A)
      mm = length(A[i])
      push!(data, mm)
end
titlestr = "Number of observation per station\n $(title) QC"
filename = "/Users/houton199/Documents/Stage_2019/maps/nbobs_$(vari)_qc.png"
plotstation_data(A, data, titlestr=titlestr, filename=filename, N=8, reg="quebec")
