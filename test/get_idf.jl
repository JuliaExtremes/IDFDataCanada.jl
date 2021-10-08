@testset "get_idf" begin
    true_df = CSV.read("data/8300301.csv", DataFrame, type=String);

    stationid, lat, lon, altitude, data_df, stationname = get_idf("data/idf_v-3.20_2021_03_26_830_PE_8300301_CHARLOTTETOWN_A.txt");

    @test stationid == "8300301"
    @test lat == 46.28f0
    @test lon == -63.12f0
    @test altitude == 48.0f0

    @assert size(true_df) == size(data_df)

    for i=1:size(true_df,1)
        for j=1:size(true_df,2)
            @test isequal(true_df[i,j], data_df[i,j])
        end
    end

    @test stationname == "CHARLOTTETOWN A";
end


