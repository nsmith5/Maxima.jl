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

ratsimp(m::MExpr) = "ratsimp($m)" |> MExpr |> mcall

function ratsimp(exp::Expr)
    m = MExpr(exp)
    "ratsimp($m)" |> MExpr |> mcall |> parse
end

ratcan(m::MExpr) = "ratcan($m)" |> MExpr |> mcall

function ratcan(exp::Expr)
    m = MExpr(exp)
    "ratcan($m)" |> MExpr |> mcall |> parse
end

factor(m::MExpr) = "factor($m)" |> MExpr |> mcall

function factor(exp::Expr)
    m = MExpr(exp)
    "factor($m)" |> MExpr |> mcall |> parse
end

gfactor(m::MExpr) = "gfactor($m)" |> MExpr |> mcall

function gfactor(exp::Expr)
    m = MExpr(exp)
    "gfactor($m)" |> MExpr |> mcall |> parse
end

expand(m::MExpr) = "expand($m)" |> MExpr |> mcall

function expand(exp::Expr)
    m = MExpr(exp)
    "expand($m)" |> MExpr |> mcall |> parse
end

logcontract(m::MExpr) = "logcontract($m)" |> MExpr |> mcall

function logcontract(exp::Expr)
    m = MExpr(exp)
    "logcontract($m)" |> MExpr |> mcall |> parse
end

makefact(m::MExpr) = "makefact($m)" |> MExpr |> mcall

function makefact(exp::Expr)
    m = MExpr(exp)
    "makefact($m)" |> MExpr |> mcall |> parse
end

makegamma(m::MExpr) = "makegamma($m)" |> MExpr |> mcall

function makegamma(exp::Expr)
    m = MExpr(exp)
    "makegamma($m)" |> MExpr |> mcall |> parse
end

trigsimp(m::MExpr) = "trigsimp($m)" |> MExpr |> mcall

function trigsimp(exp::Expr)
    m = MExpr(exp)
    "trigsimp($m)" |> MExpr |> mcall |> parse
end

trigreduce(m::MExpr) = "trigreduce($m)" |> MExpr |> mcall

function trigreduce(exp::Expr)
    m = MExpr(exp)
    "trigreduce($m)" |> MExpr |> mcall |> parse
end

trigexpand(m::MExpr) = "trigexpand($m)" |> MExpr |> mcall

function trigexpand(exp::Expr)
    m = MExpr(exp)
    "trigexpand($m)" |> MExpr |> mcall |> parse
end

trigrat(m::MExpr) = "trigrat($m)" |> MExpr |> mcall

function trigrat(exp::Expr)
    m = MExpr(exp)
    "trigrat($m)" |> MExpr |> mcall |> parse
end

recttform(m::MExpr) = "rectform($m)" |> MExpr |> mcall

function rectform(exp::Expr)
    m = MExpr(exp)
    "rectform($m)" |> MExpr |> mcall |> parse
end

polarform(m::MExpr) = "polarform($m)" |> MExpr |> mcall

function polarform(exp::Expr)
    m = MExpr(exp)
    "polarform($m)" |> MExpr |> mcall |> parse
end

function realpart(m::MExpr)
    "realpart($m)" |> MExpr |> mcall
end

function realpart(exp::Expr)
    m = MExpr(exp)
    "realpart($m)" |> MExpr |> mcall |> parse
end

function imagpart(m::MExpr)
    "imagpart($m)" |> MExpr |> mcall
end

function imagpart(exp::Expr)
    m = MExpr(exp)
    "imagpart($m)" |> MExpr |> mcall |> parse
end

function demoivre(m::MExpr)
    "demoivre($m)" |> MExpr |> mcall
end

function demoivre(exp::Expr)
    m = MExpr(exp)
    "demoivre($m)" |> MExpr |> mcall |> parse
end

function exponentialize(m::MExpr)
    "exponentialize($m)" |> MExpr |> mcall
end

function exponentialize(exp::Expr)
    m = MExpr(exp)
    "exponentialize($m)" |> MExpr |> mcall |> parse
end

float(m::MExpr) = "float($m)" |> MExpr |> mcall

subst(a, b, c::MExpr) = "subst($a, $b, $c)" |> MExpr |> mcall

function subst(a, b, c::Expr)
    m = MExpr(c)
    "subst($a, $b, $m) )" |> MExpr |> mcall |> parse
end
