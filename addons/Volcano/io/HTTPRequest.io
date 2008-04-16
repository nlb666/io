HttpRequest := Object clone do(
	uri ::= nil
	fragment ::= nil
	path ::= nil
	queryString ::= nil
	version ::= nil
	body ::= nil
	fields ::= nil
	server ::= nil
	
	handleSocket := method(socket,
		parser := HttpParser clone setParseBuffer(socket readBuffer)
		while(parser isFinished not,
			socket streamReadNextChunk ifError(e,
				writeln("Error reading next chunk: ", e description)
				socket close
				return
			)
			parser parse ifError(e,
				writeln("Error parsing request: ", e description)
				socket close
				return
			)
		)
		streamResponse(socket, parser asRequest)
		socket close
		server completedRequest(self)
	)
	
	streamResponse := method(socket, request,
		HttpResponse withSocket(socket) setBody("<html>Hello</html>") send
	)
)