# 	This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

try
	if is_unix()
		@compat	readstring(`maxima --version`)
	else
		@compat readstring(`maxima.bat --version`)
	end
catch err
	error("Looks like Maxima is either not installed or not in the path")
end

# Server setup

const ms = MaximaSession()	# Spin up a Maxima session
atexit(() -> kill(ms))  	# Kill the session on exit

# REPL setup
repl_active = isdefined(Base, :active_repl)	# Is an active repl defined?
interactive = isinteractive()				# In interactive mode?

if repl_active && interactive
	repl_init(Base.active_repl)
end
