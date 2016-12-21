# This file is part of Maxima.jl. It is licensed under the MIT license

using Maxima
using Base.Test

# Conversion and evaluation test
@test m"expand((1+x)^2)" == m"1 + 2*x + x^2"
@test mcall(:(exp(im*π))) == -1
@test integrate(:(sin(x)), :x) == :(-cos(x))

# Calculus tests
@test integrate(:(sin(x)), :x) == :(-cos(x))
@test integrate("exp(-x^2)", "x", "minf", "inf") == "sqrt(%pi)"
@test risch(:(1/x), :x) == :(log(x))
@test diff(:(log(x)), "x") == :(1/x)
@test diff(:(log(x)), :x, 2) == :(-1 / x ^ 2)
