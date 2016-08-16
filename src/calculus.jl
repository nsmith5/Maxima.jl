export sum,
       integrate,
       diff,
       limit,
       taylor,
       product

import Base: sum

function integrate(m::MExpr, s)
    MExpr("integrate($m, $s)") |> mcall
end

function integrate(expr::Expr, s)
    m = MExpr(expr)
    out = integrate(m, s)
    parse(out)
end

function integrate(m::MExpr, s, lower::Number, upper::Number)
    MExpr("integrate($m, $s, $lower, $upper)") |> mcall
end

function integrate(expr::Expr, s, lower::Number, upper::Number)
    m = MExpr(expr)
    out = integrate(m, s, lower, upper)
    parse(out)
end

function diff(m::MExpr, s)
    MExpr("diff($m, $s)") |> mcall
end

function diff(exp::Expr, s)
    m = MExpr(exp)
    out = diff(m, s)
    parse(out)
end

function diff(m::MExpr, s, order::Integer)
    if order < 0
        error("Order of derivative must be positive integer")
    end
    MExpr("diff($m, $s, $order)") |> mcall
end

function diff(exp::Expr, s, order::Integer)
    m = MExpr(exp)
    out = diff(m, s, order)
    parse(out)
end

function limit(m::MExpr, x, a)
    MExpr("limit($m, $x, $a)") |> mcall
end

function limit(exp::Expr, x, a)
    m = MExpr(exp)
    out = limit(m, x, a)
    parse(out)
end

function limit(m::MExpr, x, a, side)
    if "$side" != "plus" || "minus"
        error("Side of limit must be \"plus\" or \"minus\"")
    end
    MExpr("limit($m, $x, $a, $side") |> mcall
end

function limit(exp::Expr, x, a, side)
    m = MExpr(exp)
    out = limit(m, x, a, side)
    parse(out)
end

function sum(m::MExpr, k, start, finish)
    MExpr("sum($m, $k, $start, $finish), simpsum") |> mcall
end

function sum(exp::Expr, k, start, finish)
    sumexp = parse("sum($exp, $k, $start, $finish)")
    m = MExpr(sumexp)
    MExpr("$m, simpsum") |> mcall |> parse
end

function taylor(m::MExpr, x, x0, order::Integer)
    if order < 0
        error("Order of taylor expansion must be ≥ 0")
    end
    MExpr("taylor($m, $x, $x0, $order)") |> mcall
end

function taylor(exp::Expr, x, x0, order::Integer)
    m = MExpr(exp)
    taylor(m, x, x0, order) |> parse
end

function product(m::MExpr, k, start, finish)
    MExpr("product($m, $k, $start, $finish), simpsum") |> mcall
end

function product(exp::Expr, k, start, finish)
    sumexp = parse("product($exp, $k, $start, $finish)")
    sumexp |> MExpr |> mcall |> parse
end
