#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith
import REPL: LineEdit, REPLCompletions
import REPL

ans = nothing


"""
    finished(s)

Examine the buffer in the repl to see if the input is complete
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
    respond(repl, main)

Something dark and magic
"""
function respond(repl, main)
    (s, buf, ok) -> begin
        if !ok
            return REPL.transition(s, :abort)
        end
        input = String(take!(buf))
        if '%' in input
            tail = last(input)                              # chop the tail
            input = subst("$(ans)", "%", input[1:end-1])   # substitute
            input = string(input, tail)                     # add the tail
        end
        if !isempty(strip(input))
            try
                global ans = MExpr(input[1:end-1]) |> mcall
                REPL.reset(repl)
                if input[end] == ';'
                    REPL.print_response(repl, ans, nothing, true, Base.have_color)
                else
                    REPL.print_response(repl, nothing, nothing, true, Base.have_color)
                end
            catch err
                REPL.reset(repl)
                REPL.print_response(repl, err, catch_backtrace(), true, Base.have_color)
            end
        end
        REPL.prepare_next(repl)
        REPL.reset_state(s)
        s.current_mode.sticky || REPL.transition(s, main)
    end
end

"""
    MaximaCompletionProvider

Basic completion provider, just latex completions
"""
mutable struct MaximaCompletionProvider <: LineEdit.CompletionProvider
    r::REPL.LineEditREPL
end

function LineEdit.complete_line(c::MaximaCompletionProvider, s)
    buf = s.input_buffer
    partial = String(buf.data[1:buf.ptr-1])
    # complete latex
    full = LineEdit.input_string(s)
    ret, range, should_complete = REPLCompletions.bslash_completions(full, endof(partial))[2]
    
    if length(ret) > 0 && should_complete
        return ret, partial[range], true
    end

    return String[], 0:-1, false
end

function create_maxima_repl(repl, main)
    maxima_mode = LineEdit.Prompt(
        "maxima> ";
        prompt_prefix = Base.text_colors[:cyan],
        prompt_suffix = main.prompt_suffix,
        on_enter = finished,
        on_done = respond(repl, main),
        sticky = true)

    hp = main.hist
    hp.mode_mapping[:maxima] = maxima_mode
    maxima_mode.hist = hp
    maxima_mode.complete = MaximaCompletionProvider(repl)

    search_prompt, skeymap = LineEdit.setup_search_keymap(hp)
    prefix_prompt, prefix_keymap = LineEdit.setup_prefix_keymap(hp, maxima_mode)

    mk = REPL.mode_keymap(main)

    b = Dict{Any,Any}[
        skeymap, mk, prefix_keymap, LineEdit.history_keymap,
        LineEdit.default_keymap, LineEdit.escape_defaults
    ]
    maxima_mode.keymap_dict = LineEdit.keymap(b)

    maxima_mode
end

function repl_init(repl)
    mirepl = isdefined(repl, :mi) ? repl.mi : repl
    main_mode = mirepl.interface.modes[1]
    maxima_mode = create_maxima_repl(mirepl, main_mode)
    push!(mirepl.interface.modes, maxima_mode)

    maxima_prompt_keymap = Dict{Any,Any}(
        ')' => function (s,args...)
            if isempty(s) || position(LineEdit.buffer(s)) == 0
                buf = copy(LineEdit.buffer(s))
                LineEdit.transition(s, maxima_mode) do
                    LineEdit.state(s, maxima_mode).input_buffer = buf
                end
            else
                if !isdefined(Main,:OhMyREPL)
                    LineEdit.edit_insert(s, ')')
                else
                    if Main.OhMyREPL.BracketInserter.AUTOMATIC_BRACKET_MATCH[] &&
                        !eof(LineEdit.buffer(s)) &&
                        Main.OhMyREPL.BracketInserter.peek(LineEdit.buffer(s)) == ')'
                        LineEdit.edit_move_right(LineEdit.buffer(s))
                    else
                        LineEdit.edit_insert(LineEdit.buffer(s), ')')
                    end
                    Main.OhMyREPL.Prompt.rewrite_with_ANSI(s)
                end
            end
        end
    )
    main_mode.keymap_dict = LineEdit.keymap_merge(main_mode.keymap_dict, maxima_prompt_keymap);
    nothing
end
