# 	This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

export string,
       show

import Base: string,
             show


string(m::MExpr) = convert(String, m)
show(io::IO, m::MExpr) = print(io, convert(String, m))


function show(io::IO, ::MIME"text/plain", m::MExpr)
    input = "'(" * replace(convert(String, m), r";" => ");\n'(") * ")"
    write(ms.input, "$(replace(input, r";" => "\$"))\$\n print(ascii(4))\$")
    out = (readuntil(ms.output, EOT) |> String
                                     |> str -> rstrip(str, EOT))
    if occursin(synerr, out) || occursin(maxerr, out)
        @warn "Invalid Maxima expression"
        print(io, out)
    else
        mcall(m"display2d: true")
        write(ms, replace(input, r";" => "; print(ascii(3))\$ "))
        str = read(ms)
        str = rstrip(str, '\n')
        mcall(m"display2d: false")
        sp = split(str, "\x03")
        for k in 1:length(sp)
            print(io, sp[k])
        end
    end
end


function show(io::IO, ::MIME"text/latex", m::MExpr)
    check = "'(" * replace(convert(String, m), r";" => ")\$\n'(") * ")"
    write(ms.input, "$check\$\n print(ascii(4))\$")
    out = (readuntil(ms.output, EOT) |> String
                                     |> str -> rstrip(str, EOT))
    if occursin(synerr, out) || occursin(maxerr, out)
        @warn "Invalid Maxima expression"
        print(io, out)
    else
        write(ms, "tex('("*replace(convert(String, m), r";" => "))\$\ntex('(") * "))")
        texstr = read(ms)
        print(io, replace(texstr, r"\nfalse\n" => ""))
    end
end
