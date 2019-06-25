using DataFrames, Dates, Glob, NCDatasets, CSV

"""
   get_idf(fileName::String)
   
"""
function get_idf(fileName::String)
   f = open(fileName, "r")
   doc = readlines(f)

   # Station name and ID
   temp = doc[14]
   StationID = string(strip(temp[60:end]))   # Station ID
   StationName = string(strip(temp[1:50]))   # Station Name

   # Lat, lon and altitude
   temp = doc[16]
   stripChar = (s, r) -> replace(s, Regex("[$r]") => "")    # to remove ' from lat/lon
   LatDMS1 = parse(Int, stripChar(temp[12:14],"'"))
   LatDMS2 = (parse(Int, stripChar(temp[15:17],"'")))/60
   lat = parse(Float32, (string(LatDMS1)*"."*string(LatDMS2)[3:end]))  # Lat (DMS)

   LonDMS1 = parse(Int, stripChar(temp[34:37],"'"))
   if LonDMS1 > 99  # character count change from 99 to 100 (+1)
      LonDMS2 = (parse(Int, stripChar(temp[38:40],"'")))/60
   else
      LonDMS2 = (parse(Int, stripChar(temp[37:39],"'")))/60
   end
   lon = parse(Float32, (string(LonDMS1)*"."*string(LonDMS2)[3:end]))  # Lon (DMS)

   altitude = parse(Float32, temp[65:69])   # Altitude (m)

   # Nb of years
   indicateur1 = "---------------------------------------------------------------------"
   for i = 1:length(doc)
      if isequal(strip(doc[i]), indicateur1)
         global nbYears = i-30
      end
   end

   # Data from Table 1
   table1 = doc[30:30+nbYears-1]
   df = DataFrame(A = String[],
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
      push!(df, data)
   end
   colnames = ["Year","5 min","10 min","15 min","30 min","1 h","2 h","6 h","12 h","24 h"]
   names!(df, Symbol.(colnames))

   # Function to replace -99.9 by missing
   val2missing(v,mv) = mv == v ? missing : v
   for a in 1:10
      df[a] = val2missing.(df[a],"-99.9")
   end

   close(f)
   println(StationName)

   return StationID, lat, lon, altitude, df, StationName
end


"""
   txt2csv(input_dir::String, output_dir::String)

"""
function txt2csv(input_dir::String, output_dir::String)
   files = glob("*.txt", input_dir)
   nbStations = size(files,1)

   for i in 1:nbStations
      fileName = files[i]
      StationID, lat, lon, altitude, data, StationName = get_idf(fileName)
      output = "$(output_dir)/$(StationID).csv"
      CSV.write(output, data)
      println("$(basename(output)) : OK")
   end
end


"""
   data_download(province::Array{String}, output_dir::String, url::String, file_basename::String)

"""
function data_download(province::Array{String}, output_dir::String, url::String, file_basename::String)
    # make a separate directory for each province
    for i in 1:length(province)
        try
            mkdir("$(output_dir)/$(province[i])")
        catch
            #do nothing
        end
    end

    # make a temp directory for all data
    try
        cd("$(output_dir)/temp_data")
    catch
        mkdir("$(output_dir)/temp_data")
        cd("$(output_dir)/temp_data")
    end

    for i in 1:length(province)
        file = "$(file_basename)_$(province[i]).zip"
        full_url = "$(url)$(file)"

        run(`wget $(full_url)`)   # get the data from server
        run(`unzip $(file)`)   # unzip the data

        input_d = "$(output_dir)/temp_data/$(file_basename)_$(province[i])"
        output_d = "$(output_dir)/$(province[i])"

        txt2csv(input_d, output_d)

        # Automatic deletion (still doesn't work -> msg error : "rmdir: illegal option -- r")
        #run(`rmdir -r $(input_d)`)  # delete the original data directory
        #run(`rm $(file)`)   # delete the zip file
    end
    return nothing
end
