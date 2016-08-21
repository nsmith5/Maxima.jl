module Maxima

using Compat
import Compat.String

include("server.jl")
include("mexpr.jl")
include("io.jl")
include("repl.jl")
include("simplify.jl")
include("calculus.jl")
include("plot.jl")
include("setup.jl")

end # module
