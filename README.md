#  Maxima.jl  <div style="text-align: right"> [![][logo]][home-url]</div>

| **Documentation**           | **Build Status**            |
|:---------------------------:|:---------------------------:|
|[![][docs-img]][docs-url]    |[![travis-img]][travis-url] [![codecov-img]][codecov-url] |

*Symbolic Computations in Julia using Maxima*

Maxima.jl is a Julia package for performing symbolic computations using Maxima.
Maxima is computer algebra software that provides a free and open source
alternative to proprietary software such as Mathematica, Maple and others.

Checkout the [documentation](https://nsmith5.github.io/Maxima.jl) for details!

## Features

 - Contains a full Maxima repl that can be entered from the Julia repl
 - Pretty I/O for Maxima expressions including Latex when using IJulia and formatted '2d' plain text in the repl
 - Basic translation of expressions between Maxima and Julia
 - Wrapper functions for much of the Maxima standard library that operate on Maxima expressions, Julia expressions and strings
 - Plotting via Maxima's gnuplot functionality

## Installation

Maxima.jl can be installed using the Julia package manager by cloning the
repository from github. Maxima.jl currently supports version of Julia >= v0.4.0.

```julia
julia> Pkg.clone("https://github.com/nsmith5/Maxima.jl.git")

```

Maxima.jl requires a working Maxima installation. Downloads and installation
instructions can be found [here](http://maxima.sourceforge.net/). If you're
running a Linux operating system take a look in your local repositories.

Once Maxima is installed, check that it is accessible from the Julia shell.

```julia
julia> run(`maxima`)
```

A Maxima shell should open and you can quit it by entering `quit(); <return>` at the prompt.

[home-url]: https://github.com/nsmith5/Maxima.jl.git
[logo]: ./docs/src/assets/logo.png

[docs-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-url]: https://nsmith5.github.io/Maxima.jl/

[codecov-img]: https://codecov.io/gh/nsmith5/Maxima.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/nsmith5/Maxima.jl

[travis-img]: https://travis-ci.org/nsmith5/Maxima.jl.svg?branch=master
[travis-url]: https://travis-ci.org/nsmith5/Maxima.jl
