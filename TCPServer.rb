require 'socket'
TCPServer.open('localhost', 3000){ |server|
    if (session = server.accept)
        session.print "Welcome to server\r\nEnter \"exit\" to shutdown server.\r\n"
        loop{
            cmd, arg = session.gets.chomp.split
            case cmd
                when "exit"
                    session.close
                    break
                else
	    	    print cmd + "\n"		
                    session.print cmd + "\n"
            end
        }
    end
}
