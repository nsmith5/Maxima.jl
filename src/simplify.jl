#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

export subst,
       logexpand

import Base: expand,
             diff,
             float

if VERSION < v"0.6-"
    import Base: factor
end

simfun = [
    :ratsimp,:radcan,
    :factor,:gfactor,:expand,
    :logcontract,
    :makefact,:makegamma,
    :trigsimp,:trigreduce,:trigexpand,:trigrat,
    :rectform,:polarform,
    :realpart,:imagpart,
    :demoivre,
    :exponentialize,
    :float
]

:(export $(simfun...)) |> eval

ty = [:(Compat.String),:Expr]

for fun in simfun
    for T in ty
        quote
            function $fun(expr::$T)
                convert($T, $fun(MExpr(expr)))
            end
        end |> eval
    end
    quote
        function $fun(m::MExpr)
            nsr = Compat.String[]
            sexpr = split(m).str
            for h in 1:length(sexpr)
                if contains(sexpr[h], ":=")
                    sp = split(sexpr[h], ":=")
                    push!(nsr,Compat.String(sp[1]) * ":=" * string(sp[2] |> Compat.String |> MExpr |> $fun))
                elseif contains(sexpr[h], "block([],")
                    rp = replace(sexpr[h], "block([],", "") |> chop
                    sp = split(rp, ",")
                    ns = "block([],"
                    for u in 1:length(sp)
                        ns = ns * string(sp[u] |> Compat.String |> MExpr |> $fun)
                    end
                    ns = ns * ")"
                    push!(nsr, ns)
                elseif contains(sexpr[h], ":")
                    sp = split(sexpr[h], ":")
                    push!(nsr, Compat.String(sp[1]) * ":" * string(sp[2] |> Compat.String |> MExpr |> $fun))
                else
                    push!(nsr, $(string(fun)) * "($(sexpr[h]))" |> MExpr |> mcall)
                end
            end
            return MExpr(nsr)
        end
    end |> eval
end

@doc """
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
""" ratsimp

@doc """
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
""" radcan

@doc """
    factor{T}(expr::T)

Factorize polynomial expression

## Examples

```julia
julia> factor(:(x^2 + 2x + 1))
:((x + 1) ^ 2)

julia> factor(MExpr(\"a^2 - b^2\"))

                                (a - b) (b + a)

```
""" factor

@doc """
    gfactor{T}(expr::T)

Factorize complex polynomial expression

## Examples

```julia
julia> gfactor(:(z^2 + 2*im*z - 1))
:((z + im) ^ 2)

```
""" gfactor

"""
    expand(expr)

Expand expression.

## Examples
```julia
julia> expand(m\"(a + b)^2\")

                                 2            2
                                b  + 2 a b + a

```
""" expand

@doc """
    logcontract{T}(expr::T)

Contract logarithms in expression
""" logcontract

@doc """
    logexpand{T}(expr::T)

Expand logarithm terms in an expression
""" logexpand

for t in ty
    quote
        function logexpand(expr::$t)
            convert($t, logexpand(MExpr(expr)))
        end
    end |> eval
end


function logexpand(m::MExpr)
    nsr = Array{Compat.String,1}(0)
    sexpr = split(m).str
    for h in 1:length(sexpr)
        if contains(sexpr[h], ":=")
            sp = split(sexpr[h], ":=")
            push!(nsr, Compat.String(sp[1])*":="*string(sp[2]|>Compat.String|>MExpr|>logexpand))
        elseif contains(sexpr[h], "block([],")
            rp = replace(sexpr[h], "block([],","") |> chop
            sp = split(rp, ",")
            ns = "block([],"
            for u in 1:length(sp)
                ns = ns*string(sp[u] |> Compat.String |> MExpr |> logexpand)
            end
            ns = ns * ")"
            push!(nsr,ns)
        elseif contains(sexpr[h],":")
            sp = split(sexpr[h],":")
            push!(nsr, Compat.String(sp[1])*":"*string(sp[2]|>Compat.String|>MExpr|>logexpand))
        else
            push!(nsr, "$(sexpr[h]), logexpand=super" |> MExpr |> mcall)
        end
    end
    return MExpr(nsr)
end

@doc """
    makefact{T}(expr::T)

Convert expression into factorial form.
""" makefact

@doc """
    makegamma{T}(expr::T)

Convert factorial to gamma functions in expression
""" makegamma

@doc """
    trigsimp{T}(expr::T)

Simplify trigonometric expression

## Examples
```julia
julia> trigsimp(m\"sin(x)^2 + cos(x)^2\")

                                       1
```
""" trigsimp

@doc """
    trigreduce(expr)

Contract trigonometric functions
""" trigreduce

@doc """
    trigexpand(expr)

Expand out trig functions in expression
""" trigexpand

@doc """
    trigrat(expr)

Convert expression into a canonical trigonometric form

## Examples
```julia
julia> trigrat(:(exp(im*x) + exp(-im*x)))
:(2 * cos(x))

```
""" trigrat

@doc """
    rectform(expr)

Put complex expression in rectangular form

## Examples
```julia
julia> rectform(:(R*e^(im*θ)))
:(R * im * sin(θ) + R * cos(θ))


```
""" rectform

@doc """
    polarform(expr)

Put a complex expression into polarform

## Examples
```julia
julia> polarform(m\"a + %i*b\")

                              2    2    %i atan2(b, a)
                        sqrt(b  + a ) %e

```
""" polarform

@doc """
    realpart(expr)

Find the real part of a complex expression

## Examples
```julia
julia> realpart(MExpr(\"a + %i*b\"))

                            a

```
""" realpart

@doc """
    imagpart(expr)

Find the imaginary part of a complex expression.

## Examples
```julia
julia> realpart(MExpr(\"a + %i*b\"))

                            b

```
""" imagpart

@doc """
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
""" demoivre

@doc """
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
""" exponentialize

@doc """
    float(expr)

Convert rational numbers into floating point numbers in expression.

## Examples
```julia
julia> float(m\"1/3*x\")

                             0.3333333333333333 x

```
""" float

@doc """
    subst(a, b, expr)

Replace `a` with `b` in `expr`.

## Examples
```julia
julia> subst(:b, :a, :(a^2 + b^2))
:(2 * b ^ 2)

```
""" subst
for t in ty
    quote
        function subst(a, b, expr::$t)
        convert($t, subst(a,b,MExpr(expr)))
        end
    end |> eval
end


function subst(a, b, expr::MExpr)
    str = split(expr).str
    for h in 1:length(str)
        if contains(str[h],":=")
            sp = split(str[h],":=")
            str[h] = Compat.String(str[1])*":="*(_subst(a,b,Compat.String(sp[2]))).str
        elseif contains(str[h],"block([],")
            rp = replace(str[h],"block([],","") |> chop
            sp = split(rp,",")
            ns = "block([],"
            for u in 1:length(sp)
                ns = ns * (_subst(a,b,Compat.String(sp[u]))).str
            end
            ns = ns * ")"
            str[h] = ns
        elseif contains(str[h], ":")
            sp = split(str[h], ":")
            str[h] = Compat.String(sp[1]) * ":" * (_subst(a,b,Compat.String(sp[2]))).str
        else
            str[h] = _subst(a, b, str[h])
        end
    end
    MExpr(str)
end
