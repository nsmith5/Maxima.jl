#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

Reset(;args::Cmd=``) = (kill(ms); Load(args=args))
__init__() = (Load(); atexit(() -> kill(ms)))

function Load(;args::Cmd=``)
    try
        Sys.isunix() ? read(`maxima --version`, String) : read(`maxima.bat --version`, String)
    catch err
        error("Looks like Maxima is either not installed or not in the path")
    end

    # Server setup
    global ms = MaximaSession(args=args)	# Spin up a Maxima session

    # REPL setup
    repl_active = isdefined(Base, :active_repl)	# Is an active repl defined?
    interactive = isinteractive()				# In interactive mode?

    if repl_active && interactive
        repl_init(Base.active_repl)
    end

    mcall("1") # clears out any initial data
    return nothing
end
