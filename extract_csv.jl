include("functions.jl")

output_dir = "" # directory where the files will be downloaded, ex:"/Users/houton199/Documents/Stage_2019/data"
province = ["AB", "BC", "MB", "NB", "NL", "NS", "NT", "NU", "ON", "PE", "QC", "SK", "YT"]

url = "ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Engineering_Climate_Dataset/IDF/idf_v3-00_2019_02_27/IDF_Files_Fichiers/"
file_basename = "IDF_v3.00_2019_02_27"

data_download(province, output_dir, url, file_basename)
