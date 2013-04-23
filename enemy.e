note
	description: "Classe désignant les personnages opposants"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	ENEMY

inherit
	SPRITE

create
	make

feature {GAME} -- Image

	make
	-- Initialisation du sprite
		do
			file_paths
			assigner_ptr_image
			set_start(1112, 279)
			set_velocity(4, 3)
			assigner_spawn
			init_score
		end

	file_paths
	-- Association des ressources aux variables
		do
			spawn_left_path := "Ressources/zawa_spawn_left.png"
			wait_left_path := "Ressources/zawa_wait_left.png"
			wait_right_path := "Ressources/zawa_wait_right.png"
			go_left_path := "Ressources/zawa_go_left.png"
			go_right_path := "Ressources/zawa_go_right.png"
			jump_left_path := "Ressources/zawa_go_left.png"
			jump_right_path := "Ressources/zawa_go_right.png"
		end

	animate
		do
			if old_sprite_x < sprite_x then
				looking_right := True
				if old_sprite_y /= sprite_y then
					assigner_sprite (jump_right_path)
				elseif old_sprite_y = sprite_y then
					assigner_sprite (go_right_path)
				end
			elseif old_sprite_x > sprite_x then
				looking_right := False
				if old_sprite_y /= sprite_y then
					assigner_sprite (jump_left_path)
				elseif old_sprite_y = sprite_y then
					assigner_sprite (go_left_path)
				end
			else
				if looking_right then
					assigner_sprite (wait_right_path)
				else
					assigner_sprite (wait_left_path)
				end
			end
		end

	assigner_ptr_image
	-- Assigne l'image
		do
			assigner_sprite(wait_right_path)
		end

	assigner_spawn
	-- Assigne l'image de spawn
		do
			assigner_sprite(spawn_left_path)
		end

	apply_player(a_screen:POINTER)
	-- Applique l'image à la fenêtre
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_sprite_image_x_y(a_screen, 25)
		end

	apply_spawn(a_screen:POINTER)
	-- Applique l'image de spawn à la fenêtre
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_sprite_image_x_y(a_screen, 75)
		end

feature {GAME} -- Moves

	set_velocity(a_x, a_y:INTEGER_16)
	-- Applique la vélocité de X et Y
		do
			set_x_vel(a_x)
			set_y_vel(a_y)
		end

	set_move_left
	-- Indication de bouger vers la gauche
		do
			if is_moving_right = true then
				is_moving_right := false
			end
			looking_right := false
			is_moving_left := true
--			if not is_in_air then
--				assigner_sprite(go_left_path)
--			end
		end

	set_move_right
	-- Indication de bouger vers la droite
		do
			if is_moving_left = true then
				is_moving_left := false
			end
			looking_right := true
			is_moving_right := true
--			if not is_in_air then
--				assigner_sprite(go_right_path)
--			end
		end

	set_stop_left
	-- Indication d'arrêter de bouger vers la gauche
		do
			is_moving_left := false
--			if not is_in_air and not is_moving_right then
--				assigner_sprite(wait_left_path)
--			end
		end

	set_stop_right
	-- Indication d'arrêter de bouger vers la droite
		do
			is_moving_right := false
--			if not is_in_air and not is_moving_left then
--				assigner_sprite(wait_right_path)
--			end
		end

	set_jump
	-- Indication de sauter
		do
			if not is_in_air then
				is_jumping := true
			end
		end

	move
	-- Effectue les mouvements et vérifie les collisions
		do
			if is_moving_left then
				move_left(ff_box, ff_box2)
			elseif is_moving_right then
				move_right(ff_box, ff_box2)
			end
			if is_jumping then
				jump(ff_box, ff_box2)
			end
--			if is_in_air then
--				if looking_right then
--					assigner_sprite(jump_right_path)
--				else
--					assigner_sprite(jump_left_path)
--				end
--			end
			gravity(ff_box, ff_box2)
		end

feature {GAME} -- AI Moving System

	i:INTEGER_8
	run_away:BOOLEAN

	play_tag (a_player_box:ARRAY[INTEGER])
	-- Euh... Il joue à la Tag !
		local
			l_coll:COLLISION
			l_enemy_box:ARRAY[INTEGER]

			-- Player
			l_player_top, l_player_bottom, l_player_left, l_player_right,
			-- Enemy
			l_enemy_top, l_enemy_bottom, l_enemy_left, l_enemy_right,
			-- Flying Floor
			l_ff_top, l_ff_bottom, l_ff_left, l_ff_right,
			-- Flying Floor 2
			l_ff2_top, l_ff2_bottom, l_ff2_left, l_ff2_right:INTEGER_32
		do
			create l_coll
			l_enemy_box := fill_sprite_box

			-- Player
			l_player_top := a_player_box[2]
			l_player_bottom := a_player_box[2] + a_player_box[4]
			l_player_left := a_player_box[1]
			l_player_right := a_player_box[1] + (a_player_box[3] // 8)

			-- Enemy
			l_enemy_top := sprite_y
			l_enemy_bottom := sprite_y + sprite_h
			l_enemy_left := sprite_x
			l_enemy_right := sprite_x + (sprite_w // 8)

			-- Flying Floor
			l_ff_top := ff_box[2]
			l_ff_bottom := ff_box[2] + ff_box[4]
			l_ff_left := ff_box[1]
			l_ff_right := ff_box[1] + ff_box[3]

			-- Flying Floor 2
			l_ff2_top := ff_box2[2]
			l_ff2_bottom := ff_box2[2] + ff_box2[4]
			l_ff2_left := ff_box2[1]
			l_ff2_right := ff_box2[1] + ff_box2[3]

			if not run_away then
				if i < 50 then
					set_stop_right
					set_stop_left
					i := i + 1
				else
					if l_enemy_top > l_player_bottom then
						set_jump
						if l_player_bottom < l_ff2_top then
							if not (l_enemy_left > l_ff2_right OR l_enemy_right < l_ff2_left) then
								if (l_enemy_right - l_ff2_left) < (l_ff2_right - l_enemy_left)  then
									set_move_left
								else
									set_move_right
								end
							else
								set_stop_left
								set_stop_right
							end
						elseif l_player_bottom < l_ff_top then
							if not (l_enemy_left > l_ff_right OR l_enemy_right < l_ff_left) then
								if (l_enemy_right - l_ff_left) < (l_ff_right - l_enemy_left)  then
									set_move_left
								else
									set_move_right
								end
							else
								set_stop_left
								set_stop_right
							end
						end
					elseif l_enemy_bottom < l_ff2_top AND l_ff2_top < l_player_top then
						if not (l_enemy_left > l_ff2_right OR l_enemy_right < l_ff2_left) then
							if (l_enemy_right - l_ff2_left) < (l_ff2_right - l_enemy_left)  then
								set_move_left
							else
								set_move_right
							end
						end
					elseif l_enemy_bottom < l_ff_top AND l_ff_top < l_player_top then
						if not (l_enemy_left > l_ff_right OR l_enemy_right < l_ff_left) then
							if (l_enemy_right - l_ff_left) < (l_ff_right - l_enemy_left)  then
								set_move_left
							else
								set_move_right
							end
						end
					else
						if l_enemy_right < l_player_right then
							set_move_right
						elseif  l_enemy_left > l_player_left then
							set_move_left
						end
					end

					if l_coll.is_collision (l_enemy_box, a_player_box) then
						collision_sound
						i := 0
						set_stop_right
						set_stop_left
						run_away := false
						if lives > 0 then
							lives := lives - 1
						elseif lives = 0 then
							-- END
						end
					end
				end
			end
		end

	collision_sound
		local
			l_default_format:NATURAL_16
			l_chunk_path:C_STRING
			l_chunk:POINTER
		do
			create l_chunk_path.make ("Ressources/scratch.wav")
--			if {SDL_WRAPPER}.Mix_Init(0) < 0 then
--				print("Error at sound")
--			end
			l_default_format := {SDL_WRAPPER}.MIX_DEFAULT_FORMAT
			if {SDL_WRAPPER}.Mix_OpenAudio(44100, l_default_format, 2, 4096) < 0 then
				print("Error OpenAudio")
			end
			l_chunk := {SDL_WRAPPER}.Mix_LoadWAV(l_chunk_path.item)
			if {SDL_WRAPPER}.Mix_PlayChannel(-1, l_chunk, 0) < 0 then
				print("Error PlayMusic")
			end
		end

feature {GAME} -- Others		

	ff_box, ff_box2:ARRAY[INTEGER]

	init_ff_boxes(a_object_box, a_object_box2:ARRAY[INTEGER])
		require
			a_object_box_is_not_null : not a_object_box.is_empty
			a_object_box2_is_not_null : not a_object_box2.is_empty
		do
			ff_box := a_object_box
			ff_box2 := a_object_box2
		end

	no_live:BOOLEAN
		do
			if lives < 1 then
				Result := True
			else
				Result := False
			end
		end

feature -- Score
	lives:INTEGER_8
	score:SCORE

	init_score
		do
			create score.make (25)
			lives := 3
		end

	adjust_lives
		do
				score.assigner_score ("x"+lives.out)
		end

end
