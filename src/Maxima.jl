module Maxima

using Compat
import Compat.String

include("server.jl")
include("mexpr.jl")
include("io.jl")
include("simplify.jl")
include("calculus.jl")

end # module
