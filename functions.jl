using ClimateTools, DataFrames, Dates, Glob, NCDatasets, CSV

"""
    get_idf(fileName::String)

This function reads ECCC IDF text files and returns station infos (ID, latitude, longitude,
    altitude, and station name) and a DataFrame containing observed annual maximum in mm
    (Table 1) for different durations.
"""
function get_idf(fileName::String)
    f = open(fileName, "r")
    doc = readlines(f)

    # Station name and ID
    temp = doc[14]
    stationid = string(strip(temp[60:end]))   # Station ID
    stationname = string(strip(temp[1:50]))   # Station Name

    # Lat, lon and altitude
    temp = doc[16]
    stripchar = (s, r) -> replace(s, Regex("[$r]") => "")    # to remove ' from lat/lon
    latDMS1 = parse(Int, stripchar(temp[12:14],"'"))
    latDMS2 = (parse(Int, stripchar(temp[15:17],"'")))/60
    lat = round(parse(Float32, (string(latDMS1)*"."*string(latDMS2)[3:end])), digits=2)  # Lat (DMS)

    lonDMS1 = parse(Int, stripchar(temp[34:37],"'"))
    if lonDMS1 > 99  # character count change from 99 to 100 (+1)
        lonDMS2 = (parse(Int, stripchar(temp[38:40],"'")))/60
    else
        lonDMS2 = (parse(Int, stripchar(temp[37:39],"'")))/60
    end
    lon = round(parse(Float32, ("-"*string(lonDMS1)*"."*string(lonDMS2)[3:end])), digits=2)  # Lon (DMS)

    altitude = parse(Float32, temp[65:69])   # Altitude (m)

    # Nb of years
    indicateur = "---------------------------------------------------------------------"
    for i = 1:length(doc)
        if isequal(strip(doc[i]), indicateur)
            global nbyears = i-30
        end
    end

    # Data from Table 1 : Annual Maximum (mm)/Maximum annuel (mm)
    table1 = doc[30:30+nbyears-1]
    data_df = DataFrame(A = String[],
    B = String[],
    C = String[],
    D = String[],
    E = String[],
    F = String[],
    G = String[],
    H = String[],
    I = String[],
    J = String[])
    for j in 1:length(table1)
        data = split(table1[j])
        push!(data_df, data)
    end
    colnames = ["Year","5 min","10 min","15 min","30 min","1 h","2 h","6 h","12 h","24 h"]
    names!(data_df, Symbol.(colnames))

    # Function to replace -99.9 by missing
    val2missing(v,mv) = mv == v ? missing : v
    for a in 1:10
        data_df[a] = val2missing.(data_df[a],"-99.9")
    end

    close(f)
    println(stationname)

    return stationid, lat, lon, altitude, data_df, stationname
end


"""
    txt2csv(input_dir::String, output_dir::String)

This function returns CSV files of observed annual maximum for each station
    and one CSV file containing all station info (name, province, ID, lat, lon, elevation,
    number of years, data CSV filenames, original filenames) for a province.
"""
function txt2csv(input_dir::String, output_dir::String, province::String)
    files = glob("*.txt", input_dir)
    nbstations = size(files,1)

    # CSV info file
    info_df = DataFrame(A = String[],
    B = String[],
    C = String[],
    D = String[],
    E = String[],
    F = String[],
    G = String[],
    H = String[],
    I = String[])

    colnames = ["Name", "Province", "ID", "Lat", "Lon", "Elevation", "Number of years", "CSV filename", "Original filename"]
    names!(info_df, Symbol.(colnames))

    for i in 1:nbstations
        filename = files[i]
        stationid, lat, lon, altitude, data, stationname = get_idf(filename)
        output_f = "$(output_dir)/$(stationid).csv"
        CSV.write(output_f, data)
        println("$(basename(output_f)) : OK")

        nbyears = size(info_df, 1)
        info = [stationname, province, stationid, string(lat), string(lon), string(altitude), string(nbyears), string(stationid, ".csv"), basename(filename)]
        push!(info_df, info)
    end
    output_info = "$(output_dir)/info_stations_$(province).csv"
    CSV.write(output_info, info_df)
end

"""
    txt2netcdf(input_dir::String, output_dir::String)

This function returns netCDF files containing observed annual maximum data
    and station info for each station of a province.
"""
function txt2netcdf(input_dir::String, output_dir::String)
    files = glob("*.txt", input_dir)
    nbstations = size(files,1)

    for i in 1:nbstations
        fileName = files[i]
        stationid, lat, lon, altitude, data, stationname = get_idf(filename)

        output_f = "$(output_dir)/$(stationid).nc"
        netcdf_generator(output_f)

        ds = Dataset(output_f, "a")

        ds.attrib["original_source"] = basename(filename)

        ds["lat"][1] = lat
        ds["lon"][1] = lon
        ds["alt"][1] = altitude
        ds["station_ID"][1, 1:length(stationid)] = collect(stationid)
        ds["station_name"][1, 1:length(stationname)] = collect(stationname)

        nb_obs = size(data,1)
        ds["row_size"][1] = nb_obs

        data[1] = Dates.DateTime.(parse.(Int, data[1])) # Conversion des années en dates
        units = "days since 2000-01-01 00:00:00"
        timedata = NCDatasets.CFTime.timeencode(data[1],"days since 1900-01-01 00:00:00","standard")
        ds["time"][1:nb_obs] = timedata

        ds["max_rainfall_amount_5min"][1:nb_obs] = parse.(Float32, coalesce.(data[2], "NaN"))
        ds["max_rainfall_amount_10min"][1:nb_obs] = parse.(Float32, coalesce.(data[3], "NaN"))
        ds["max_rainfall_amount_15min"][1:nb_obs] = parse.(Float32, coalesce.(data[4], "NaN"))
        ds["max_rainfall_amount_30min"][1:nb_obs] = parse.(Float32, coalesce.(data[5], "NaN"))
        ds["max_rainfall_amount_1h"][1:nb_obs] = parse.(Float32, coalesce.(data[6], "NaN"))
        ds["max_rainfall_amount_2h"][1:nb_obs] = parse.(Float32, coalesce.(data[7], "NaN"))
        ds["max_rainfall_amount_6h"][1:nb_obs] = parse.(Float32, coalesce.(data[8], "NaN"))
        ds["max_rainfall_amount_12h"][1:nb_obs] = parse.(Float32, coalesce.(data[9], "NaN"))
        ds["max_rainfall_amount_24h"][1:nb_obs] = parse.(Float32, coalesce.(data[10], "NaN"))

        close(ds)

    println("$(basename(output_f)) : OK")
    end
end


"""
    data_download(province::String, output_dir::String, url::String, file_basename::String, format::String="CSV")

This function downloads IDF data from ECCC client_climate server for a province
    and generates CSV or netCDF files. CSV format is selected by default.
"""
function data_download(province::String, output_dir::String, url::String, file_basename::String, format::String="CSV")
    try
        mkdir("$(output_dir)/$(province)")
    catch
        nothing
    end

    # make a temp directory for all data
    try
        cd("$(output_dir)/temp_data")
    catch
        mkdir("$(output_dir)/temp_data")
        cd("$(output_dir)/temp_data")
    end

    file = "$(file_basename)_$(province).zip"
    full_url = "$(url)$(file)"

    try
        run(`unzip $(file)`)   # unzip the data
    catch
        run(`wget $(full_url)`)   # get the data from server
        run(`unzip $(file)`)   # unzip the data
    end

    input_d = "$(output_dir)/temp_data/$(file_basename)_$(province)"
    output_d = "$(output_dir)/$(province)"

    if format == "CSV"
        txt2csv(input_d, output_d, province)
    elseif format == "NetCDF"
        txt2netcdf(input_d, output_d)
    else
        throw(error("Format is not valid"))
    end

    # Automatic deletion (still doesn't work -> msg error : "rmdir: illegal option -- r")
    #run(`rmdir -r $(input_d)`)  # delete the original data directory
    #run(`rm $(file)`)   # delete the zip file

    return nothing
end

"""
    data_download(province::Array{String}, output_dir::String, url::String, file_basename::String)

This function downloads IDF data from ECCC client_climate server for multiple provinces
    and generates CSV or netCDF files. CSV format is selected by default.
"""
function data_download(province::Array{String}, output_dir::String, url::String, file_basename::String, format::String="CSV")
    for i in 1:length(province)
        data_dowload(province[i], output_dir, url, file_basename, format)
    end
end

"""
    netcdf_generator(fileName::String)

This functions generates empty netCDF files (used by txt2csv).
"""
function netcdf_generator(fileName::String)
    ds = Dataset(fileName,"c")

    # Dimensions
    defDim(ds, "station", Inf)
    defDim(ds, "obs", Inf)
    defDim(ds, "name_strlen", Inf)
    defDim(ds, "id_strlen", Inf)

    # Global attributes
    ds.attrib["featureType"] = "timeSeries"
    ds.attrib["title"] = "Short Duration Rainfall Intensity-Duration-Frequency Data (ECCC)"
    ds.attrib["Conventions"] = "CF-1.7"
    ds.attrib["comment"] = "see H.2.4. Contiguous ragged array representation of time series"

    # Variables
    v1 = defVar(ds, "lon", Float32, ("station",))
    v1.attrib["standard_name"] = "longitude"
    v1.attrib["long_name"] = "station longitude"
    v1.attrib["units"] = "degrees_east"

    v2 = defVar(ds, "lat", Float32, ("station",))
    v2.attrib["standard_name"] = "latitude"
    v2.attrib["long_name"] = "station latitude"
    v2.attrib["units"] = "degrees_north"

    v3 = defVar(ds, "alt", Float32, ("station",))
    v3.attrib["long_name"] = "vertical distance above the surface"
    v3.attrib["standard_name"] = "height"
    v3.attrib["units"] = "m"
    v3.attrib["positive"] = "up"
    v3.attrib["axis"] = "Z"

    v4 = defVar(ds, "station_name", Char, ("station", "name_strlen"))
    v4.attrib["long_name"] = "station name"

    v5 = defVar(ds, "station_ID", Char, ("station", "id_strlen"))
    v5.attrib["long_name"] = "station id"
    v5.attrib["cf_role"] = "timeseries_id"

    v6 = defVar(ds, "row_size", Int32, ("station",))
    v6.attrib["long_name"] = "number of observations for this station"
    v6.attrib["sample_dimension"] = "obs"

    v7 = defVar(ds, "time", Float64, ("obs",))
    v7.attrib["standard_name"] = "time"
    v7.attrib["units"] = "days since 1900-01-01"

    v8 = defVar(ds, "max_rainfall_amount_5min", Float32, ("obs",))
    v8.attrib["long_name"] = "Annual maximum rainfall amount 5-minutes"
    v8.attrib["coordinates"] = "time lat lon alt station_ID"
    v8.attrib["cell_methods"] = "time: sum over 5 min time: maximum within years"
    v8.attrib["units"] = "mm"

    v9 = defVar(ds, "max_rainfall_amount_10min", Float32, ("obs",))
    v9.attrib["long_name"] = "Annual maximum rainfall amount 10-minutes"
    v9.attrib["coordinates"] = "time lat lon alt station_ID"
    v9.attrib["cell_methods"] = "time: sum over 10 min time: maximum within years"
    v9.attrib["units"] = "mm"

    v10 = defVar(ds, "max_rainfall_amount_15min", Float32, ("obs",))
    v10.attrib["long_name"] = "Annual maximum rainfall amount 15-minutes"
    v10.attrib["coordinates"] = "time lat lon alt station_ID"
    v10.attrib["cell_methods"] = "time: sum over 15 min time: maximum within years"
    v10.attrib["units"] = "mm"

    v11 = defVar(ds, "max_rainfall_amount_30min", Float32, ("obs",))
    v11.attrib["long_name"] = "Annual maximum rainfall amount 30-minutes"
    v11.attrib["coordinates"] = "time lat lon alt station_ID"
    v11.attrib["cell_methods"] = "time: sum over 30 min time: maximum within years"
    v11.attrib["units"] = "mm"

    v12 = defVar(ds, "max_rainfall_amount_1h", Float32, ("obs",))
    v12.attrib["long_name"] = "Annual maximum rainfall amount 1-hour"
    v12.attrib["coordinates"] = "time lat lon alt station_ID"
    v12.attrib["cell_methods"] = "time: sum over 1 hour time: maximum within years"
    v12.attrib["units"] = "mm"

    v13 = defVar(ds, "max_rainfall_amount_2h", Float32, ("obs",))
    v13.attrib["long_name"] = "Annual maximum rainfall amount 2-hours"
    v13.attrib["coordinates"] = "time lat lon alt station_ID"
    v13.attrib["cell_methods"] = "time: sum over 2 hour time: maximum within years"
    v13.attrib["units"] = "mm"

    v14 = defVar(ds, "max_rainfall_amount_6h", Float32, ("obs",))
    v14.attrib["long_name"] = "Annual maximum rainfall amount 6-hours"
    v14.attrib["coordinates"] = "time lat lon alt station_ID"
    v14.attrib["cell_methods"] = "time: sum over 6 hours time: maximum within years"
    v14.attrib["units"] = "mm"

    v15 = defVar(ds, "max_rainfall_amount_12h", Float32, ("obs",))
    v15.attrib["long_name"] = "Annual maximum rainfall amount 12-hours"
    v15.attrib["coordinates"] = "time lat lon alt station_ID"
    v15.attrib["cell_methods"] = "time: sum over 12 hours time: maximum within years"
    v15.attrib["units"] = "mm"

    v16 = defVar(ds, "max_rainfall_amount_24h", Float32, ("obs",))
    v16.attrib["long_name"] = "Annual maximum rainfall amount 24-hours"
    v16.attrib["coordinates"] = "time lat lon alt station_ID"
    v16.attrib["cell_methods"] = "time: sum over 24 hours time: maximum within years"
    v16.attrib["units"] = "mm"

    close(ds)
end

"""
    plotstation(C::WeatherStation; reg="canada", msize=2, titlestr::String="", filename::String="")

This function plots a weather station on a map.
"""
function plotstation(C::WeatherStation; reg="canada", msize=2, titlestr::String="", filename::String="")
    # Empty-map generator
    status, fig, ax, m = mapclimgrid(region=reg)

    # Plot station
    x, y = m(C.lon, C.lat)
    m.plot(x, y, "r+", markersize=msize)

    # Title
    ClimateTools.title(titlestr)

    # Save to "filename" if not empty
    if !isempty(filename)
        PyPlot.savefig(filename, dpi=300)
    end
end

"""
    function plotstation(C::WeatherNetwork{<:Any}; reg="canada", msize=2, titlestr::String="", filename::String="")

This function plots multiple weather station on a map.
"""
function plotstation(C::WeatherNetwork{<:Any}; reg="canada", msize=2, titlestr::String="", filename::String="")
    # Empty-map generator
    status, fig, ax, m = mapclimgrid(region=reg)

    # Plot each station
    for i=1:length(C)
        x, y = m(C[i].lon, C[i].lat)
        m.plot(x, y, "r+", markersize=msize)
    end

    # Title
    ClimateTools.title(titlestr)

    # Save to "filename" if not empty
    if !isempty(filename)
        PyPlot.savefig(filename, dpi=300)
    end
end
