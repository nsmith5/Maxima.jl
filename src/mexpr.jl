#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

export MExpr,
       @m_str,
       parse,
       mcall,
       convert,
       error,
       MaximaError,
       MaximaSyntaxError,
       ==,
       getindex

import Base: parse,
             convert,
             error,
             ==,
             getindex

type MaximaError <: Exception
	errstr::Compat.String
end

Base.showerror(io::IO, err::MaximaError) = print(io, err.errstr)

type MaximaSyntaxError <: Exception
	errstr::Compat.String
end

Base.showerror(io::IO, err::MaximaSyntaxError) = print(io, err.errstr)

function show_unquoted(io::IO, ex::Expr , indent::Int, prec::Int)
    head, args, nargs = ex.head, ex.args, length(ex.args)
    emphstate = Base.typeemphasize(io)
    show_type = true
    if (ex.head == :(=) || ex.head == :line ||
        ex.head == :boundscheck ||
        ex.head == :gotoifnot ||
        ex.head == :return)
        show_type = false
    end
    if !emphstate && ex.typ === Any
        show_type = false
    end
    # dot (i.e. "x.y"), but not compact broadcast exps
    if head === :(.) && !is_expr(args[2], :tuple)
        Base.show_unquoted(io, args[1], indent + indent_width)
        print(io, '.')
        if is_quoted(args[2])
            Base.show_unquoted(io, unquoted(args[2]), indent + indent_width)
        else
            print(io, '(')
            Base.show_unquoted(io, args[2], indent + indent_width)
            print(io, ')')
        end

    # infix (i.e. "x<:y" or "x = y")
    elseif (head in Base.expr_infix_any && nargs==2) || (head === :(:) && nargs==3)
        func_prec = Base.operator_precedence(head)
        head_ = head in Base.expr_infix_wide ? " $head " : head
        if func_prec <= prec
            Base.show_enclosed_list(io, '(', args, head_, ')', indent, func_prec, true)
        else
            Base.show_list(io, args, head_, indent, func_prec, true)
        end

    # list (i.e. "(1,2,3)" or "[1,2,3]")
    elseif haskey(Base.expr_parens, head)               # :tuple/:vcat
        op, cl = Base.expr_parens[head]
        if head === :vcat
            sep = ";"
        elseif head === :hcat || head === :rowj
            sep = " "
        else
            sep = ","
        end
        head !== :row && print(io, op)
        Base.show_list(io, args, sep, indent)
        if (head === :tuple || head === :vcat) && nargs == 1
            print(io, sep)
        end
        head !== :row && print(io, cl)

    # function call
    elseif head === :call && nargs >= 1
        func = args[1]
        fname = isa(func,GlobalRef) ? func.name : func
        func_prec = Base.operator_precedence(fname)
        if func_prec > 0 || fname in Base.uni_ops
            func = fname
        end
        func_args = args[2:end]

        if (in(ex.args[1], (GlobalRef(Base, :box), :throw)) ||
            Base.ismodulecall(ex) ||
            (ex.typ === Any && Base.is_intrinsic_expr(ex.args[1])))
            show_type = false
        end
        if show_type
            prec = prec_decl
        end

        # scalar multiplication (i.e. "100x")
        if (func === :* &&
            length(func_args)==2 && isa(func_args[1], Real) && isa(func_args[2], Symbol))
            if func_prec <= prec
                Base.show_enclosed_list(io, '(', func_args, "*", ')', indent, func_prec)
            else
                Base.show_list(io, func_args, "*", indent, func_prec)
            end

        # unary operator (i.e. "!z")
        elseif isa(func,Symbol) && func in Base.uni_ops && length(func_args) == 1
            Base.show_unquoted(io, func, indent)
            if isa(func_args[1], Expr) || func_args[1] in Base.all_ops
                Base.show_enclosed_list(io, '(', func_args, ",", ')', indent, func_prec)
            else
                Base.show_unquoted(io, func_args[1])
            end

        # binary operator (i.e. "x + y")
        elseif func_prec > 0 # is a binary operator
            na = length(func_args)
			if (na == 2 || (na > 2 && func in (:+, :++, :*))) && all([!isa(a, Expr) || a.head !== :... for a in func_args])
                sep = " $func "
                if func_prec <= prec
                    Base.show_enclosed_list(io, '(', func_args, sep, ')', indent, func_prec, true)
                else
                    Base.show_list(io, func_args, sep, indent, func_prec, true)
                end
            elseif na == 1
                # 1-argument call to normally-binary operator
                op, cl = Base.expr_calls[head]
                print(io, "(")
                Base.show_unquoted(io, func, indent)
                print(io, ")")
                Base.show_enclosed_list(io, op, func_args, ",", cl, indent)
            else
                Base.show_call(io, head, func, func_args, indent)
            end

        # normal function (i.e. "f(x,y)")
        else
            Base.show_call(io, head, func, func_args, indent)
        end

    # other call-like expressions ("A[1,2]", "T{X,Y}", "f.(X,Y)")
    elseif haskey(expr_calls, head) && nargs >= 1  # :ref/:curly/:calldecl/:(.)
        funcargslike = head == :(.) ? ex.args[2].args : ex.args[2:end]
        Base.show_call(io, head, ex.args[1], funcargslike, indent)

    # comprehensions
    elseif (head === :typed_comprehension || head === :typed_dict_comprehension) && length(args) == 2
        isdict = (head === :typed_dict_comprehension)
        isdict && print(io, '(')
        Base.show_unquoted(io, args[1], indent)
        isdict && print(io, ')')
        print(io, '[')
        Base.show_generator(io, args[2], indent)
        print(io, ']')

    elseif (head === :comprehension || head === :dict_comprehension) && length(args) == 1
        print(io, '[')
        Base.show_generator(io, args[1], indent)
        print(io, ']')

    elseif (head === :generator && length(args) >= 2) || (head === :flatten && length(args) == 1)
        print(io, '(')
        Base.show_generator(io, ex, indent)
        print(io, ')')

    elseif head === :filter && length(args) == 2
        Base.show_unquoted(io, args[2], indent)
        print(io, " if ")
        Base.show_unquoted(io, args[1], indent)

    elseif head === :ccall
        Base.show_unquoted(io, :ccall, indent)
        Base.show_enclosed_list(io, '(', args, ",", ')', indent)

    # comparison (i.e. "x < y < z")
    elseif head === :comparison && nargs >= 3 && (nargs&1==1)
        comp_prec = minimum(Base.operator_precedence, args[2:2:end])
        if comp_prec <= prec
            Base.show_enclosed_list(io, '(', args, " ", ')', indent, comp_prec)
        else
            Base.show_list(io, args, " ", indent, comp_prec)
        end

    # function calls need to transform the function from :call to :calldecl
    # so that operators are printed correctly
    elseif head === :function && nargs==2 && is_expr(args[1], :call)
        Base.show_block(io, head, Expr(:calldecl, args[1].args...), args[2], indent)
        print(io, "end")

    elseif head === :function && nargs == 1
        print(io, "function ", args[1], " end")

    # block with argument
    elseif head in (:for,:while,:function,:if) && nargs==2
        Base.show_block(io, head, args[1], args[2], indent)
        print(io, "end")

    elseif head === :module && nargs==3 && isa(args[1],Bool)
        Base.show_block(io, args[1] ? :module : :baremodule, args[2], args[3], indent)
        print(io, "end")

    # type declaration
    elseif head === :type && nargs==3
        Base.show_block(io, args[1] ? :type : :immutable, args[2], args[3], indent)
        print(io, "end")

    elseif head === :bitstype && nargs == 2
        print(io, "bitstype ")
        Base.show_list(io, args, ' ', indent)

    # empty return (i.e. "function f() return end")
    elseif head === :return && nargs == 1 && args[1] === nothing
        print(io, head)

    # type annotation (i.e. "::Int")
    elseif head === Symbol("::") && nargs == 1
        print(io, "::")
        Base.show_unquoted(io, args[1], indent)

    # var-arg declaration or expansion
    # (i.e. "function f(L...) end" or "f(B...)")
    elseif head === :(...) && nargs == 1
        Base.show_unquoted(io, args[1], indent)
        print(io, "...")

    elseif (nargs == 0 && head in (:break, :continue))
        print(io, head)

    elseif (nargs == 1 && head in (:return, :abstract, :const)) ||
                          head in (:local,  :global, :export)
        print(io, head, ' ')
        Base.show_list(io, args, ", ", indent)

    elseif head === :macrocall && nargs >= 1
        # Use the functional syntax unless specifically designated with prec=-1
        if prec >= 0
            Base.show_call(io, :call, ex.args[1], ex.args[2:end], indent)
        else
            Base.show_list(io, args, ' ', indent)
        end

    elseif head === :typealias && nargs == 2
        print(io, "typealias ")
        Base.show_list(io, args, ' ', indent)

    elseif head === :line && 1 <= nargs <= 2
        Base.show_linenumber(io, args...)

    elseif head === :if && nargs == 3     # if/else
        Base.show_block(io, "if",   args[1], args[2], indent)
        Base.show_block(io, "else", args[3], indent)
        print(io, "end")

    elseif head === :try && 3 <= nargs <= 4
        Base.show_block(io, "try", args[1], indent)
        if is_expr(args[3], :block)
            Base.show_block(io, "catch", args[2] === false ? Any[] : args[2], args[3], indent)
        end
        if nargs >= 4 && is_expr(args[4], :block)
            Base.show_block(io, "finally", Any[], args[4], indent)
        end
        print(io, "end")

    elseif head === :let && nargs >= 1
        Base.show_block(io, "let", args[2:end], args[1], indent); print(io, "end")

    elseif head === :block || head === :body
        Base.show_block(io, "begin", ex, indent); print(io, "end")

    elseif head === :quote && nargs == 1 && isa(args[1],Symbol)
        Base.show_unquoted_quote_expr(io, args[1], indent, 0)

    elseif head === :gotoifnot && nargs == 2
        print(io, "unless ")
        Base.show_list(io, args, " goto ", indent)

    elseif head === :string && nargs == 1 && isa(args[1], AbstractString)
        Base.show(io, args[1])

    elseif head === :null
        print(io, "nothing")

    elseif head === :kw && length(args)==2
        Base.show_unquoted(io, args[1], indent+indent_width)
        print(io, '=')
        Base.show_unquoted(io, args[2], indent+indent_width)

    elseif head === :string
        print(io, '"')
        for x in args
            if !isa(x,AbstractString)
                print(io, "\$(")
                if isa(x,Symbol) && !(x in quoted_syms)
                    print(io, x)
                else
                    Base.show_unquoted(io, x)
                end
                print(io, ")")
            else
                escape_string(io, x, "\"\$")
            end
        end
        print(io, '"')

    elseif (head === :&#= || head === :$=#) && length(args) == 1
        print(io, head)
        a1 = args[1]
        parens = (isa(a1,Expr) && a1.head !== :tuple) || (isa(a1,Symbol) && Base.isoperator(a1))
        parens && print(io, "(")
        Base.show_unquoted(io, a1)
        parens && print(io, ")")

    # transpose
    elseif (head === Symbol('\'') || head === Symbol(".'")) && length(args) == 1
        if isa(args[1], Symbol)
            Base.show_unquoted(io, args[1])
        else
            print(io, "(")
            Base.show_unquoted(io, args[1])
            print(io, ")")
        end
        print(io, head)

    elseif head === :import || head === :importall || head === :using
        print(io, head)
        first = true
        for a = args
            if first
                print(io, ' ')
                first = false
            else
                print(io, '.')
            end
            if a !== :.
                print(io, a)
            end
        end
    elseif head === :meta && length(args) >= 2 && args[1] === :push_loc
        print(io, "# meta: location ", join(args[2:end], " "))
        show_type = false
    elseif head === :meta && length(args) == 1 && args[1] === :pop_loc
        print(io, "# meta: pop location")
        show_type = false
    # print anything else as "Expr(head, args...)"
    else
        show_type = false
        if emphstate && ex.head !== :lambda && ex.head !== :method
            io = IOContext(io, :TYPEEMPHASIZE => false)
            emphstate = false
        end
        print(io, "\$(Expr(")
        show(io, ex.head)
        for arg in args
            print(io, ", ")
            show(io, arg)
        end
        print(io, "))")
    end
    show_type && Base.show_expr_type(io, ex.typ, emphstate)
    nothing
end

function unparse(expr::Expr)
	a = IOBuffer()
	show_unquoted(a, expr, 0, 0)
	return takebuf_string(a)
end

"""

A Maxima expression

## Summary:

type MExpr <: Any

## Fields:

str :: String
"""
type MExpr
	str::Compat.String
end

macro m_str(str)
	MExpr(str)
end

const m_to_jl = Dict("%e" => "e",
    "%pi"   =>  "π",
    "%i"    =>  "im",
    "%gamma" => "eulergamma",
    "%phi"  =>  "φ",
    "inf"   =>  "Inf",
    "minf"  =>  "-Inf")

const jl_to_m = Dict("e" => "%e",
    "eu" => "%e",
    "pi" => "%pi",
    "π" => "%pi",
    "γ" => "%gamma",
    "eulergamma" => "%gamma",
    "golden" => "%phi",
    "φ" => "%phi",
    "im" => "%i",
    "Inf" => "inf")

function _subst(a, b, expr)
    mstr = "subst($a, $b, '($expr))" |> MExpr
	mstr = mcall(mstr)
	return mstr.str
end

"""
    MExpr(expr::Expr)

Convert Julia expression to Maxima expression

## Examples
```julia
julia> MExpr(:(sin(x*im) + cos(y*φ)))

                           cos(%phi y) + %i sinh(x)

```
"""
function MExpr(expr::Expr)
	#str = "$expr"
    str = unparse(expr)
    for key in keys(jl_to_m)
        str = _subst(jl_to_m[key], key, str)
    end
    MExpr(str)
end

"""
    parse(mexpr::MExpr)

Parse a Maxima expression into a Julia expression

## Examples
```julia
julia> parse(m\"sin(%i*x)\")
:(im * sinh(x))

```
"""
function parse(m::MExpr)
    str = m.str
    for key in keys(m_to_jl)
        str = _subst(m_to_jl[key], key, str)
    end
    parse(str)
end

convert(::Type{Compat.String}, m::MExpr) = m.str
convert(::Type{Expr}, m::MExpr) = parse(m)
if VERSION < v"0.5.0"
    convert(::Type{UTF8String}, m::MExpr) = UTF8String(m.str)
    convert(::Type{ASCIIString}, m::MExpr) = ASCIIString(m.str)
end

function error(mexpr::MExpr)
    input("$(mexpr.str);")
    output()
    return take!(errchannel)
end

"""
	mcall(m::MExpr)

Evaluate a Maxima expression.

## Examples
```julia
julia> m\"integrate(sin(x), x)\"

                             integrate(sin(x), x)

julia> mcall(ans)

                                   - cos(x)

```
"""
function mcall(m::MExpr)
    put!(inputchannel, "$(m.str);")
    output = take!(outputchannel)
    err = take!(errchannel)
    if err == 0
        output = replace(output, '\n', "")
        output = replace(output, " ", "")
        return MExpr(output)
    elseif err == 1
		input("errormsg()\$")
		err = take!(errchannel)
		@assert err == 0
		output = take!(outputchannel)
        throw(MaximaError(output))
    elseif err == 2
        throw(MaximaSyntaxError(output))
    end
end

"""
	mcall{T}(expr::T)

Evaluate a Julia expression or string using the Maxima interpretor and convert
output back into the input type

## Examples
```julia
julia> mcall(\"integrate(sin(y)^2, y)\")
\"(y-sin(2*y)/2)/2\"

julia> mcall(:(integrate(1/(1+x^2), x)))
:(atan(x))

```
"""
function mcall{T}(expr::T)
    mexpr = MExpr(expr)
    return convert(T, mcall(mexpr))
end

function ==(m::MExpr, n::MExpr)
    return mcall(MExpr("is($m = $n)")) |> parse |> eval
end

function getindex(m::MExpr, i)
    return MExpr("$m[$i]") |> mcall
end
