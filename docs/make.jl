using Documenter, Maxima

makedocs(
    modules = [Maxima],
    clean = false,
    format = Documenter.Formats.HTML,
    sitename = "Maxima.jl",
    pages = Any[
        "Home" => "index.md", 
        "Manual" => Any["Getting Started" => "man/getting_started.md"],
        "Library" => Any["lib/basics.md", "lib/simplify.md"]
    ]
)
