note
	description: "Summary description for {AI_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AI_THREAD

inherit
	THREAD
	rename
		make as make_thread
	end

create
	make

feature {GAME} -- Thread pour l'IA

	stop_thread:BOOLEAN
	move_mutex:MUTEX
	player_object:PLAYER
	enemy_object:ENEMY
	ff_1_object, ff_2_object:FLYING_FLOOR
	direction:INTEGER_8
--		Negative value (-x) : Player under
--		Positive value (x): Player above
--		0: Player is colliding
--		1: Player is to the left
--		2: Player is to the same x
--		3: Player is to the right

	make (a_player:PLAYER; a_enemy:ENEMY; a_ff_1, a_ff_2:FLYING_FLOOR)
		do
			player_object := a_player
			enemy_object := a_enemy
			ff_1_object := a_ff_1
			ff_2_object := a_ff_2
			make_thread
			stop_thread := False
			move_mutex := enemy_object.move_mutex
		end

	execute
		local
			l_player_box, l_enemy_box, l_ff_1_box, l_ff_2_box:TUPLE[left, right, top, bottom:INTEGER_16]
		do
			{SDL_WRAPPER}.SDL_Delay(500)

			l_ff_1_box := ff_1_object.box
			l_ff_2_box := ff_2_object.box

			from
			until
				stop_thread
			loop
				move_mutex.lock
				l_player_box := player_object.box
				l_enemy_box := enemy_object.box
				move_mutex.unlock

				if enemy_object.wait_ctr > 0 then
					enemy_object.set_stop_left
					enemy_object.set_stop_right
					enemy_object.change_wait_ctr (enemy_object.wait_ctr - 1)
				else
					if l_enemy_box.top > l_player_box.bottom then
						enemy_object.set_jump
						if l_player_box.bottom < l_ff_2_box.top then
							if not (l_enemy_box.left > l_ff_2_box.right OR l_enemy_box.right < l_ff_2_box.left) then
								if (l_enemy_box.right - l_ff_2_box.left) < (l_ff_2_box.right - l_enemy_box.left)  then
									enemy_object.set_move_left
								else
									enemy_object.set_move_right
								end
							elseif not (l_enemy_box.left > l_ff_1_box.right OR l_enemy_box.right < l_ff_1_box.left) then
								enemy_object.set_move_right
							else
								enemy_object.set_stop_left
								enemy_object.set_stop_right
							end
						elseif l_player_box.bottom <  l_ff_1_box.top then
							if not (l_enemy_box.left > l_ff_1_box.right OR l_enemy_box.right < l_ff_1_box.left) then
								if (l_enemy_box.right - l_ff_1_box.left) < (l_ff_1_box.right - l_enemy_box.left)  then
									enemy_object.set_move_left
								else
									enemy_object.set_move_right
								end
							elseif not (l_enemy_box.left > l_ff_2_box.right OR l_enemy_box.right < l_ff_2_box.left) then
								enemy_object.set_move_left
							else
								enemy_object.set_stop_left
								enemy_object.set_stop_right
							end
						end
					elseif l_enemy_box.bottom < l_ff_2_box.top AND  l_ff_2_box.top < l_player_box.top then
						if not (l_enemy_box.left > l_ff_2_box.right OR l_enemy_box.right < l_ff_2_box.left) then
							if (l_enemy_box.right - l_ff_2_box.left) < (l_ff_2_box.right - l_enemy_box.left)  then
								enemy_object.set_move_left
							else
								enemy_object.set_move_right
							end
						end
					elseif l_enemy_box.bottom < l_ff_1_box.top AND l_ff_1_box.top < l_player_box.top then
						if not (l_enemy_box.left > l_ff_1_box.right OR l_enemy_box.right < l_ff_1_box.left) then
							if (l_enemy_box.right - l_ff_1_box.left) < (l_ff_1_box.right - l_enemy_box.left)  then
								enemy_object.set_move_left
							else
								enemy_object.set_move_right
							end
						end
					else
						if l_enemy_box.right < l_player_box.right then
							enemy_object.set_move_right
						elseif  l_enemy_box.left > l_player_box.left then
							enemy_object.set_move_left
						end
					end
				end
				{SDL_WRAPPER}.SDL_Delay(15)
			end
		end

	stop
		do
			stop_thread := True
		end

end
