# 	This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

try
	@compat	readstring(`maxima --version`)
catch err
	error("Looks like Maxima is either not installed or not in the path")
end

# Server setup

const default_port = 8080			# choose default port	
@spawn startserver(default_port)	# spawn client-server pair
atexit(killserver)					# register `killserver` to run on exit

# REPL setup

repl_active = isdefined(Base, :active_repl)	# Is an active repl defined?
interactive = isinteractive()				# In interactive mode?

if repl_active && interactive
	repl_init(Base.active_repl)
end
