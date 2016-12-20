using Documenter, Maxima

makedocs(
    modules = [Maxima],
    clean = false,
    format = :html,
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
    deps = nothing,
	repo = "github.com/nsmith5/Maxima.jl.git",
    julia = "0.5",
    osname = "osx",
    make = nothing,
	target = "build"
)
