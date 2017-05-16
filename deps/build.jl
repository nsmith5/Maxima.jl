# Build Script for Maxima.jl
using Compat


let maximacmd = is_unix() ? `maxima --version` : `maxima.bat --version`
    try
        run(maximacmd)
        info("Maxima already installed")
        exit(0)
    catch err
        info("Maxima not installed or in path, attempting fresh installation..")
    end
end


if is_apple()
    import Homebrew
    info("Installing from Maxima from 'homebrew/science'")
    Homebrew.add("homebrew/science/maxima")
    info("Build successful")
    exit(0)
else
    warn(
    """Maxima.jl does not yet support builds on your OS. 
    Install or build and add to your path to start using 
    Maxima.jl"""
    )
end
