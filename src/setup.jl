#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

Reset() = (kill(ms); Load())
__init__() = (Load(); atexit(() -> kill(ms)))

function Load()
    try
        is_unix() ? (@compat readstring(`maxima --version`)) :
            @compat readstring(`maxima.bat --version`)
    catch err
        error("Looks like Maxima is either not installed or not in the path")
    end

    # Server setup

    global ms = MaximaSession()	# Spin up a Maxima session

    # REPL setup
    repl_active = isdefined(Base, :active_repl)	# Is an active repl defined?
    interactive = isinteractive()				# In interactive mode?

    if repl_active && interactive
        repl_init(Base.active_repl)
    else # package is loaded from ~/.juliarc.jl
      atreplinit() do repl # check if OhMyREPL is loaded
        !isdefined(Main,:OhMyREPL) && (repl.interface = Base.REPL.setup_interface(repl))
        repl_init(Base.active_repl)
      end
    end

    mcall("1") # clears out any initial data
end
