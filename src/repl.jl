#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2019 Nathan Smith
import REPL.LineEdit
import ReplMaker

ans = nothing

"""
    finished(s)

Examine the buffer in the repl to see if the input is complete. In the Maxima
repl an expression is terminated with ';' or '\$'. '\$' is used to supress
printing the output.
"""
function finished(s)
    str = String(take!(copy(LineEdit.buffer(s))))
    if length(str) == 0
        return false
    elseif str[end] == ';' || str[end] == '$'
        return true
    else
        return false
    end
end

"""
    parse(input)

Called on valid input from the repl. Evaluates the maxima expression and
display in terminal.
"""
function parser(input)
    # '%' is a reference to the previous output in maxima. The real underlying
    # maxima server we're talking to has this variable corrupted by many
    # Maxima.jl commands between repl inputs so we emulate the behaviour
    # manually by substituting in the last output from a global variable 'ans'
    if '%' in input
        tail = last(input)                              # Chop the tail
        input = subst("$(ans)", "%", input[1:end-1])    # Substitute
        input = string(input, tail)                     # add the tail back
    end
    if !isempty(strip(input))
        global ans = MExpr(input[1:end-1]) |> mcall
        if input[end] == ';'
            display(ans)
        end
    end
end

"""
    replinit(repl)

Start up the Maxima repl mode.
"""
function repl_init(repl)
    ReplMaker.initrepl(
        parser,
        valid_input_checker=finished,
        prompt_text="maxima> ",
        prompt_color=:cyan,
        start_key=')',
        mode_name="maxima",
        repl=repl,
    )
end
