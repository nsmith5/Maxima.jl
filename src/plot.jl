# Plotting utilities of Maxima

export plot2d,
       plot3d

"""
    kwarg_convert(kwarg)

Convert keyward arguments into the form of Maxima keyword arguments

Ex:

x = (1, 2) => [x, 1, 2]
xlabel=\"x axis\" => [xlabel, \"x axis\"] 
"""
function kwarg_convert(kwarg)
    str = "[$(kwarg[1]),"
    if isa(kwarg[2], Union{Tuple, Array})     
        for thing in kwarg[2]
            str = str*" $thing,"
        end
    elseif isa(kwarg[2], Compat.String)
        str = str*" \"$(kwarg[2])\","
    else
        str = str*" $(kwarg[2]),"
    end
    str = str[1:end-1]
    str = str*"]"
    return str
end

function plot2d(m::MExpr; kwargs...)
    args = String[]
    for kwarg in kwargs
        arg = kwarg_convert(kwarg)
        push!(args, arg)
    end
    str = "plot2d($m,"
    for arg in args
        str = str*" $arg,"
    end
    str = str[1:end - 1]*")"    
    mcall(MExpr(str))    
    return nothing
end

function plot2d(m::Array{MExpr}; kwargs...)
    str = "plot2d(["
    for expr in m
        str = str*"$expr,"
    end
    str = str[1:end-1]*"], "
    args = String[]
    for kwarg in kwargs
        arg = kwarg_convert(kwarg)
        push!(args, arg)
    end
    for arg in args
        str = str*" $arg,"
    end
    str = str[1:end-1]*")"
    mcall(MExpr(str))
    return nothing
end

function contour_plot(m::MExpr; kwargs...)
    args = String[]
    for kwarg in kwargs
        arg = kwarg_convert(kwarg)
        push!(args, arg)
    end
    str = "plot2d($m,"
    for arg in args
        str = str*" $arg,"
    end
    str = str[1:end - 1]*")"    
    mcall(MExpr(str))    
    return nothing
end

function plot3d(m::MExpr; kwargs...)
    args = String[]
    for kwarg in kwargs
        arg = kwarg_convert(kwarg)
        push!(args, arg)
    end
    str = "plot3d($m,"
    for arg in args
        str = str*" $arg,"
    end
    str = str[1:end - 1]*")"    
    mcall(MExpr(str))    
    return nothing 
end
    
