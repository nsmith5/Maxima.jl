# Getting Started

To start using Maxima.jl, fire up a repl session and load the package.

```julia
julia> using Maxima

julia> Connecting Maxima to server on port 8080
```

In the backend, Maxima.jl connects to a Maxima session over a TCP socket, so you'll see a statement print out about the port that Maxima connected on. You can play around a bit making Maxima expression with the `@m_str` string macro and evaluating them with `mcall()`

```@repl
using Maxima # hide
m"sin(x)/x"
m"integrate(sin(x), x)"
mcall(ans)
```

You can also interact with the Maxima session directly by entering the Maxima repl mode.

```julia
julia>  # type ']'

maxima> 1 + 1;
             
               2

maxima> sin(x)$

maxima>
```


# Maxima Expressions

Maxima.jl revolves around the Maxima expression type: `MExpr`. Maxima expressions can be constructed using a constructor or a string macro. 

```@repl
using Maxima # hide
MExpr("sin(x)/x")
m"integrate(1 + x^2, x)"
```

Maxima expressions don't neccessarily need to be valid Maxima, but a warning will be printed when the expression is printed and an error will be thrown if the expression is evaluated. 

```@repl
using Maxima # hide
m"1+"
mcall(ans)
m"1/0"
mcall(ans)
```

Maxima expressions can be evaluated using `mcall`.

```@repl
using Maxima # hide
m"integrate(1/(1+x^2), x)"
mcall(ans)
mcall(m"1+")
```

#  






