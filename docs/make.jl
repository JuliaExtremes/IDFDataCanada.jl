using Documenter, IDFDataCanada

makedocs(sitename="IDFDataCanada.jl",
    pages = [
       "index.md",
       "Tutorial" =>["Getting started" => "tutorial/index.md",
                     "Examples" => "tutorial/examples.md"],
       "functions.md"
       ]
    )