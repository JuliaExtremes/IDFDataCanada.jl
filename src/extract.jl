using IDF

# URL of the ECCC server where the data are :
url = "ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Engineering_Climate_Dataset/IDF/idf_v3-00_2019_02_27/IDF_Files_Fichiers/"

# Basename of the files (may change with data updates) :
file_basename = "IDF_v3.00_2019_02_27"

# Function to get user input :
function input(text)
      print("$text: ")
      readline()
end

# Output directory specification :
output_dir = input("Please enter the path to the output directory (where the files will be downloaded)")
while !isdir(output_dir)
      println("Error: This folder doesn't exist.")
      global output_dir = input("Please enter the path to the output directory (where the files will be downloaded)")
end

# Get the province :
province_list = ["AB", "BC", "MB", "NB", "NL", "NS", "NT", "NU", "ON", "PE", "QC", "SK", "YT"]
province = input("Please enter the code of the province (ex: QC for Quebec)")
while !(province in province_list) && isempty(province)
      println("Error: Invalid province code.")
      global province = input("Please enter the code of the province (ex: QC for Quebec)")
end

# Choice of format between CSV and netCDF :
format = input("Please enter the format of the data (CSV or netCDF)")
while !(format in ["CSV", "netCDF"])
      println("Error: Invalid format, please choose between CSV and netCDF")
      global format = input("Please enter the format of the data (CSV or netCDF)")
end

# Confirmation before the download :
println("The IDF data for $province will be downloaded to $output_dir in $format format.")
confirmation = input("Please type OK to continue")
if confirmation == "OK"
      data_download(province, output_dir, format, url=url, file_basename=file_basename)
else
      println("Download aborted!")
      return nothing
end
