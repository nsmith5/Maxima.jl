#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

export rhs,
       lhs

function rhs(m::MExpr)
    return mcall(MExpr("rhs($m)"))
end

"""
    rhs(expr::T) where T

Right hand side of an equation.

If `expr` is not an equation than `rhs` will return `0`
"""
function rhs(m::T) where T
    return convert(T, rhs(MExpr(m)))
end

function lhs(m::MExpr)
    return mcall(MExpr("lhs($m)"))
end

"""
    lhs(expr::T) where T

Left hand side of an equation.

If `expr` is not an equation then `lhs` will return `expr`
"""
function lhs(m::T) where T
    return convert(T, lhs(MExpr(m)))
end

allroots(m::MExpr) = mcall(MExpr("rhs($m)"))
allroots(m::T) where T = convert(T, allroots(MExpr(m)))
