using IDFDataCanada
using Random, Test, CSV, DataFrames

# Set the seed for reproductible test results
Random.seed!(12)

@testset "IDFDataCanada.jl" begin
    include("get_idf.jl")
end;