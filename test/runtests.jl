# This file is part of Maxima.jl. It is licensed under the MIT license

using Maxima
using Test

# Basic server and setup test

# Conversion and evaluation test
@test m"expand((1+x)^2)" == m"1 + 2*x + x^2"
@test mcall(:(exp(im*pi))) == -1
@test integrate(:(sin(x)), :x) == :(-cos(x))
@test MExpr(:(100x)) == m"100 * x"
@test MExpr(:(-im)) == m"-%i"

# Calculus tests
@test integrate(:(sin(x)), :x) == :(-cos(x))
@test integrate("exp(-x^2)", "x", "minf", "inf") == "sqrt(%pi)"
@test risch(:(1/x), :x) == :(log(x))
@test diff(:(log(x)), "x") == :(1/x)
@test diff(:(log(x)), :x, 2) == :(-1 / x ^ 2)
@test limit(m"sin(x)/x", :x, 0) == m"1"
@test limit(:(1/x), :x, :a) == :(1 / a)
@test limit(:(1/x), :x, :a, :plus) == :(1/a)

try
    limit(:(1/x), :x, :a, "lalala")
catch err
    @test typeof(err) == ErrorException
end

@test sum(:(1 / k^2), :k, 1, Inf) == :(π ^ 2 / 6)
@test sum(m"1 / k ^ 2", :k, 1, "inf") == m"%pi^2/6"
@test taylor(m"sin(x)", :x, 0, 3) == m"x - x^3/6"
@test taylor(:(sin(x)), :x, 0, 3) == :(x - x^3/6)



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
@test trigrat(MExpr(:(exp(im*x) + exp(-im*x)))) == MExpr(:(2 * cos(x)))
@test rectform(:(R*e^(im*theta))) == :(im * R * sin(theta) + R * cos(theta))
@test polarform(m"a + %i*b") == m"sqrt(a^2 + b^2)*exp(%i * atan2(b, a))"
@test realpart(m"a + %i*b") |> parse == :a
@test imagpart(m"a + %i*b") |> parse == :b
@test demoivre(m"exp(a + %i * b)") == m"exp(a) * (cos(b) + %i * sin(b))"
@test exponentialize(m"sin(x)") == m"-%i*(exp(%i * x) - exp(-%i * x))/2"
@test float(m"1/3*x") == m"0.3333333333333333*x"
@test subst(:b, :a, :(a^2 + b^2)) == :(2 * b ^ 2)
@test trigexpand(:(sin(2x) + cos(3y))) == :(-3 * cos(y) * sin(y) ^ 2 + cos(y) ^ 3 + 2 * cos(x) * sin(x))
@test trigreduce(m"-sin(x)^2+3*cos(x)^2+x") == m"cos(2*x)/2+3*(cos(2*x)/2+1/2)+x-1/2"
@test expand(:((a + b)^2)) == :(b ^ 2 + 2 * a * b + a ^ 2)
@test expand("(a + b)^3") == "b^3+3*a*b^2+3*a^2*b+a^3"
@test makefact(m"gamma(x)") == m"(x-1)!"
@test makegamma(m"n! * m!") == m"gamma(m+1)*gamma(n+1)"

# Error handling

try
    mcall(m"1/0")
catch err
    @test typeof(err) == Maxima.MaximaError
end

try
    mcall(m"1 + ")
catch err
    @test typeof(err) == Maxima.MaximaSyntaxError
end
