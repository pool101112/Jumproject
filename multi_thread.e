note
	description: "Summary description for {MULTI_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NETWORK_THREAD

inherit
	THREAD
	rename
		make as make_thread
	end

create
	make

feature {GAME} -- Make

	stop_thread:BOOLEAN
	server:NET_SERVER
	client:NET_CLIENT
	enemy:ENEMY
	player:PLAYER
	is_server:BOOLEAN

	make(a_is_server:BOOLEAN; a_enemy:ENEMY; a_player:PLAYER; a_ip_address:STRING)
		do
			make_thread
			stop_thread := False
			enemy := a_enemy
			player := a_player
			is_server := a_is_server
			if a_is_server then
				create server.make
			else
				create client.make (a_ip_address)
			end
		end

	execute
		do
			from
			until
				stop_thread
			loop
				if is_server then
					enemy.change_x (server.read)
					enemy.change_y (server.read)
					server.send (player.sprite_x, player.sprite_y)
				else
					client.send (player.sprite_x, player.sprite_y)
					enemy.change_x (client.read)
					enemy.change_y (client.read)
				end
			end
			if is_server then
				server.close
			else
				client.close
			end
		end

	stop
		do
			stop_thread := True
		end
end
