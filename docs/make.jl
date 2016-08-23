using Documenter, Maxima

makedocs(
    format = Documenter.Formats.HTML,
    sitename = "Maxima.jl",
    pages = Any[
        "Home" => "index.md", 
        "Manual" => Any[
            "Getting Started" => "man/getting_started.md"        
        ]
    ]
    )
