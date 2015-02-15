require 'socket'
require 'json'

host = 'localhost'
port = 2000

puts "Welcome to Simple Browser"
puts "What would you like to do?"
puts "Type 1 to GET"
puts "Type 2 to POST"
choice = gets.chomp

if choice == "1"
	path = "/index.html"
	request = "GET #{path} HTTP/1.0\r\n\r\n"
elsif choice == "2"
	path ="/thanks.html"
	puts "Viking Raid Registration:"
	puts "Please enter your name:"
	name = gets.chomp
	puts "Please enter your email address:"
	email = gets.chomp

	request_hash = {:viking => {:name=>name, :email=>email}}.to_json
	request = "POST #{path} HTTP/1.0\r\nFrom: #{email}\r\nUser-Agent: SimpleBrowser\r\nContent-Type: application/jso\r\nContent-Length: #{request_hash.to_s.length}\r\n\r\n#{request_hash}"
else
	puts "Sorry, that was an invalid selection"
	exit
end

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
header, body = response.split("\r\n\r\n", 2)
print body
socket.close