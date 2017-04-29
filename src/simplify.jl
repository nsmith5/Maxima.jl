#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

export float,
       subst,
       ratsimp,
       radcan,
       factor,
       gfactor,
       expand,
       logcontract,
       logexpand,
       makefact,
       makegamma,
       trigsimp,
       trigreduce,
       trigexpand,
       trigrat,
       rectform,
       polarform,
       realpart,
       imagpart,
       demoivre,
       exponentialize

import Base: expand,
             diff,
             float

if VERSION < v"0.6-"
    import Base: factor
end

"""
    ratsimp{T}(expr::T)

Simplify expression.

# Examples

```julia
julia> ratsimp(\"a + b/c\")
\"(a*c+b)/c\"

julia> ratsimp(:(sin(asin(a + b/c))))
:((a * c + b) / c)

julia> ratsimp(m\"%e^log(x)\")
 
                                       x
```
"""
function ratsimp{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("ratsimp($mexpr)"))
    convert(T, out)
end

"""
    radcan{T}(expr::T)

Simplify radicals in expression.

## Examples
```julia
julia> radcan(:(sqrt(x/y)))
:(sqrt(x)/sqrt(y))

julia> radcan(m\"sqrt(x/y)\")
 
                                    sqrt(x)
                                    -------
                                    sqrt(y)

```
"""
function radcan{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("radcan($mexpr)"))
    convert(T, out)
end


"""
    factor{T}(expr::T)

Factorize polynomial expression

## Examples

```julia
julia> factor(:(x^2 + 2x + 1))
:((x + 1) ^ 2)

julia> factor(MExpr(\"a^2 - b^2\"))
 
                                (a - b) (b + a)

```
"""
function factor{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("factor($mexpr)"))
    convert(T, out)
end

"""
    gfactor{T}(expr::T)

Factorize complex polynomial expression

## Examples

```julia
julia> gfactor(:(z^2 + 2*im*z - 1))
:((z + im) ^ 2)

```
"""
function gfactor{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("gfactor($mexpr)"))
    convert(T, out)
end

"""
    expand(expr)

Expand expression. 

## Examples
```julia
julia> expand(m\"(a + b)^2\")
 
                                 2            2
                                b  + 2 a b + a

```
"""
function expand(expr::Compat.String)
    mexpr = MExpr(expr)
    out = mcall(MExpr("expand($mexpr)"))
    convert(Compat.String, out)
end

function expand(expr::Expr)
    mexpr = MExpr(expr)
    out = mcall(MExpr("expand($mexpr)"))
    convert(Expr, out)
end

function expand(expr::MExpr)
    mcall(MExpr("expand($expr)"))
end

"""
    logcontract{T}(expr::T)

Contract logarithms in expression
"""
function logcontract{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("logcontract($mexpr)"))
    convert(T, out)
end

"""
    logexpand{T}(expr::T)

Expand logarithm terms in an expression
"""
function logexpand{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("$mexpr, logexpand=super"))
    convert(T, out)
end

"""
    makefact{T}(expr::T)

Convert expression into factorial form.
"""
function makefact{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("makefact($mexpr)"))
    convert(T, out)
end

"""
    makegamma{T}(expr::T)

Convert factorial to gamma functions in expression
"""
function makegamma{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("makegamma($mexpr)"))
    convert(T, out)
end

"""
    trigsimp{T}(expr::T)

Simplify trigonometric expression

## Examples
```julia
julia> trigsimp(m\"sin(x)^2 + cos(x)^2\")
 
                                       1
```
"""
function trigsimp{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigsimp($mexpr)"))
    convert(T, out)
end

"""
    trigreduce(expr)

Contract trigonometric functions
"""
function trigreduce{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigreduce($mexpr)"))
    convert(T, out)
end

"""
    trigexpand(expr)

Expand out trig functions in expression
"""
function trigexpand{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigexpand($mexpr)"))
    convert(T, out)
end

"""
    trigrat(expr)

Convert expression into a canonical trigonometric form

## Examples
```julia
julia> trigrat(:(exp(im*x) + exp(-im*x)))
:(2 * cos(x))

```
"""
function trigrat{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigrat($mexpr)"))
    convert(T, out)
end

"""
    rectform(expr)

Put complex expression in rectangular form

## Examples
```julia
julia> rectform(:(R*e^(im*θ)))
:(R * im * sin(θ) + R * cos(θ))


```
"""
function rectform{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("rectform($mexpr)"))
    convert(T, out)
end

"""
    polarform(expr)

Put a complex expression into polarform

## Examples
```julia
julia> polarform(m\"a + %i*b\")
 
                              2    2    %i atan2(b, a)
                        sqrt(b  + a ) %e

```
"""
function polarform{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("polarform($mexpr)"))
    convert(T, out)
end

"""
    realpart(expr)

Find the real part of a complex expression

## Examples
```julia
julia> realpart(MExpr(\"a + %i*b\"))

                            a

```
"""
function realpart{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("realpart($mexpr)"))
    convert(T, out)
end


"""
    imagpart(expr)

Find the imaginary part of a complex expression.

## Examples
```julia
julia> realpart(MExpr(\"a + %i*b\"))

                            b

```
"""
function imagpart{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("imagpart($mexpr)"))
    convert(T, out)
end

"""
    demoivre(expr)

Break exponential terms into hyperbolic and trigonometric functions. Roughly the 
opposite in function to `exponentialize`

## Examples
```julia
julia> demoivre(m\"exp(a + %i * b)\")
 
                             a
                           %e  (%i sin(b) + cos(b))

julia> exponentialize(ans)
 
                         %i b     - %i b     %i b     - %i b
                    a  %e     + %e         %e     - %e
                  %e  (----------------- + -----------------)
                               2                   2

julia> expand(ans)
 
                                    %i b + a
                                  %e

```
"""
function demoivre{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("demoivre($mexpr)"))
    convert(T, out)
end

"""
    exponentialize(expr)

Express expression in terms of exponents as much as possible

## Examples
```julia
julia> exponentialize(m\"sin(x)\")
 
                                   %i x     - %i x
                             %i (%e     - %e      )
                           - ----------------------
                                       2

```
"""
function exponentialize{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("exponentialize($mexpr)"))
    convert(T, out)
end

"""
    float(expr)

Convert rational numbers into floating point numbers in expression.

## Examples
```julia
julia> float(m\"1/3*x\")
 
                             0.3333333333333333 x

```
"""
function float(expr::Union{Compat.String, Expr, MExpr})
    T = typeof(expr)
	mexpr = MExpr(expr)
    out = mcall(MExpr("float($mexpr)"))
    convert(T, out)
end

"""
    subst(a, b, expr)

Replace `a` with `b` in `expr`.

## Examples
```julia
julia> subst(:b, :a, :(a^2 + b^2))
:(2 * b ^ 2)

```
"""
function subst{T}(a, b, expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("subst($a, $b, $mexpr)"))
    convert(T, out)
end
