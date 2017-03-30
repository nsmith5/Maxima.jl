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
    "text": "Maxima.jl can be installed using the Julia package manager by cloning the  repository from github. Maxima.jl currently supports version of Julia >= v0.4.0.julia> Pkg.clone(\"https://github.com/nsmith5/Maxima.jl.git\")\nMaxima.jl requires a working Maxima installation. Downloads and installation  instructions can be found here. If you're  running a Linux operating system take a look in your local repositories. Once Maxima is installed, check that it is accessible from the Julia shell.julia> run(`maxima`)A Maxima shell should open and you can quit it by entering quit(); <return> at the prompt."
},

{
    "location": "man/manual.html#",
    "page": "Manual",
    "title": "Manual",
    "category": "page",
    "text": ""
},

{
    "location": "man/manual.html#Getting-Started-1",
    "page": "Manual",
    "title": "Getting Started",
    "category": "section",
    "text": "To start using Maxima.jl, fire up a repl session and load the package.julia> using Maxima\n\njulia> Connecting Maxima to server on port 8080In the backend, Maxima.jl connects to a Maxima session over a TCP socket, so you'll see a statement print out about the port that Maxima connected on. You can play around a bit making Maxima expression with the @m_str string macro and evaluating them with mcall()using Maxima # hide\nm\"sin(x)/x\"\nm\"integrate(sin(x), x)\"\nmcall(ans)You can also interact with the Maxima session directly by entering the Maxima repl mode.julia>  # type ']'\n\nmaxima> 1 + 1;\n\n               2\n\nmaxima> sin(x)$\n\nmaxima>"
},

{
    "location": "man/manual.html#Maxima-Expressions-1",
    "page": "Manual",
    "title": "Maxima Expressions",
    "category": "section",
    "text": "Maxima.jl revolves around the Maxima expression type: MExpr. Maxima expressions can be constructed using a constructor or a string macro and evaluated with mcall.using Maxima # hide\nMExpr(\"sin(x)/x\")\nm\"integrate(1 + x^2, x)\"\nmcall(ans)Maxima expressions don't neccessarily need to be valid Maxima, but a warning will be printed when the expression is printed and an error will be thrown if the expression is evaluated.using Maxima # hide\nm\"1+\"\nmcall(ans)\nm\"1/0\"\nmcall(ans)Maxima.jl also allows for translation between Maxima and Julia expressions.julia> g = m\"atan(%i*%pi*y)\"\n\n                                %i atanh(%pi y)\n\njulia> parse(g)\n:(im * atanh(y * π))\n\njulia> exp = :(sin(π*im))\n:(sin(π * im))\n\njulia> mexp = MExpr(exp)\n\n                                 %i sinh(%pi)\n"
},

{
    "location": "man/manual.html#Basic-Library-1",
    "page": "Manual",
    "title": "Basic Library",
    "category": "section",
    "text": "Maxima.jl wraps many of the basic Maxima functions for convenience and these functions may be applied to Maxima expressions, Julia expressions or basic strings. By convention, the return type of these functions is determined by the most important input type. For instance, the integrate function returns the type of the integrand.julia> integrate(\"sin(x)\", :x)\n\"-cos(x)\"\n\njulia> integrate(:(sin(x)), \"x\")\n:(-cos(x))\n\njulia> integrate(m\"sin(x)\", 'x')\n\n					- cos(x)\nAs you can see, the basic library functions are very flexible about their argument types. Basically, as long as the argument string interpolates to the thing you want then it will work. For a list of all the functions that are wrapped take a look through the library reference section of the documentation."
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
    "text": "MExpr(expr::Expr)\n\nConvert Julia expression to Maxima expression\n\nExamples\n\njulia> MExpr(:(sin(x*im) + cos(y*φ)))\n\n                           cos(%phi y) + %i sinh(x)\n\n\n\n\n"
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
    "text": "mcall(m::MExpr)\n\nEvaluate a Maxima expression.\n\nExamples\n\njulia> m\"integrate(sin(x), x)\"\n\n                             integrate(sin(x), x)\n\njulia> mcall(ans)\n\n                                   - cos(x)\n\n\n\n\n"
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
    "location": "lib/simplify.html#Maxima.logexpand-Tuple{T}",
    "page": "Simplification",
    "title": "Maxima.logexpand",
    "category": "Method",
    "text": "logexpand{T}(expr::T)\n\nExpand logarithm terms in an expression\n\n\n\n"
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
    "text": "subst(a, b, expr)\n\nReplace a with b in expr.\n\nExamples\n\njulia> subst(:b, :a, :(a^2 + b^2))\n:(2 * b ^ 2)\n\n\n\n\n"
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
    "location": "lib/simplify.html#Simplification-1",
    "page": "Simplification",
    "title": "Simplification",
    "category": "section",
    "text": "The following functions are used to simplify expressions. CurrentModule = MaximaModules = [Maxima]\nPages = [\"simplify.jl\"]"
},

{
    "location": "lib/calculus.html#",
    "page": "Calculus",
    "title": "Calculus",
    "category": "page",
    "text": ""
},

{
    "location": "lib/calculus.html#Base.LinAlg.diff-Tuple{T,Any,Integer}",
    "page": "Calculus",
    "title": "Base.LinAlg.diff",
    "category": "Method",
    "text": "diff{T}(f, x, n)\n\nTake the nth order derivative of f with respect to x.\n\nfracpartial^n f(x)partial x^n\n\n\n\n"
},

{
    "location": "lib/calculus.html#Base.LinAlg.diff-Tuple{T,Any}",
    "page": "Calculus",
    "title": "Base.LinAlg.diff",
    "category": "Method",
    "text": "diff{T}(f, x)\n\nTake the derivative of f with respect to x\n\nfracpartial f(x )partial x\n\n\n\n"
},

{
    "location": "lib/calculus.html#Base.sum-Tuple{T,Any,Any,Any}",
    "page": "Calculus",
    "title": "Base.sum",
    "category": "Method",
    "text": "sum{T}(f::T, k, start, finish)\n\nCompute the sum,\n\n    sum_k=start^finish f(k)\n\nsimplifying the sum if possible.\n\nExamples\n\njulia> sum(m\"1/n^2\", :n, 1, \"inf\")\n\n                                        2\n                                     %pi\n                                     ----\n                                      6\n\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.ilt-Tuple{T,Any,Any}",
    "page": "Calculus",
    "title": "Maxima.ilt",
    "category": "Method",
    "text": "ilt{T}(f::T, s, t)\n\nCompute the inverse Laplace transform of f(s).\n\nt is the new variable and s is the old variable.\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.integrate-Tuple{T,Any,Any,Any}",
    "page": "Calculus",
    "title": "Maxima.integrate",
    "category": "Method",
    "text": "integrate{T}(f::T, x, a, b)\n\nEvaluate the definite integral of f with respect to x from a to b.\n\n    int_a^b f(x) dx\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.integrate-Tuple{T,Any}",
    "page": "Calculus",
    "title": "Maxima.integrate",
    "category": "Method",
    "text": "integrate{T}(f::T, x)\n\nEvaluate the indefinite integral\n\nint f(x) dx\n\nExamples\n\njulia> integrate(:(sin(x)), :x)\n:(-cos(x))\n\nSee also\n\nrisch\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.laplace-Tuple{T,Any,Any}",
    "page": "Calculus",
    "title": "Maxima.laplace",
    "category": "Method",
    "text": "laplace{T}(f::T, t, s)\n\nCompute the Laplace transform of f(t) where s is the new variable.\n\nmathcalLlbrace f rbrace (s) = int_0^infty f(t) e^-st dt\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.limit-Tuple{Maxima.MExpr,Any,Any,Any}",
    "page": "Calculus",
    "title": "Maxima.limit",
    "category": "Method",
    "text": "limit{T}(f, x, a, side)\n\nTake the left or right sided limit as x approaches a of f(x).\n\nside may be either \"plus\" or \"minus\" denoting the right and left sided limit respectively\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.limit-Tuple{T,Any,Any}",
    "page": "Calculus",
    "title": "Maxima.limit",
    "category": "Method",
    "text": "limit{T}(f, x, a)\n\nTake the limit as x approaches a of f(x)\n\nlim_x rightarrow a f(x)\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.product-Tuple{T,Any,Any,Any}",
    "page": "Calculus",
    "title": "Maxima.product",
    "category": "Method",
    "text": "product{T}(f::T, k, start, finish)\n\nCompute the product,\n\n    prod_k=start^finish f(k)\n\nsimplifying the product if possible.\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.risch-Tuple{T,Any}",
    "page": "Calculus",
    "title": "Maxima.risch",
    "category": "Method",
    "text": "risch{T}(f::T, x)\n\nCompute the indefinite integral of f with respect to x using the Risch algorithm\n\nSee also\n\nintegrate\n\n\n\n"
},

{
    "location": "lib/calculus.html#Maxima.taylor-Tuple{T,Any,Any,Integer}",
    "page": "Calculus",
    "title": "Maxima.taylor",
    "category": "Method",
    "text": "taylor{T}(f::T, x, x0, n)\n\nTaylor expand f(x) around x_0 to nth order\n\n\n\n"
},

{
    "location": "lib/calculus.html#Calculus-1",
    "page": "Calculus",
    "title": "Calculus",
    "category": "section",
    "text": "CurrentModule = MaximaModules = [Maxima]\nPages = [\"calculus.jl\"]"
},

{
    "location": "lib/plot.html#",
    "page": "Plotting",
    "title": "Plotting",
    "category": "page",
    "text": ""
},

{
    "location": "lib/plot.html#Maxima.plot2d-Tuple{Maxima.MExpr}",
    "page": "Plotting",
    "title": "Maxima.plot2d",
    "category": "Method",
    "text": "plot2d(m::MExpr, kwargs...)\n\nPlot a Maxima expression using Gnuplot.\n\nExamples\n\njulia> plot2d(m\"sin(x)\", x=(1,2), title=\"Sine Wave\") # Plot sine wave\n\n\n\n\n"
},

{
    "location": "lib/plot.html#Maxima.plot3d-Tuple{Maxima.MExpr}",
    "page": "Plotting",
    "title": "Maxima.plot3d",
    "category": "Method",
    "text": "plot3d(m::MExpr, kwargs...)\n\nMake 3d plot of the expression m\n\n\n\n"
},

{
    "location": "lib/plot.html#Maxima.contour_plot-Tuple{Maxima.MExpr}",
    "page": "Plotting",
    "title": "Maxima.contour_plot",
    "category": "Method",
    "text": "contour_plot(m::MExpr, kwargs...)\n\nMake a contour plot of the expression m\n\n\n\n"
},

{
    "location": "lib/plot.html#Maxima.kwarg_convert-Tuple{Any}",
    "page": "Plotting",
    "title": "Maxima.kwarg_convert",
    "category": "Method",
    "text": "kwarg_convert(kwarg)\n\nConvert keyward arguments into the form of Maxima keyword arguments\n\nEx:\n\nx = (1, 2) => [x, 1, 2] xlabel=\"x axis\" => [xlabel, \"x axis\"]\n\n\n\n"
},

{
    "location": "lib/plot.html#Plotting-1",
    "page": "Plotting",
    "title": "Plotting",
    "category": "section",
    "text": "CurrentModule = MaximaModules = [Maxima]\nPages = [\"plot.jl\"]"
},

]}
