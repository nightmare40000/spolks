require 'socket'

READ_CHUNK = 1024
LOCAL_PORT = 3000
include Socket::Constants
socket = Socket.new(AF_INET, SOCK_STREAM)
addr = Socket.pack_sockaddr_in(LOCAL_PORT, '0.0.0.0')
socket.bind(addr)
socket.listen(5)
socket.setsockopt(:SOCKET, :REUSEADDR, true)

puts "Server is listening on port = #{LOCAL_PORT}"

loop do 
    begin
    connection, addr_info = socket.accept
    data_buffer = ""
    
    connection.write("You've been connected to server. Enter \"exit\" to disconnect\nData to send = ")		    

    loop do
        begin
	    connection.read_nonblock(READ_CHUNK, data_buffer)
 	    
	    if data_buffer.include? "exit"
   			puts "Connection closed"
			connection.close
		      	break
	    end
	    connection.write("Data sended =  #{data_buffer}\nData to send = ")
            puts "Data recieved = #{data_buffer}"

        rescue Errno::EAGAIN => e
            IO.select([connection])         
            retry
        rescue EOFError
            break
        end
    end

    rescue Exception, Interupt
	puts "\nServer shutdown"
	break;
    end
end
