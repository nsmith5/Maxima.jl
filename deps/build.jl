# Build Script for Maxima.jl
using Compat


function writecmd(cmd)
    open("maximacmd.jl", "w+") do file
        write(file, "const maximacmd = $cmd")
    end
end


let maximacmd = is_unix() ? `maxima` : `maxima.bat`
    try
        info(@compat readstring(`$maximacmd --version`))
        info("Maxima already installed")
        writecmd(maximacmd)
        exit(0)
    catch err
        info("Maxima not installed or in path, attempting fresh installation..")
    end
end


if is_apple()
    import Homebrew
    info("Installing from Maxima from 'homebrew/science'")
    Homebrew.update()
    Homebrew.add("homebrew/science/maxima")
    info("Build successful")
    writecmd(`$(Homebrew.prefix())/bin/maxima`)
    exit(0)
else
    error(
    """Maxima.jl does not yet support builds on your OS. 
    Install or build and add to your path to start using 
    Maxima.jl"""
    )
end
