#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith


const eot = Char(4)
const synerr = "incorrect syntax" 
const maxerr = "-- an error" 


struct MaximaSession <: Base.AbstractPipe
	
	input::Pipe
	output::Pipe
	process::Base.Process
	
	function MaximaSession()
		cmd = is_unix() ? `maxima --very-quiet` :
			`maxima.bat --very-quiet`
		
		input = Pipe()
		output = Pipe()
		process = spawn(cmd, (input, output, STDERR))
		
		write(input, "display2d: false\$")
		return new(input, output, process)
	end
end

Base.kill(ms::MaximaSession) = kill(ms.process)

Base.process_exited(ms::MaximaSession) = process_exited(ms.process)

function Base.write(ms::MaximaSession, input::String)
	write(ms.input, "$input;")
	write(ms.input, "print(ascii(4))\$")
end

function Base.read(ms::MaximaSession)
	(readuntil(ms.output, eot) |> String 
	                           |> str -> rstrip(str, eot)) 
end
