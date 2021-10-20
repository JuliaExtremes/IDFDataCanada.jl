"""
    data_download(output_dir::String, provinces::Array{String,1}; 
format::String="csv", split::Bool=false, rm_temp::Bool=true)

Download IDF data from ECCC's Google Drive (zip files) and generate CSV (or netCDF) files from it.

# Arguments

- `output_dir::String` : the output directory.

- `provinces::Array{String,1}` : the list of provinces codes.

- `format::String="csv"` : the format (.csv or .nc) of the output files. CSV is selected by default.

- `split::Bool=false`: split the output in separate directories for each provinces.

- `rm_temp::Bool=true` : delete the .zip files after the output generation.

"""
function data_download(output_dir::String, provinces::Array{String,1}; 
    format::String="csv", split::Bool=false, rm_temp::Bool=true)

    # Import gdown module to download big files from GoogleDrive
    gdown = pyimport("gdown")

    # Data version
    file_basename = "IDF_v-3.20_2021_03_26"

    # Provinces ID keys (for IDF_v-3.20_2021_03_26 only)
    prov_ID = Dict("YT" => "15eOgNs7O78esPguQxsmbhpMEgWfwTqzT",
                "SK" => "10c-LqmEkHtFeGiyArgHAqUa4clYjhtVu",
                "QC" => "1fdEEYCrj_t3Y3IXSXAALEUX-Urh2x5jG",
                "PE" => "1HueZnQA398ESGi-1op34maE7NZAi2grk",
                "ON" => "1V-8QENwq6yVSOfqErwn2Gm4NEyvmaoPx",
                "NU" => "1pkwSW3sqGwRPBVw7Lzb3xGg2IZPbCzAV",
                "NT" => "1iiOTzQe9f6sJnXaG-6xBrhGMMoPvL2Tw",
                "NS" => "1OCpnA28Kk6F6MABvWzV2jPuDH2eMaoSx",
                "NL" => "1VD_iqnFFO9SJ1mrll1Lj7yGuz-WURkfz",
                "NB" => "1qEyLZaSksJ6I784jllO2cVF8csCe64Jo",
                "MB" => "1XhloivDGWrl_x-yVxq6-qOFm7Lg9R3Rh",
                "BC" => "1eY7rtbxdyGHhySInf77lW6RcVVjEmimL",
                "AB" => "1Y0k_DpLggMp98BGu8v7pW-pI89FhadEv")
        
    info_df = DataFrame(A=String[],   # Name
                        B=String[],   # Province
                        C=String[],   # ID
                        D=String[],   # Lat
                        E=String[],   # Lon
                        F=String[],   # Elevation
                        G=String[],   # Number of years
                        H=String[],   # Filename
                        I=String[])   # Original filename

    if lowercase(format) == "csv"
        colnames = ["Name", "Province", "ID", "Lat", "Lon", "Elevation", 
        "Number of years", "CSV filename", "Original filename"]
    elseif lowercase(format) == "netcdf" || lowercase(format) == "nc"
        colnames = ["Name", "Province", "ID", "Lat", "Lon", "Elevation", 
        "Number of years", "NC filename", "Original filename"]
    else
        throw(error("Format is not valid")) 
    end
    rename!(info_df, Symbol.(colnames))

    for province in provinces
        # Make a temp directory for all data :
        try
            cd("$(output_dir)/temp_data")
        catch
            mkdir("$(output_dir)/temp_data")
            cd("$(output_dir)/temp_data")
        end

        file = "$(file_basename)_$(province).zip"
        ID = prov_ID[province]
        url = "https://drive.google.com/uc?id=$(ID)";


        # Download the data (if not downloaded already) and unzip the data :
        if file in readdir(pwd(), join=true)
            InfoZIP.unzip("$(file)")   # unzip the data
        else
            gdown.download(url, file)
            try
            InfoZIP.unzip("$(file)")   # unzip the data
            cd("$(output_dir)")
            catch
            throw(error("Unable to unzip the data file."))
            end
        end

        input_d = "$(output_dir)/temp_data/$(file_basename)_$(province)" # Where raw data are
        if split
            # Make the output directory if it doesn't exist :
            try
                mkdir("$(output_dir)/$(province)")
            catch
                nothing
            end
            output_d = "$(output_dir)/$(province)" # Where the netcdf/csv will be created
        else
            output_d = "$(output_dir)/"
        end

        # Convert the data in the specified format (CSV or NetCDF) :
        if lowercase(format) == "csv"
            info_df = vcat(info_df, txt2csv(input_d, output_d, province))
        elseif lowercase(format) == "netcdf" || lowercase(format) == "nc"
            info_df = vcat(info_df, txt2netcdf(input_d, output_d, province))
        else
            throw(error("Format is not valid"))
        end

        # Automatic deletion
        if rm_temp
            rm("$(output_dir)/temp_data", recursive=true)
        end
    end
    output_info = "$(output_dir)/info_stations.csv"
    CSV.write(output_info, info_df)
    return nothing
end

"""
    data_download(output_dir::String, province::String="all"; 
format::String="csv", split::Bool=false, rm_temp::Bool=true)    

Download IDF data from ECCC's Google Drive (zip files) and generate CSV (or netCDF) files from it.

# Arguments

- `output_dir::String` : the output directory.

- `province::String="all"` : the province code (ex: "QC" for Quebec). All provinces is selected by default.

- `format::String="csv"` : the format (.csv or .nc) of the output files. CSV is selected by default.

- `split::Bool=false`: split the output in separate directories for each provinces.

- `rm_temp::Bool=true` : delete the .zip files after the output generation.

"""
function data_download(output_dir::String, province::String="all"; 
    format::String="csv", split::Bool=false, rm_temp::Bool=true)

    prov_list = ["AB", "BC", "MB", "NB", "NL", "NS", "NT", "NU", "ON", "PE", "QC", "SK", "YT"]
    if province == "all"
        data_download(output_dir, prov_list, format=format, split=split, rm_temp=rm_temp)
    else
        data_download(output_dir, [province], format=format, split=split, rm_temp=rm_temp)
    end
end

"""
    get_idf(filename::String)

Read IDF text files and returns station infos (ID, latitude, longitude, 
altitude, and station name) and a DataFrame containing observed annual maximum in mm (Table 1) for different durations.

# Arguments

- `filename::String` : the name of the .txt file to read.

"""
function get_idf(filename::String)
    f = open(filename, "r")
    doc = readlines(f)

    # Station name and ID
    temp = doc[14]
    stationid = string(strip(temp[60:end]))   # Station ID
    stationname = string(strip(temp[1:50]))   # Station Name

    # Lat, lon and altitude
    temp = doc[16]
    stripchar = (s, r) -> replace(s, Regex("[$r]") => "")    # to remove ' from lat/lon
    latDMS1 = parse(Int, stripchar(temp[12:14], "'"))
    latDMS2 = (parse(Int, stripchar(temp[15:17], "'"))) / 60
    lat = round(parse(Float32, (string(latDMS1) * "." * string(latDMS2)[3:end])), digits=2)  # Lat (DMS)

    lonDMS1 = parse(Int, stripchar(temp[34:37], "'"))
    if lonDMS1 > 99  # character count change from 99 to 100 (+1)
        lonDMS2 = (parse(Int, stripchar(temp[38:40], "'"))) / 60
    else
        lonDMS2 = (parse(Int, stripchar(temp[37:39], "'"))) / 60
    end
    lon = round(parse(Float32, ("-" * string(lonDMS1) * "." * string(lonDMS2)[3:end])), digits=2)  # Lon (DMS)

    altitude = parse(Float32, temp[65:69])   # Altitude (m)

    # Nb of years
    indicateur = "---------------------------------------------------------------------"
    for i = 1:length(doc)
        if isequal(strip(doc[i]), indicateur)
            global nbyears = i - 30   # Nb of years
        end
    end

    # Data from Table 1 : Annual Maximum (mm)/Maximum annuel (mm)
    table1 = doc[30:30 + nbyears - 1]

    # Create an empty Dataframe to be filled with values from table 1
    data_df = DataFrame(A=String[],   # Year
    B=String[],   # 5min
    C=String[],   # 10min
    D=String[],   # 15min
    E=String[],   # 30min
    F=String[],   # 1h
    G=String[],   # 2h
    H=String[],   # 6h
    I=String[],   # 12h
    J=String[])   # 24h
    for j in 1:length(table1)
        data = split(table1[j])
        push!(data_df, data)
    end
    colnames = ["Année","5min","10min","15min","30min","1h","2h","6h","12h","24h"]
    rename!(data_df, Symbol.(colnames))

    # Function to replace -99.9 by missing
    val2missing(v, mv) = mv == v ? missing : v
    for a in 1:10
        data_df[!,a] = val2missing.(data_df[!,a], "-99.9")
    end

    close(f)
    println(stationname)

    # Return station info + table 1 data
    return stationid, lat, lon, altitude, data_df, stationname
end

"""
    txt2csv(input_dir::String, output_dir::String)

Generate CSV files of observed annual maximum for each station of a province
    and a DataFrame containing all station info (name, province, ID, lat, lon, elevation,
    number of years, data CSV filenames, original filenames).

# Arguments

- `input_dir::String` : the input directory.

- `output_dir::String` : the output directory.

- `province::String` : the province code (ex: "QC" for Quebec).

"""
function txt2csv(input_dir::String, output_dir::String, province::String)
    dir_content = readdir(input_dir, join=true)
    files = dir_content[contains.(dir_content, ".txt")]
    nbstations = size(files, 1)

    # Create an empty Dataframe to be filled with station info
    info_df = DataFrame(A=String[],   # Name
    B=String[],   # Province
    C=String[],   # ID
    D=String[],   # Lat
    E=String[],   # Lon
    F=String[],   # Elevation
    G=String[],   # Number of years
    H=String[],   # CSV filename
    I=String[])   # Original filename
    colnames = ["Name", "Province", "ID", "Lat", "Lon", "Elevation", 
    "Number of years", "CSV filename", "Original filename"]
    rename!(info_df, Symbol.(colnames))

    for i in 1:nbstations
        filename = files[i]
        stationid, lat, lon, altitude, data, stationname = get_idf(filename)
        output_f = "$(output_dir)/$(stationid).csv"
        CSV.write(output_f, data)   # Generate a CSV file from table 1 data for each station
        println("$(basename(output_f)) : OK")

        nbyears = size(data, 1)
        info = [stationname, province, stationid, string(lat), string(lon), 
        string(altitude), string(nbyears), string(stationid, ".csv"), basename(filename)]
        push!(info_df, info)    # Fill the province station info file
    end

    return info_df
end

"""
    txt2netcdf(input_dir::String, output_dir::String)

Generate netCDF files of observed annual maximum for each station of a province
    and a DataFrame containing all station info (name, province, ID, lat, lon, elevation,
    number of years, data netCDF filenames, original filenames).

# Arguments

- `input_dir::String` : the input directory.

- `output_dir::String` : the output directory.

- `province::String` : the province code (ex: "QC" for Quebec).

"""
function txt2netcdf(input_dir::String, output_dir::String, province::String)
    dir_content = readdir(input_dir, join=true)
    files = dir_content[contains.(dir_content, ".txt")]
    nbstations = size(files, 1)

    # Create an empty Dataframe to be filled with station info
    info_df = DataFrame(A=String[],   # Name
    B=String[],   # Province
    C=String[],   # ID
    D=String[],   # Lat
    E=String[],   # Lon
    F=String[],   # Elevation
    G=String[],   # Number of years
    H=String[],   # Filename
    I=String[])   # Original filename
    colnames = ["Name", "Province", "ID", "Lat", "Lon", "Elevation", 
    "Number of years", "NC filename", "Original filename"]
    rename!(info_df, Symbol.(colnames))

    for i in 1:nbstations
        # For each station, get the idf data and station info
        filename = files[i]
        stationid, lat, lon, altitude, data, stationname = get_idf(filename)

        # Fill the province station info file
        nbyears = size(data, 1)
        info = [stationname, province, stationid, string(lat), string(lon), 
        string(altitude), string(nbyears), string(stationid, ".nc"), basename(filename)]
        push!(info_df, info)  

        # Generate an empty NetCDF
        output_f = "$(output_dir)/$(stationid).nc"
        netcdf_generator(output_f)

        # Append data to the empty NetCDF
        ds = Dataset(output_f, "a")
        ds.attrib["original_source"] = basename(filename)

        # Station infos :
        ds["lat"][1] = lat
        ds["lon"][1] = lon
        ds["alt"][1] = altitude
        ds["station_ID"][1, 1:length(stationid)] = collect(stationid)
        ds["station_name"][1, 1:length(stationname)] = collect(stationname)

        # Number of observations :
        nb_obs = size(data, 1)
        ds["row_size"][1] = nb_obs

        # Time :
        data[!,1] = Dates.DateTime.(parse.(Int, data[!,1])) # Convert years to Date format
        units = "days since 2000-01-01 00:00:00"
        timedata = NCDatasets.CFTime.timeencode(data[!,1], "days since 1900-01-01 00:00:00", "standard")  # Encode Dates
        ds["time"][1:nb_obs] = timedata

        # Data from table 1 :
        ds["max_rainfall_amount_5min"][1:nb_obs] = parse.(Float32, coalesce.(data[!,2], "NaN"))
        ds["max_rainfall_amount_10min"][1:nb_obs] = parse.(Float32, coalesce.(data[!,3], "NaN"))
        ds["max_rainfall_amount_15min"][1:nb_obs] = parse.(Float32, coalesce.(data[!,4], "NaN"))
        ds["max_rainfall_amount_30min"][1:nb_obs] = parse.(Float32, coalesce.(data[!,5], "NaN"))
        ds["max_rainfall_amount_1h"][1:nb_obs] = parse.(Float32, coalesce.(data[!,6], "NaN"))
        ds["max_rainfall_amount_2h"][1:nb_obs] = parse.(Float32, coalesce.(data[!,7], "NaN"))
        ds["max_rainfall_amount_6h"][1:nb_obs] = parse.(Float32, coalesce.(data[!,8], "NaN"))
        ds["max_rainfall_amount_12h"][1:nb_obs] = parse.(Float32, coalesce.(data[!,9], "NaN"))
        ds["max_rainfall_amount_24h"][1:nb_obs] = parse.(Float32, coalesce.(data[!,10], "NaN"))

        close(ds)

    println("$(basename(output_f)) : OK")
    end
    return info_df
end

"""
    netcdf_generator(filename::String)

Generate empty netCDF files of the right format (used internally by txt2netcdf).

# Arguments

- `filename::String` : the name of the file to generate.

"""
function netcdf_generator(filename::String)
    # Creation of an empty NetCDF :
    ds = Dataset(filename, "c")

    # Content definition :
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