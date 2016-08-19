[![Build Status](https://travis-ci.org/nsmith5/Maxima.jl.svg?branch=master)](https://travis-ci.org/nsmith5/Maxima.jl)

[![Coverage Status](https://coveralls.io/repos/nsmith5/Maxima.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/nsmith5/Maxima.jl?branch=master)

[![codecov.io](http://codecov.io/github/nsmith5/Maxima.jl/coverage.svg?branch=master)](http://codecov.io/github/nsmith5/Maxima.jl?branch=master)

# Maxima.jl 

Maxima.jl is a tool for symbolic computation in Julia using the Maxima computer algebra system.

## Install

Maxima.jl is still in very early development stages, but if you'd like to try it out you can clone the repository using the Package manager

```julia
julia> Pkg.clone("https://github.com/nsmith5/Maxima.jl.git")
```

At the moment Maxima.jl does not take care of binary dependencies so you'll need to have a working installation of maxima on your system. 

## How-to

Maxima.jl provides a Maxima expression type, `MExpr`, that can be manipulated symbolically.  

```julia
julia> using Maxima
Connecting Maxima to server on port 8080

julia> MExpr("sin(x)/x")

                        sin(x)
                        ------
                          x

julia> subst(:y, :x, ans)

                        sin(y)
                        ------
                          y

julia> trigsimp(m"sin(x)^2 + cos(x)^2")

                         1
                         
julia> typeof(ans)
Maxima.MExpr
```
A Maxima expression may be parsed as a Julia expression using the `parse` function and a Julia expression may be used to construct a Maxima expression using the `MExpr` constructor.

```julia
julia> mexpr = m"%e^(%pi*x)"

                              %pi x
                            %e

julia> expr = parse(mexpr)
:(e ^ (x * π))

julia> MExpr(expr)

                              %pi x
                            %e
```
Many Maxima functions can be used directly on Julia expressions and this conversion process is hidden in the background. More detailed documentation will be coming soon

## The Maxima REPL

Maxima.jl extends the Julia repl with a Maxima evaluation mode

```julia
julia>         # press ']'

maxima> integrate(sin(x), x);

                        - cos(x)

maxima> expand((a + b)^2);

                       2          2
                      a  + a b + b

maxima> a: 1.0$

maxima> a;
          
                          1.0

julia>               # press backspace to escape maxima mode
```


