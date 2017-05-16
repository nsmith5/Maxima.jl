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
             getindex


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
    if expr.head != :call
        error("Nested block structure is not supported by Maxima.jl")
    else
        seperator = isinfix(expr.args) ? " $(expr.args[1]) " : ", "
        !isinfix(expr.args) && show_expr(io, expr.args[1])
        print(io, "(")
        args = expr.args[2:end]
        for (i, arg) in enumerate(args)
            show_expr(io, arg)
            i != endof(args) ? print(io, seperator) : print(io, ")")
        end
    end
end

function unparse(expr::Expr)
  str = Array{Compat.String,1}(0)
	io = IOBuffer();
  if expr.head == :block
    for line ∈ expr.args
      show_expr(io,line)
      push!(str,takebuf_string(io))
    end
    return str
	else
    show_expr(io, expr)
    return push!(str,String(io))
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
end
MExpr(str::Compat.String) = MExpr(push!(Array{Compat.String,1}(0),str))

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
	#str = "$expr"
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
  pexpr = Array{Expr,1}(0); sexpr = Array{Compat.String,1}(0)
  for h in 1:length(m.str)
    sp = split(replace(m.str[h],r"\$",";"),';')
    for str in sp
      push!(sexpr,mcall(MExpr("$(String(str))")).str...)
    end
  end
  for h in 1:length(sexpr)
    for key in keys(m_to_jl)
      sexpr[h] = _subst(m_to_jl[key], key, sexpr[h]).str[1]
    end
    push!(pexpr,parse(sexpr[h]))
  end
  return length(pexpr) == 1 ? pexpr[1] : Expr(:block,pexpr...)
end


convert(::Type{Compat.String}, m::MExpr) = join(m.str,"; ")
convert(::Type{Expr}, m::MExpr) = parse(m)
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
    write(ms, replace(convert(String,m),r";","; print(ascii(3))\$ "))
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
    out = mcall("is($m = $n)")
    contains(out,"false") ? (out = "0") : (out = "1")
    return out |> parse |> eval |> Bool
end

function getindex(m::MExpr, i)
    return MExpr("$m[$i]") |> mcall
end
