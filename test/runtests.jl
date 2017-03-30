# This file is part of Maxima.jl. It is licensed under the MIT license

using Maxima
using Base.Test

# Conversion and evaluation test
@test m"expand((1+x)^2)" == m"1 + 2*x + x^2"
@test mcall(:(exp(im*π))) == -1
@test integrate(:(sin(x)), :x) == :(-cos(x))
@test MExpr(:(100x)) == m"100 * x"

# Calculus tests
@test integrate(:(sin(x)), :x) == :(-cos(x))
@test integrate("exp(-x^2)", "x", "minf", "inf") == "sqrt(%pi)"
@test risch(:(1/x), :x) == :(log(x))
@test diff(:(log(x)), "x") == :(1/x)
@test diff(:(log(x)), :x, 2) == :(-1 / x ^ 2)

# Simplification tests
@test ratsimp(m"a + b/c") == m"(a * c + b) / c"
@test ratsimp(:(exp(log(x)))) == :x
@test radcan(m"sqrt(x/y)") == m"sqrt(x)/sqrt(y)"
@test factor(:(x^2 + 2x + 1)) == :((x + 1)^2)
@test gfactor(:(x^2 + 2*im*x - 1)) == :((x + im)^2)
@test expand(MExpr(:((a + b)^2))) == m"a^2 + 2*a*b + b^2"
@test logcontract(m"log(x) - log(y)") == m"log(x/y)"
@test logexpand(m"log(x/y)") == m"log(x) - log(y)"
@test trigsimp(m"sin(x)^2 + cos(x)^2") |> parse == 1

