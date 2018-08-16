# Getting Started

To start using Maxima.jl, fire up a repl session and load the package.

```julia
julia> using Maxima

julia> Connecting Maxima to server on port 8080
```

In the backend, Maxima.jl connects to a Maxima session over a TCP socket, so 
you'll see a statement print out about the port that Maxima connected on. You 
can play around a bit making Maxima expression with the `@m_str` string macro 
and evaluating them with `mcall()`

```@repl
using Maxima # hide
m"sin(x)/x"
m"integrate(sin(x), x)"
mcall(ans)
```

You can also interact with the Maxima session directly by entering the Maxima 
repl mode.

```julia
julia>  # type ')'

maxima> 1 + 1;

               2

maxima> sin(x)$

maxima>
```


## Maxima Expressions

Maxima.jl revolves around the Maxima expression type: `MExpr`. Maxima 
expressions can be constructed using a constructor or a string macro and 
evaluated with `mcall`.

```@repl
using Maxima # hide
MExpr("sin(x)/x")
m"integrate(1 + x^2, x)"
mcall(ans)
```

Maxima expressions don't neccessarily need to be valid Maxima, but a warning 
will be printed when the expression is printed and an error will be thrown if 
the expression is evaluated.

```@repl
using Maxima # hide
m"1+"
mcall(ans)
m"1/0"
mcall(ans)
```

Maxima.jl also allows for translation between Maxima and Julia expressions.

```julia
julia> g = m"atan(%i*%pi*y)"

                                %i atanh(%pi y)

julia> parse(g)
:(im * atanh(y * π))

julia> exp = :(sin(π*im))
:(sin(π * im))

julia> mexp = MExpr(exp)

                                 %i sinh(%pi)

```

## Basic Library

Maxima.jl wraps many of the basic Maxima functions for convenience and these 
functions may be applied to Maxima expressions, Julia expressions or basic 
strings. By convention, the return type of these functions is determined by the 
most important input type. For instance, the `integrate` function returns the 
type of the integrand.

```julia
julia> integrate("sin(x)", :x)
"-cos(x)"

julia> integrate(:(sin(x)), "x")
:(-cos(x))

julia> integrate(m"sin(x)", 'x')

					- cos(x)

```
As you can see, the basic library functions are very flexible about their 
argument types. Basically, as long as the argument string interpolates to the 
thing you want then it will work. For a list of all the functions that are 
wrapped take a look through the library reference section of the documentation.
