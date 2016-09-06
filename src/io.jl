# This file is part of Maxima.jl. It is licensed under the MIT license

export string,
       show

import Base: string,
             show

string(m::MExpr) = m.str
show(io::IO, m::MExpr) = print(io, m.str)

@compat function show(io::IO, ::MIME"text/plain", m::MExpr)
    if error(m) == 0
        mcall(m"display2d: true")
	    input("'($m);")
	    str = output()
        str = rstrip(str, '\n')
	    mcall(m"display2d: false")
	    print(io, str)
    elseif error(m) == 1
        print(io, "Maxima Error")
    elseif error(m) == 2
        print(io, "Maxima Syntax Error")
    end
end

@compat function show(io::IO, ::MIME"text/latex", m::MExpr)
    if error(m) == 0    
        input("tex('($m))\$")
        texstr = output()
        print(io, texstr)
    elseif error(m) == 1
        print(io, "Maxima Error")
    elseif error(m) == 2
        print(io, "Maxima Syntax Error")
    end
end
