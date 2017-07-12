#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith


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
             getindex,
             *,
             split


type MaximaError <: Exception
    errstr::Compat.String
end

Base.showerror(io::IO, err::MaximaError) = print(io, err.errstr)


type MaximaSyntaxError <: Exception
    errstr::Compat.String
end

Base.showerror(io::IO, err::MaximaSyntaxError) = print(io, err.errstr)


const infix_ops = [:+, :-, :*, :/, :^]

isinfix(args) = args[1] in infix_ops && length(args) > 2
show_expr(io::IO, ex) = print(io, ex)


function show_expr(io::IO, expr::Expr)
    if expr.head == :call
        seperator = isinfix(expr.args) ? " $(expr.args[1]) " : ", "
        !isinfix(expr.args) && show_expr(io, expr.args[1])
        print(io, "(")
        args = expr.args[2:end]
        for (i, arg) in enumerate(args)
            show_expr(io, arg)
            i != endof(args) ? print(io, seperator) : print(io, ")")
        end
    elseif expr.head == :(=)
        show_expr(io,expr.args[1])
        print(io,": ")
        show_expr(io,expr.args[2])
    elseif expr.head == :function
        show_expr(io,expr.args[1])
        print(io," := block([], ")
        args = unparse(expr.args[2])
        for (i, arg) in enumerate(args)
            print(io,arg)
            i != endof(args) ? print(io, ", ") : print(io, ")")
        end
    elseif expr.head == :line
        nothing
    else
      error("Nested :$(expr.head) block structure not supported by Maxima.jl")
    end
end


function unparse(expr::Expr)
    str = Array{Compat.String,1}(0)
    io = IOBuffer();
    if expr.head == :block
        for line in expr.args
            show_expr(io,line)
            push!(str,takebuf_string(io))
        end
        return mtrim(str)
    else
        show_expr(io, expr)
        return push!(str,Compat.String(io))
    end
end


"""

A Maxima expression

## Summary:

type MExpr <: Any

## Fields:

str :: String
"""
type MExpr
    str::Array{Compat.String,1}
    MExpr(m::Array{Compat.String,1}) = new(m)
end


MExpr(m::Array{SubString{Compat.String},1}) = MExpr(convert(Array{Compat.String,1},m))
MExpr(str::Compat.String) = MExpr(push!(Array{Compat.String,1}(0),str))
MExpr(m::Any) = MExpr("$m")


macro m_str(str)
    MExpr(str)
end


*(x::MExpr,y::Compat.String) = MExpr(push!(deepcopy(x.str),y))
*(x::Compat.String,y::MExpr) = MExpr(unshift!(deepcopy(y.str),x))
*(x::MExpr,y::MExpr) = MExpr(vcat(x.str...,y.str...))


function mtrim(m::Array{Compat.String,1})
    n = Array{Compat.String,1}(0)
    for h in 1:length(m)
        !isempty(m[h]) && push!(n,m[h])
    end
    return n
end


function split(m::MExpr)
    n = Compat.String[]
    for i in 1:length(m.str)
        p = split(replace(m.str[i], r"\$", ";"), ';')
        for j in 1:length(p)
            push!(n, p[i])
        end
    end
    return MExpr(n)
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

_subst(a, b, expr) = "subst($a, $b, '($expr))" |> MExpr |> mcall


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
    # str = "$expr"
    str = unparse(expr)
    for h in 1:length(str)
        for key in keys(jl_to_m)
            str[h] = _subst(jl_to_m[key], key, str[h])
        end
    end
    return MExpr(str)
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
    pexpr = Any[]
    for subexpr in split(m).str
        for key in keys(m_to_jl)
            subexpr = replace(subexpr, key, m_to_jl[key])
        end
        if contains(subexpr, ":=")
            sp = split(subexpr, ":=")
            push!(pexpr, Expr(:function, parse(sp[1]),sp[2] |> Compat.String |> MExpr |> parse))
        elseif contains(subexpr, "block([],")
            rp = replace(subexpr, "block([],", "") |> chop
            sp = split(rp, ",")
            ep = Vector{Any}(length(sp))
            for j in 1:length(sp)
                ep[j] = sp[j] |> Compat.String |> MExpr |> parse
            end
            push!(pexpr,Expr(:block,ep...))
        elseif contains(subexpr, ":")
            sp = split(subexpr, ":")
            push!(pexpr,Expr(:(=),parse(sp[1]),sp[2] |> Compat.String |> MExpr |> parse))
        else
            push!(pexpr,parse(subexpr))
        end
    end
    return length(pexpr) == 1 ? pexpr[1] : Expr(:block, pexpr...)
end


convert(::Type{MExpr}, m::MExpr) = m
convert(::Type{Array{Compat.String,1}}, m::MExpr) = m.str
convert(::Type{Compat.String}, m::MExpr) = join(m.str,"; ")
convert{T}(::Type{T}, m::MExpr) = T <: Number ? eval(parse(m)) : parse(m)

if VERSION < v"0.5.0"
    convert(::Type{UTF8String}, m::MExpr) = UTF8String(m.str)
    convert(::Type{ASCIIString}, m::MExpr) = ASCIIString(m.str)
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
    write(ms, replace(convert(Compat.String,m), r";", "; print(ascii(3))\$ "))
    output = read(ms)
    if contains(output, maxerr)
            write(ms.input, "errormsg()\$")
            write(ms.input, "print(ascii(4))\$")
            message = read(ms)
            throw(MaximaError(message))
    elseif contains(output, synerr)
        throw(MaximaSyntaxError(output))
    else
        sp = split(output, '\x03')
        for k in 1:length(sp)
          sp[k] = replace(sp[k], '\n', "")
          sp[k] = replace(sp[k], ' ', "")
        end
        return MExpr(sp)
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
    r = split(m).str
    s = split(n).str
    l=length(r)
    l!=length(s) && (return false)
    b = true
    for j in 1:l
        out = mcall("is($(r[j]) = $(s[j]))")
        b &= !contains(out,"false")
    end
    return b
end

function getindex(m::MExpr, i)
    return MExpr("$m[$i]") |> mcall
end
