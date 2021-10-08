@testset "get_idf" begin
    true_df = CSV.read("data/8300301.csv", DataFrame, type=String)

    stationid, lat, lon, altitude, data_df, stationname = get_idf("data/idf_v-3.20_2021_03_26_830_PE_8300301_CHARLOTTETOWN_A.txt");

    @assert stationid == "8300301"
    @assert lat == 46.28f0
    @assert lon == -63.12f0
    @assert altitude == 48.0f0

    @assert size(true_df) == size(data_df)

    for i=1:size(true_df,1)
        for j=1:size(true_df,2)
            @assert isequal(true_df[i,j], data_df[i,j])
        end
    end

    @assert stationname == "CHARLOTTETOWN A"
end


