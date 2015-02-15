require 'socket'
require 'json'

server = TCPServer.open(2000)

loop {

	client = server.accept
	request = client.read_nonblock(256)
	header, body = request.split("\r\n\r\n", 2)
	method = header.split[0]
	filename = header.split[1][1..-1]

	if File.exists?(filename)
		file = File.read(filename)
		client.print('HTTP/1.0 200 OK\r\nDate: #{Time.now.ctime}\r\ntext/html\r\nContent-Length: #{File.size{filename)}\r\n\r\n')
		if method == "GET"
			client.puts(file)
		elsif method == "POST"
			params = JSON.parse(body)
			registration = "<li>Name: #{params['viking']['name']}</li><li>Email: #{params["viking"]['email']}</li>"
			client.print("HTTP/1.0 200 OK\r\nDate: #{Time.now.ctime}\r\ntext/html\r\nContent-Length: #{File.size(filename)}\r\n\r\n")
			client.puts(file.gsub("<%= yield %>",registration))
		end
	else
		client.puts('HTTP/1.0 404 Not Found')
	end
	
}



