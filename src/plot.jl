# Plotting utilities of Maxima

function plot2d(m::MExpr, x, xmin, xmax)
    ## TODO: add keyword arguments as well
    mcall(m"plot2d($m, [$x, $xmin, $xmax)")
    return nothing
end

function plot3d(m::MExpr, x, xmin, xmax, y, ymin, ymax)
    ## TODO: add keyword argument support
    mcall(m"plot3d($m, [$x, $xmin, $xmax], [$y, $ymin, $ymax])")
    return nothing
end
    
