note
	description: "Summary description for {NETWRK_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NET_SERVER

create
	make

feature{NETWORK_THREAD} -- Make

	client_socket:NETWORK_STREAM_SOCKET

	make
		local
			l_server_socket:NETWORK_STREAM_SOCKET
		do
			create l_server_socket.make_server_by_port (12345)
			l_server_socket.listen (1)
			l_server_socket.accept
			client_socket := l_server_socket.accepted
			l_server_socket.close
		end

	send(a_x, a_y:INTEGER_16)
		do
			client_socket.put_integer_16 (a_x)
			client_socket.put_integer_16 (a_y)
		end

	read:INTEGER_16
		do
			client_socket.read_integer_16
			Result := client_socket.last_integer_16
		end

	close
		do
			client_socket.close
		end
end
