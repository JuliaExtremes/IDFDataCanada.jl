using ClimateTools, Glob
#ClimateTools.PyPlot.pygui(true)

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
cm = "viridis_r"
cmap = ClimateTools.mpl.cm.get_cmap(cm)
status, fig, ax, m2 = mapclimgrid(region="quebec")
x, y = m2(lon, lat)
cs = m2.scatter(x, y, c=data, cmap=cmap)
cbar = ClimateTools.colorbar(cs, orientation = "vertical", shrink = 1, label=A[1].dataunits)
titlestr = "Mean $(title) QC"
ClimateTools.title(titlestr)
ClimateTools.PyPlot.savefig("/Users/houton199/Documents/Stage_2019/maps/mean_$(vari)_qc.png", dpi=300)

#-----------------------------------------------------------------------------------------
# Maximum
data = []
for i=1:length(A)
      mm = maximum(A[i])
      push!(data, mm)
end
cm = "viridis_r"
cmap = ClimateTools.mpl.cm.get_cmap(cm)
status, fig, ax, m3 = mapclimgrid(region="quebec")
x, y = m3(lon, lat)
cs = m3.scatter(x, y, c=data, cmap=cmap)
cbar = ClimateTools.colorbar(cs, orientation = "vertical", shrink = 1, label=A[1].dataunits)
titlestr = "Maximum $(title) QC"
ClimateTools.title(titlestr)
ClimateTools.PyPlot.savefig("/Users/houton199/Documents/Stage_2019/maps/max_$(vari)_qc.png", dpi=300)

#-----------------------------------------------------------------------------------------
# Minimum
data = []
for i=1:length(A)
      mm = minimum(A[i])
      push!(data, mm)
end
cm = "viridis_r"
cmap = ClimateTools.mpl.cm.get_cmap(cm)
status, fig, ax, m4 = mapclimgrid(region="quebec")
x, y = m4(lon, lat)
cs = m4.scatter(x, y, c=data, cmap=cmap)
cbar = ClimateTools.colorbar(cs, orientation = "vertical", shrink = 1, label=A[1].dataunits)
titlestr = "Minimum $(title) QC"
ClimateTools.title(titlestr)
ClimateTools.PyPlot.savefig("/Users/houton199/Documents/Stage_2019/maps/min_$(vari)_qc.png", dpi=300)

#-----------------------------------------------------------------------------------------
# Std dev
data = []
for i=1:length(A)
      mm = std(A[i])
      push!(data, mm)
end
cm = "viridis_r"
cmap = ClimateTools.mpl.cm.get_cmap(cm)
status, fig, ax, m5 = mapclimgrid(region="quebec")
x, y = m5(lon, lat)
cs = m5.scatter(x, y, c=data, cmap=cmap)
cbar = ClimateTools.colorbar(cs, orientation = "vertical", shrink = 1, label=A[1].dataunits)
titlestr = "Standard deviation $(title) QC"
ClimateTools.title(titlestr)
ClimateTools.PyPlot.savefig("/Users/houton199/Documents/Stage_2019/maps/std_$(vari)_qc.png", dpi=300)

#-----------------------------------------------------------------------------------------
# Variance
data = []
for i=1:length(A)
      mm = var(A[i])
      push!(data, mm)
end
cm = "viridis_r"
cmap = ClimateTools.mpl.cm.get_cmap(cm)
status, fig, ax, m6 = mapclimgrid(region="quebec")
x, y = m6(lon, lat)
cs = m6.scatter(x, y, c=data, cmap=cmap)
cbar = ClimateTools.colorbar(cs, orientation = "vertical", shrink = 1, label=A[1].dataunits)
titlestr = "Variance $(title) QC"
ClimateTools.title(titlestr)
ClimateTools.PyPlot.savefig("/Users/houton199/Documents/Stage_2019/maps/var_$(vari)_qc.png", dpi=300)

#-----------------------------------------------------------------------------------------
# Number of obs
data = []
for i=1:length(A)
      mm = length(A[i])
      push!(data, mm)
end
cm = "viridis_r"
cmap = ClimateTools.mpl.cm.get_cmap(cm)
status, fig, ax, m7 = mapclimgrid(region="quebec")
x, y = m7(lon, lat)
cs = m7.scatter(x, y, c=data, cmap=cmap)
cbar = ClimateTools.colorbar(cs, orientation = "vertical", shrink = 1, label="Number of observations [years]")
titlestr = "Number of observation per station\n $(title) QC"
ClimateTools.title(titlestr)
ClimateTools.PyPlot.savefig("/Users/houton199/Documents/Stage_2019/maps/nbobs_$(vari)_qc.png", dpi=300)
