#   This file is part of Maxima.jl. It is licensed under the MIT license
#   Copyright (c) 2016 Nathan Smith

const EOT = Char(4)					# end of transmission character
const synerr = "incorrect syntax" 
const maxerr = "-- an error" 


struct MaximaSession <: Base.AbstractPipe
	
	input::Pipe
	output::Pipe
	process::Base.Process
	
	function MaximaSession()
		# If windows, executable is .bat
		cmd = is_unix() ? `maxima --very-quiet` :
			`maxima.bat --very-quiet`
		
		# Setup pipes and maxima process
		input = Pipe()
		output = Pipe()
		process = spawn(cmd, (input, output, STDERR))

		# Close the unneeded ends of Pipes	
		close(input.out)
		close(output.in)
	
		# Set display to 1-dimensionsal
		write(input, "display2d: false\$")
	
		return new(input, output, process)
	end
end

Base.kill(ms::MaximaSession) = kill(ms.process)
Base.process_exited(ms::MaximaSession) = process_exited(ms.process)

function Base.write(ms::MaximaSession, input::String)
	# The line break right ..v.. there is apparently very important...
	write(ms.input, "$input;\n")
	write(ms.input, "print(ascii(4))\$")
end

function Base.read(ms::MaximaSession)
	(readuntil(ms.output, EOT) |> String 
	                           |> str -> rstrip(str, EOT)) 
end
