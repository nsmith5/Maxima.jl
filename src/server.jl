#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

const inputchannel = Channel{Compat.String}(1)
const outputchannel = Channel{Compat.String}(1)
const errchannel = Channel{Int}(1)              

"""
    connect(port)

Starting at port `port`, try to start a TCP server. If this fails try the next
port until successful.

Note: If your starting port unreasonable (like 20) this will
hang because it opens too many files in the search for an open port.
"""
function connect(port)
    try
        server = listen(port)
        return server, port
    catch err
        connect(port + 1)
    end
end

"""
    input(str::String)

Pass a string to the maxima client. If the string is not a valid maxima
expression this may hang.
"""
function input(str::Compat.String)
    put!(inputchannel, str)
    return nothing
end


"""
    output()

Take raw output from the maxima client.
"""
function output()
    take!(outputchannel)
end

"""
    startserver(port)

Start up a maxima client-server pair trying port `port` first.
"""
function startserver(port)
    server, port = connect(port)
    socketrequest = @spawn accept(server)
    clientrequest = @spawn run(`
        maxima --server=$port --very-quiet
		--run-string="display2d: false\$"`)
    socket = fetch(socketrequest)
    
    readavailable(socket)
    write(socket, "errormsg: false\$")
    stopchar = Char(4)
    
    syn_err = " \nincorrect syntax"
    max_err = " \n -- an error"

    while true
        input = take!(inputchannel)
        write(socket, string(input, '\n'))
		char = read(socket, Char)
		write(socket, "print(ascii(4))\$\n")
		str = string(char)
		while char != stopchar
			char = read(socket, Char)
			str = string(str, char)
            if str == max_err
                put!(errchannel, 1)
            elseif str == syn_err
                put!(errchannel, 2)
            end
		end
	    str = rstrip(str, stopchar)
        put!(outputchannel, str)
        isready(errchannel) || put!(errchannel, 0)
    end
    return nothing
end

"""
    killserver()

Kill maxima client with `quit();` call from the server
"""
function killserver()
	input("quit();")
	input(" ")			# Curiously, this line is important to insure the maxima client actually quit...
	return nothing
end 
