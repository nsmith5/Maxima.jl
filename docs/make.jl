using Documenter, Maxima

makedocs(
    modules = [Maxima],
    clean = false,
    format = Documenter.Formats.HTML,
    sitename = "Maxima.jl",
    pages = Any[
        "Home" => "index.md", 
        "Manual" => "man/manual.md",
        "Library" => Any["lib/basics.md", "lib/simplify.md"]
    ]
)
