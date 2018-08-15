# This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

__precompile__()
module Maxima

include("server.jl")
include("mexpr.jl")
include("io.jl")
include("repl.jl")
include("simplify.jl")
include("calculus.jl")
include("plot.jl")
include("setup.jl")
include("equations.jl")

end # module
