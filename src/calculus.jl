# This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

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
    integrate(f::T, x) where T

Evaluate the indefinite integral
```math
\\int f(x) dx
```
## Examples

```julia
julia> integrate(:(sin(x)), :x)
:(-cos(x))
```

## See also

* [`risch`](@refs Maxima.risch)
"""
function integrate(expr::T, s) where T
    m = MExpr(expr)
    out = integrate(m, s)
    convert(T, out)
end

function integrate(m::MExpr, s, lower, upper)
    MExpr("integrate($m, $s, $lower, $upper)") |> mcall
end

"""
    integrate(f::T, x, a, b) where T

Evaluate the definite integral of ``f`` with respect to ``x`` from ``a`` to ``b``.

```math
    \\int_a^b f(x) dx
```
"""
function integrate(expr::T, s, lower, upper) where T
    m = MExpr(expr)
    out = integrate(m, s, lower, upper)
    convert(T, out)
end

function risch(m::MExpr, var)
    MExpr("risch($m, $var)") |> mcall
end

"""
    risch(f::T, x) where T

Compute the indefinite integral of ``f`` with respect to ``x`` using the Risch algorithm

## See also
* [`integrate`](@ref Maxima.integrate)
"""
function risch(exp::T, var) where T
    m = MExpr(exp)
    convert(T, risch(m, var))
end

function diff(m::MExpr, s)
    MExpr("diff($m, $s)") |> mcall
end

"""
    diff(f, x) where T

Take the derivative of ``f`` with respect to ``x``

```math
\\frac{\\partial f(x, ...)}{\\partial x}
```
"""
function diff(exp::T, s) where T
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

"""
    diff(f, x, n) where T

Take the nth order derivative of ``f`` with respect to ``x``.

```math
\\frac{\\partial^n f(x,...)}{\\partial x^n}
```
"""
function diff(exp::T, s, order::Integer) where T
    m = MExpr(exp)
    out = diff(m, s, order)
    convert(T, out)
end

function limit(m::MExpr, x, a)
    MExpr("limit($m, $x, $a)") |> mcall
end

"""
    limit(f, x, a) where T

Take the limit as ``x`` approaches ``a`` of ``f(x)``

```math
lim_{x \\rightarrow a} f(x)
```
"""
function limit(exp::T, x, a) where T
    m = MExpr(exp)
    out = limit(m, x, a)
    convert(T, out)
end

"""
    limit(f, x, a, side) where T

Take the left or right sided limit as ``x`` approaches ``a`` of ``f(x)``.

`side` may be either `\"plus\"` or `\"minus\"` denoting the right and left sided limit respectively
"""
function limit(m::MExpr, x, a, side)
    if "$side" != "plus" && "$side" != "minus"
        error("Side of limit must be \"plus\" or \"minus\"")
    end
    MExpr("limit($m, $x, $a, $side)") |> mcall
end

function limit(exp::T, x, a, side) where T
    m = MExpr(exp)
    out = limit(m, x, a, side)
    convert(T, out)
end

function sum(m::MExpr, k, start, finish)
    MExpr("sum($m, $k, $start, $finish), simpsum") |> mcall
end

"""
    sum(f::T, k, start, finish) where T

Compute the sum,

```math
    \\sum_{k=start}^{finish} f(k),
```
simplifying the sum if possible.
## Examples
```julia
julia> sum(m"1/n^2", :n, 1, "inf")

                                        2
                                     %pi
                                     ----
                                      6

```
"""
function sum(exp::T, k, start, finish) where T
    sumexp = Meta.parse("sum($exp, $k, $start, $finish)")
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

"""
    taylor(f::T, x, x0, n) where T

Taylor expand ``f(x)`` around ``x_0`` to nth order
"""
function taylor(exp::T, x, x0, order::Integer) where T
    m = MExpr(exp)
    out = taylor(m, x, x0, order)
    convert(T, out)
end

function product(m::MExpr, k, start, finish)
    MExpr("product($m, $k, $start, $finish), simpsum") |> mcall
end

"""
    product(f::T, k, start, finish) where T

Compute the product,

```math
    \\prod_{k=start}^{finish} f(k),
```
simplifying the product if possible.
"""
function product(exp::T, k, start, finish) where T
    sumexp = parse("product($exp, $k, $start, $finish)")
    convert(T, sumexp |> MExpr |> mcall)
end

function changevar(integral::MExpr, transform::MExpr, new, old)
    "changevar($integral, $transform, $new, $old)" |> MExpr |> mcall
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

"""
    laplace(f::T, t, s) where T

Compute the Laplace transform of ``f(t)`` where ``s`` is the new variable.

```math
\\mathcal{L}\\lbrace f \\rbrace (s) = \\int_0^\\infty f(t) e^{-st} dt
```
"""
function laplace(func::T, oldvar, newvar) where T
    m = MExpr(func)
    convert(T, "laplace($m, $oldvar, $newvar)" |> MExpr |> mcall)
end

function ilt(func::MExpr, oldvar, newvar)
    "ilt($func, $oldvar, $newvar" |> MExpr |> mcall
end

"""
    ilt(f::T, s, t) where T

Compute the inverse Laplace transform of ``f(s)``.

``t`` is the new variable and ``s`` is the old variable.
"""
function ilt(func::T, oldvar, newvar) where T
    m = MExpr(func)
    convert(T, "ilt($m, $oldvar, $newvar)" |> MExpr |> mcall)
end
