# Getting Started

## Maxima Expressions

Maxima.jl revolves around the Maxima expression type: `MExpr`. Maxima expressions can be constructed using a constructor or a string macro. 

```@repl
using Maxima # hide
MExpr("sin(x)/x")
m"integrate(1 + x^2, x)"
```

Maxima expressions don't neccessarily need to be valid Maxima, but a warning will be printed when the expression is printed. 

```@repl
using Maxima # hide
m"1+"
m"1/0"
```

Maxima expressions can be evaluated using `mcall`.

```@repl
using Maxima # hide
m"integrate(1/(1+x^2), x)"
mcall(ans)
mcall(m"1+")
```



## 






