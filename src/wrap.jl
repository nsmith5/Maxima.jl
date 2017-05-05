#kAttemp at PyPlot style wrapping

export alias, aliases, allbut, args, atom, box, boxchar
const max_funcs = (:alias, :aliases, :allbut, :args, :atom, :box, :boxchar)

for f in max_funcs
    sf = string(f)
    @eval function $f(args...)
        length(args) > 0 ? T = typeof(args[1]) : T = MExpr
        sargs = join(args, ", ")
        out = MExpr($sf*"("*sargs*")") |> mcall
        return convert(T, out)
    end
end 
