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
