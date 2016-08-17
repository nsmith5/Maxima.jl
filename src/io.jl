export string,
       show

import Base: string,
             show

string(m::MExpr) = m.str
show(io::IO, m::MExpr) = print(io, m.str)

@compat function show(io::IO, ::MIME"text/plain", m::MExpr)
    mcall(m"display2d: true")
	input("'($m);")
	str = output()
    str = rstrip(str, '\n')
	mcall(m"display2d: false")
	print(io, str)
end

@compat function show(io::IO, ::MIME"text/latex", m::MExpr)
    input("tex('($m))\$")
    texstr = output()
    print(io, texstr)
end
