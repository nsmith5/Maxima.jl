# This file is part of Maxima.jl. It is licensed under the MIT license

export sum,
       integrate,
       risch,
       diff,
       limit,
       taylor,
       product,
       changevar,
       lbfgs,
       minimum,
       laplace,
       ilt

import Base: sum,
             minimum

function integrate(m::MExpr, s)
    MExpr("integrate($m, $s)") |> mcall
end

"""
    integrate{T}(f::T, x)

Evaluate the indefinite integral
```math
\\int f(x) dx
```
# Examples

```julia
julia> integrate(:(sin(x)), :x)
:(-cos(x))
```
"""
function integrate{T}(expr::T, s)
    m = MExpr(expr)
    out = integrate(m, s)
    convert(T, out)
end

function integrate(m::MExpr, s, lower, upper)
    MExpr("integrate($m, $s, $lower, $upper)") |> mcall
end

function integrate{T}(expr::T, s, lower, upper)
    m = MExpr(expr)
    out = integrate(m, s, lower, upper)
    convert(T, out)
end

function risch(m::MExpr, var)
    MExpr("risch($m, $var)") |> mcall
end

function risch{T}(exp::T, var)
    m = MExpr(exp)
    convert(T, risch(m, var))
end

function diff(m::MExpr, s)
    MExpr("diff($m, $s)") |> mcall
end

function diff{T}(exp::T, s)
    m = MExpr(exp)
    out = diff(m, s)
    convert(T, out)
end

function diff(m::MExpr, s, order::Integer)
    if order < 0
        error("Order of derivative must be positive integer")
    end
    MExpr("diff($m, $s, $order)") |> mcall
end

function diff{T}(exp::T, s, order::Integer)
    m = MExpr(exp)
    out = diff(m, s, order)
    convert(T, out)
end

function limit(m::MExpr, x, a)
    MExpr("limit($m, $x, $a)") |> mcall
end

function limit{T}(exp::T, x, a)
    m = MExpr(exp)
    out = limit(m, x, a)
    convert(T)
end

function limit(m::MExpr, x, a, side)
    if "$side" != "plus" || "minus"
        error("Side of limit must be \"plus\" or \"minus\"")
    end
    MExpr("limit($m, $x, $a, $side") |> mcall
end

function limit{T}(exp::T, x, a, side)
    m = MExpr(exp)
    out = limit(m, x, a, side)
    convert(T, out)
end

function sum(m::MExpr, k, start, finish)
    MExpr("sum($m, $k, $start, $finish), simpsum") |> mcall
end

function sum{T}(exp::T, k, start, finish)
    sumexp = parse("sum($exp, $k, $start, $finish)")
    m = MExpr(sumexp)
    out = mcall(MExpr("$m, simpsum"))
    convert(T, out)
end

function taylor(m::MExpr, x, x0, order::Integer)
    if order < 0
        error("Order of taylor expansion must be ≥ 0")
    end
    MExpr("taylor($m, $x, $x0, $order)") |> mcall
end

function taylor{T}(exp::T, x, x0, order::Integer)
    m = MExpr(exp)
    out = taylor(m, x, x0, order)
    convert(T, out)
end

function product(m::MExpr, k, start, finish)
    MExpr("product($m, $k, $start, $finish), simpsum") |> mcall
end

function product{T}(exp::T, k, start, finish)
    sumexp = parse("product($exp, $k, $start, $finish)")
    convert(T, sumexp |> MExpr |> mcall)a
end

function changevar(integral::MExpr, transform::MExpr, new, old)
    "changevar($integral, $transform, new, old)" |> MExpr |> mcall
end

function lbfgs(func::MExpr, var, guess; xtol = 1e-8)
    temp = "lbfgs($func, [$var], [$guess], $xtol)" |> MExpr |> mcall
    "rhs($temp[1])" |> MExpr |> mcall
end

function minimum(func::MExpr, var, guess; xtol = 1e-8)
    lbfgs(func, var, guess; xtol = xtol)
end

function laplace(func::MExpr, oldvar, newvar)
    "laplace($func, $oldvar, $newvar)" |> MExpr |> mcall
end

function laplace{T}(func::T, oldvar, newvar)
    m = MExpr(func)
    convert(T, "laplace($m, $oldvar, $newvar)" |> MExpr |> mcall)
end

function ilt(func::MExpr, oldvar, newvar)
    "ilt($func, $oldvar, $newvar" |> MExpr |> mcall
end

function ilt{T}(func::T, oldvar, newvar)
    m = MExpr(func)
    convert(T, "ilt($m, $oldvar, $newvar)" |> MExpr |> mcall)
end
