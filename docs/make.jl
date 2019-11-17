using Documenter, Maxima

makedocs(
    modules = [Maxima],
    clean = false,
    format = Documenter.HTML(),
    sitename = "Maxima.jl",
    pages = Any[
        "Home" => "index.md",
        "Manual" => "man/manual.md",
        "Library" => Any[
            "lib/basics.md",
            "lib/simplify.md",
            "lib/calculus.md",
            "lib/plot.md"]
    ]
)

deploydocs(
    repo = "github.com/nsmith5/Maxima.jl.git",
)
