# 	This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

export string,
       show

import Base: string,
             show

string(m::MExpr) = m.str
show(io::IO, m::MExpr) = print(io, m.str)

@compat function show(io::IO, ::MIME"text/plain", m::MExpr)
	# TODO: reimplement error handling here
	mcall(m"display2d: true")
	write(ms, "'($m)")
	str = read(ms)
    str = rstrip(str, '\n')
	mcall(m"display2d: false")
	print(io, str)
end

@compat function show(io::IO, ::MIME"text/latex", m::MExpr)
    # TODO: and here...
	write(ms, "tex('($m))\$")
    texstr = read(ms)
    print(io, texstr)
end
