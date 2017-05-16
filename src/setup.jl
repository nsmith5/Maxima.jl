#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

ResetMaxima() = (kill(ms); LoadMaxima())
__init__() = (LoadMaxima(); atexit(() -> kill(ms)))

function LoadMaxima()
	# Server setup

    global ms = MaximaSession()	# Spin up a Maxima session

	# REPL setup
    repl_active = isdefined(Base, :active_repl)	# Is an active repl defined?
    interactive = isinteractive()				# In interactive mode?

    if repl_active && interactive
	    repl_init(Base.active_repl)
    end
end
