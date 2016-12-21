#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

export rhs,
       lhs

function rhs(m::MExpr)
    return mcall(MExpr("rhs($m)"))
end

"""
    rhs{T}(expr::T)

Right hand side of an equation.

If `expr` is not an equation than `rhs` will return `0`
"""
function rhs{T}(m::T)
    return convert(T, rhs(MExpr(m)))
end

function lhs(m::MExpr)
    return mcall(MExpr("lhs($m)"))
end

"""
    lhs{T}(expr::T)

Left hand side of an equation.

If `expr` is not an equation then `lhs` will return `expr`
"""
function lhs{T}(m::T)
    return convert(T, lhs(MExpr(m)))
end

allroots(m::MExpr) = mcall(MExpr("rhs($m)"))
allroots{T}(m::T) = convert(T, allroots(MExpr(m)))
