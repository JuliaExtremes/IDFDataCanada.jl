using Documenter, IDFDataCanada

makedocs(modules = [IDFDataCanada],
        doctest = false,
        sitename="IDFDataCanada.jl",
        pages = [
        "index.md",
        "starting.md",
        "functions.md"
        ]
)

deploydocs(
        repo = "github.com/houton199/IDFDataCanada.jl.git",
        devbranch = "dev"
)
