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

function ratsimp{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("ratsimp($mexpr)"))
    convert(T, out)
end

function ratcan{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("ratcan($mexpr)"))
    convert(T, out)
end

function factor{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("factor($mexpr)"))
    convert(T, out)
end

function gfactor{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("gfactor($mexpr)"))
    convert(T, out)
end

function expand{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("expand($mexpr)"))
    convert(T, out)
end

function logcontract{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("logcontract($mexpr)"))
    convert(T, out)
end

function makefact{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("makefact($mexpr)"))
    convert(T, out)
end

function makegamma{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("makegamma($mexpr)"))
    convert(T, out)
end

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

function float{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("float($mexpr)"))
    convert(T, out)
end

function subst{T}(expr::T)
    mexpr = MExpr(expr)
    out = mcall(MExpr("subst($mexpr)"))
    convert(T, out)
end
