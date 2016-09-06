var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Maxima.jl-1",
    "page": "Home",
    "title": "Maxima.jl",
    "category": "section",
    "text": "Symbolic Computations in Julia using MaximaMaxima.jl is a Julia package for performing symbolic computations using Maxima.  Maxima is computer algebra software that provides a free and open source  alternative to proprietary software such as Mathematica, Maple and others."
},

{
    "location": "index.html#Features-1",
    "page": "Home",
    "title": "Features",
    "category": "section",
    "text": "Contains a full Maxima repl that can be entered from the Julia repl\nPretty I/O for Maxima expressions including Latex when using IJulia and formatted '2d' plain text in the repl\nBasic translation of expressions between Maxima and Julia\nWrapper functions for much of the Maxima standard library that operate on Maxima expressions, Julia expressions and strings\nPlotting via Maxima's gnuplot functionality"
},

{
    "location": "index.html#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "Maxima.jl requires a working Maxima installation. Downloads and installation  instructions can be found here. If you're  running a Linux operating system take a look in your local repositories. Once Maxima is installed, check that it is accessible from the Julia shell.julia> run(`maxima`)A Maxima shell should open and you can quit it by entering quit(); into the  shell.Maxima.jl can be installed using the Julia package manager by cloning the  repository from github. julia> Pkg.clone(\"https://github.com/nsmith5/Maxima.jl.git\")\nMaxima.jl currently supports Julia versions >= 0.4.0. "
},

{
    "location": "man/getting_started.html#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": ""
},

{
    "location": "man/getting_started.html#Getting-Started-1",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "section",
    "text": ""
},

{
    "location": "man/getting_started.html#Installation-1",
    "page": "Getting Started",
    "title": "Installation",
    "category": "section",
    "text": "Maxima.jl is not a registered package as yet and so it must be cloned from the  github repository.Pkg.clone(\"https://github.com/nsmith5/Maxima.jl.git\")Maxima.jl also requires a working installation of Maxima. Maxima can be  installed by grabbing the appropriate installer  here. On most Linux distributions, you  can also install Maxima through your distribution's repositories. "
},

{
    "location": "man/getting_started.html#Usage-1",
    "page": "Getting Started",
    "title": "Usage",
    "category": "section",
    "text": ""
},

{
    "location": "lib/basics.html#",
    "page": "Basics",
    "title": "Basics",
    "category": "page",
    "text": ""
},

{
    "location": "lib/basics.html#Maxima.MExpr",
    "page": "Basics",
    "title": "Maxima.MExpr",
    "category": "Type",
    "text": "A Maxima expression\n\nSummary:\n\ntype MExpr <: Any\n\nFields:\n\nstr :: String\n\n\n\n"
},

{
    "location": "lib/basics.html#Maxima.MExpr-Tuple{Expr}",
    "page": "Basics",
    "title": "Maxima.MExpr",
    "category": "Method",
    "text": "MExpr(expr::Expr)\n\nConvert Julia expression to Maxima expression\n\nExamples\n\njulia> MExpr(:(sin(x*im) + cos(y*φ)))\n \n                           cos(%phi y) + %i sinh(x)\n\n\n\n\n"
},

{
    "location": "lib/basics.html#Base.parse-Tuple{Maxima.MExpr}",
    "page": "Basics",
    "title": "Base.parse",
    "category": "Method",
    "text": "parse(mexpr::MExpr)\n\nParse a Maxima expression into a Julia expression\n\nExamples\n\njulia> parse(m\"sin(%i*x)\")\n:(im * sinh(x))\n\n\n\n\n"
},

{
    "location": "lib/basics.html#Maxima.mcall-Tuple{Maxima.MExpr}",
    "page": "Basics",
    "title": "Maxima.mcall",
    "category": "Method",
    "text": "mcall(m::MExpr)\n\nEvaluate a Maxima expression.\n\nExamples\n\njulia> m\"integrate(sin(x), x)\"\n \n                             integrate(sin(x), x)\n\njulia> mcall(ans)\n \n                                   - cos(x)\n\n\n\n\n"
},

{
    "location": "lib/basics.html#Maxima.mcall-Tuple{T}",
    "page": "Basics",
    "title": "Maxima.mcall",
    "category": "Method",
    "text": "mcall{T}(expr::T)\n\nEvaluate a Julia expression or string using the Maxima interpretor and convert output back into the input type\n\nExamples\n\njulia> mcall(\"integrate(sin(y)^2, y)\")\n\"(y-sin(2*y)/2)/2\"\n\njulia> mcall(:(integrate(1/(1+x^2), x)))\n:(atan(x))\n\n\n\n\n"
},

{
    "location": "lib/basics.html#Basics-1",
    "page": "Basics",
    "title": "Basics",
    "category": "section",
    "text": "Modules = [Maxima]\nPages = [\"mexpr.jl\"]"
},

{
    "location": "lib/simplify.html#",
    "page": "Simplification",
    "title": "Simplification",
    "category": "page",
    "text": ""
},

{
    "location": "lib/simplify.html#Base.expand-Tuple{String}",
    "page": "Simplification",
    "title": "Base.expand",
    "category": "Method",
    "text": "expand(expr)\n\nExpand expression. \n\nExamples\n\njulia> expand(m\"(a + b)^2\")\n \n                                 2            2\n                                b  + 2 a b + a\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Base.factor-Tuple{T}",
    "page": "Simplification",
    "title": "Base.factor",
    "category": "Method",
    "text": "factor{T}(expr::T)\n\nFactorize polynomial expression\n\nExamples\n\njulia> factor(:(x^2 + 2x + 1))\n:((x + 1) ^ 2)\n\njulia> factor(MExpr(\"a^2 - b^2\"))\n \n                                (a - b) (b + a)\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Base.float-Tuple{Union{Expr,Maxima.MExpr,String}}",
    "page": "Simplification",
    "title": "Base.float",
    "category": "Method",
    "text": "float(expr)\n\nConvert rational numbers into floating point numbers in expression.\n\nExamples\n\njulia> float(m\"1/3*x\")\n \n                             0.3333333333333333 x\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.demoivre-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.demoivre",
    "category": "Method",
    "text": "demoivre(expr)\n\nBreak exponential terms into hyperbolic and trigonometric functions. Roughly the  opposite in function to exponentialize\n\nExamples\n\njulia> demoivre(m\"exp(a + %i * b)\")\n \n                             a\n                           %e  (%i sin(b) + cos(b))\n\njulia> exponentialize(ans)\n \n                         %i b     - %i b     %i b     - %i b\n                    a  %e     + %e         %e     - %e\n                  %e  (----------------- + -----------------)\n                               2                   2\n\njulia> expand(ans)\n \n                                    %i b + a\n                                  %e\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.exponentialize-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.exponentialize",
    "category": "Method",
    "text": "exponentialize(expr)\n\nExpress expression in terms of exponents as much as possible\n\nExamples\n\njulia> exponentialize(m\"sin(x)\")\n \n                                   %i x     - %i x\n                             %i (%e     - %e      )\n                           - ----------------------\n                                       2\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.gfactor-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.gfactor",
    "category": "Method",
    "text": "gfactor{T}(expr::T)\n\nFactorize complex polynomial expression\n\nExamples\n\njulia> gfactor(:(z^2 + 2*im*z - 1))\n:((z + im) ^ 2)\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.imagpart-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.imagpart",
    "category": "Method",
    "text": "imagpart(expr)\n\nFind the imaginary part of a complex expression.\n\nExamples\n\njulia> realpart(MExpr(\"a + %i*b\"))\n\n                            b\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.logcontract-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.logcontract",
    "category": "Method",
    "text": "logcontract{T}(expr::T)\n\nContract logarithms in expression\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.makefact-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.makefact",
    "category": "Method",
    "text": "makefact{T}(expr::T)\n\nConvert expression into factorial form.\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.makegamma-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.makegamma",
    "category": "Method",
    "text": "makegamma{T}(expr::T)\n\nConvert factorial to gamma functions in expression\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.polarform-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.polarform",
    "category": "Method",
    "text": "polarform(expr)\n\nPut a complex expression into polarform\n\nExamples\n\njulia> polarform(m\"a + %i*b\")\n \n                              2    2    %i atan2(b, a)\n                        sqrt(b  + a ) %e\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.radcan-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.radcan",
    "category": "Method",
    "text": "radcan{T}(expr::T)\n\nSimplify radicals in expression.\n\nExamples\n\njulia> radcan(:(sqrt(x/y)))\n:(sqrt(x)/sqrt(y))\n\njulia> radcan(m\"sqrt(x/y)\")\n \n                                    sqrt(x)\n                                    -------\n                                    sqrt(y)\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.ratsimp-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.ratsimp",
    "category": "Method",
    "text": "ratsimp{T}(expr::T)\n\nSimplify expression.\n\nExamples\n\njulia> ratsimp(\"a + b/c\")\n\"(a*c+b)/c\"\n\njulia> ratsimp(:(sin(asin(a + b/c))))\n:((a * c + b) / c)\n\njulia> ratsimp(m\"%e^log(x)\")\n \n                                       x\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.realpart-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.realpart",
    "category": "Method",
    "text": "realpart(expr)\n\nFind the real part of a complex expression\n\nExamples\n\njulia> realpart(MExpr(\"a + %i*b\"))\n\n                            a\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.rectform-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.rectform",
    "category": "Method",
    "text": "rectform(expr)\n\nPut complex expression in rectangular form\n\nExamples\n\njulia> rectform(:(R*e^(im*θ)))\n:(R * im * sin(θ) + R * cos(θ))\n\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.subst-Tuple{Any,Any,T}",
    "page": "Simplification",
    "title": "Maxima.subst",
    "category": "Method",
    "text": "subst(a, b, expr)\n\nSubstitute a for b in expr.\n\nExamples\n\njulia> subst(:a, :b, :(a^2 + b^2))\n:(2 * b ^ 2)\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.trigexpand-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.trigexpand",
    "category": "Method",
    "text": "trigexpand(expr)\n\nExpand out trig functions in expression\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.trigrat-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.trigrat",
    "category": "Method",
    "text": "trigrat(expr)\n\nConvert expression into a canonical trigonometric form\n\nExamples\n\njulia> trigrat(:(exp(im*x) + exp(-im*x)))\n:(2 * cos(x))\n\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.trigreduce-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.trigreduce",
    "category": "Method",
    "text": "trigreduce(expr)\n\nContract trigonometric functions\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.trigsimp-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.trigsimp",
    "category": "Method",
    "text": "trigsimp{T}(expr::T)\n\nSimplify trigonometric expression\n\nExamples\n\njulia> trigsimp(m\"sin(x)^2 + cos(x)^2\")\n \n                                       1\n\n\n\n"
},

{
    "location": "lib/simplify.html#Maxima.logexpand-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.logexpand",
    "category": "Method",
    "text": "logexpand{T}(expr::T)\n\nExpand logarithm terms in an expression\n\n\n\n"
},

{
    "location": "lib/simplify.html#Simplification-1",
    "page": "Simplification",
    "title": "Simplification",
    "category": "section",
    "text": "CurrentModule = MaximaModules = [Maxima]\nPages = [\"simplify.jl\"]"
},

]}
