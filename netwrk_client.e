note
	description: "Summary description for {NETWRK_CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NETWRK_CLIENT

create
	make

feature{MULTI_THREAD} -- Make

	client_socket:NETWORK_STREAM_SOCKET

	make
		local
			l_address:INET_ADDRESS
			l_addr_factory:INET_ADDRESS_FACTORY
		do
			create l_addr_factory
			l_address := l_addr_factory.create_from_name ("10.60.8.239")
			create client_socket.make_client_by_address_and_port (l_address, 12345)
			client_socket.connect
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
