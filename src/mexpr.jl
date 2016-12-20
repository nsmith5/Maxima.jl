# This file is part of Maxima.jl. It is licensed under the MIT license

export MExpr,
       @m_str,
       parse,
       mcall,
       convert,
       error,
       MaximaError,
       MaximaSyntaxError,
       ==,
       getindex

import Base: parse,
             convert,
             error,
             ==,
             getindex

type MaximaError <: Exception
	errstr::Compat.String
end

Base.showerror(io::IO, err::MaximaError) = print(io, err.errstr)

type MaximaSyntaxError <: Exception
	errstr::Compat.String
end

Base.showerror(io::IO, err::MaximaSyntaxError) = print(io, err.errstr)

"""

A Maxima expression

## Summary:

type MExpr <: Any

## Fields:

str :: String
"""
type MExpr
	str::Compat.String
end

macro m_str(str)
	MExpr(str)
end

const m_to_jl = Dict("%e" => "e",
    "%pi"   =>  "π",
    "%i"    =>  "im",
    "%gamma" => "eulergamma",
    "%phi"  =>  "φ",
    "inf"   =>  "Inf",
    "minf"  =>  "-Inf")

const jl_to_m = Dict("e" => "%e",
    "eu" => "%e",
    "pi" => "%pi",
    "π" => "%pi",
    "γ" => "%gamma",
    "eulergamma" => "%gamma",
    "golden" => "%phi",
    "φ" => "%phi",
    "im" => "%i",
    "Inf" => "inf")

function _subst(a, b, expr)
    mstr = "subst($a, $b, '($expr))" |> MExpr
	mstr = mcall(mstr)
	return mstr.str
end

"""
    MExpr(expr::Expr)

Convert Julia expression to Maxima expression

## Examples
```julia
julia> MExpr(:(sin(x*im) + cos(y*φ)))

                           cos(%phi y) + %i sinh(x)

```
"""
function MExpr(expr::Expr)
    str = "$expr"
    for key in keys(jl_to_m)
        str = _subst(jl_to_m[key], key, str)
    end
    MExpr(str)
end

"""
    parse(mexpr::MExpr)

Parse a Maxima expression into a Julia expression

## Examples
```julia
julia> parse(m\"sin(%i*x)\")
:(im * sinh(x))

```
"""
function parse(m::MExpr)
    str = m.str
    for key in keys(m_to_jl)
        str = _subst(m_to_jl[key], key, str)
    end
    parse(str)
end

convert(::Type{Compat.String}, m::MExpr) = m.str
convert(::Type{Expr}, m::MExpr) = parse(m)
if VERSION < v"0.5.0"
    convert(::Type{UTF8String}, m::MExpr) = UTF8String(m.str)
    convert(::Type{ASCIIString}, m::MExpr) = ASCIIString(m.str)
end

function error(mexpr::MExpr)
    input("$(mexpr.str);")
    output()
    return take!(errchannel)
end

"""
	mcall(m::MExpr)

Evaluate a Maxima expression.

## Examples
```julia
julia> m\"integrate(sin(x), x)\"

                             integrate(sin(x), x)

julia> mcall(ans)

                                   - cos(x)

```
"""
function mcall(m::MExpr)
    put!(inputchannel, "$(m.str);")
    output = take!(outputchannel)
    err = take!(errchannel)
    if err == 0
        output = replace(output, '\n', "")
        output = replace(output, " ", "")
        return MExpr(output)
    elseif err == 1
		input("errormsg()\$")
		err = take!(errchannel)
		@assert err == 0
		output = take!(outputchannel)
        throw(MaximaError(output))
    elseif err == 2
        throw(MaximaSyntaxError(output))
    end
end

"""
	mcall{T}(expr::T)

Evaluate a Julia expression or string using the Maxima interpretor and convert
output back into the input type

## Examples
```julia
julia> mcall(\"integrate(sin(y)^2, y)\")
\"(y-sin(2*y)/2)/2\"

julia> mcall(:(integrate(1/(1+x^2), x)))
:(atan(x))

```
"""
function mcall{T}(expr::T)
    mexpr = MExpr(expr)
    return convert(T, mcall(mexpr))
end

function ==(m::MExpr, n::MExpr)
    return mcall(MExpr("is($m = $n)")) |> parse |> eval
end

function getindex(m::MExpr, i)
    return MExpr("$m[$i]") |> mcall
end
