export MExpr,
       @m_str,
       parse,
       mcall,
       convert

import Base: parse,
             convert

type MExpr
	str::String
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

function MExpr(expr::Expr)
    str = "$expr"
    for key in keys(jl_to_m)
        str = _subst(jl_to_m[key], key, str)
    end
    MExpr(str)
end

function parse(m::MExpr)
    str = m.str
    for key in keys(m_to_jl)
        str = _subst(m_to_jl[key], key, str)
    end
    parse(str)
end

convert(::Type{Compat.String}, m::MExpr) = m.str
convert(::Type{Expr}, m::MExpr) = parse(m)

"""
	mcall(m::MExpr)

Evaluate a Maxima expression.
"""
function mcall(m::MExpr)
    put!(inputchannel, "$(m.str);")
    output = take!(outputchannel)
    output = replace(output, '\n', "")
    output = replace(output, " ", "")
	MExpr(output)
end

"""
	mcall{T}(expr::T)

Evaluate an expression using the Maxima interpretor
"""
function mcall{T}(expr::T)
    mexpr = MExpr(expr)
    return convert(T, mcall(mexpr))
end
    
