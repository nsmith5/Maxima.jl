export float,
       subst,
       ratsimp,
       radcan,
       factor,
       gfactor,
       expand,
       logcontract,
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
             factor,
             float

"""
    ratsimp{T}(expr::T)

Simplify expression.
"""
function ratsimp{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("ratsimp($mexpr)"))
    convert(T, out)
end

"""
    radcan{T}(expr::T)

Simplify radicals in expression.
"""
function radcan{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("radcan($mexpr)"))
    convert(T, out)
end


"""
    factor{T}(expr::T)

Factorize polynomial expression
"""
function factor{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("factor($mexpr)"))
    convert(T, out)
end

"""
    gfactor{T}(expr::T)

Factorize complex polynomial expression
"""
function gfactor{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("gfactor($mexpr)"))
    convert(T, out)
end

"""
    expand{T}(expr::T)

Expand expression
"""
function expand{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("expand($mexpr)"))
    convert(T, out)
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
"""
function trigsimp{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigsimp($mexpr)"))
    convert(T, out)
end

function trigreduce{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigreduce($mexpr)"))
    convert(T, out)
end

function trigexpand{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigexpand($mexpr)"))
    convert(T, out)
end

function trigrat{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("trigrat($mexpr)"))
    convert(T, out)
end

function rectform{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("rectform($mexpr)"))
    convert(T, out)
end

function polarform{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("polarform($mexpr)"))
    convert(T, out)
end

function realpart{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("realpart($mexpr)"))
    convert(T, out)
end

function imagpart{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("imgpart($mexpr)"))
    convert(T, out)
end

function demoivre{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("demoivre($mexpr)"))
    convert(T, out)
end

function exponentialize{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("exponentialize($mexpr)"))
    convert(T, out)
end

function float(expr::Union{Compat.String, Expr, MExpr})
    T = typeof(expr)
	mexpr = MExpr(expr)
    out = mcall(MExpr("float($mexpr)"))
    convert(T, out)
end

function subst{T}(a, b, expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("subst($a, $b, $mexpr)"))
    convert(T, out)
end
