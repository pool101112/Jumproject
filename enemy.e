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

	player_object:PLAYER

	make(a_screen:POINTER; a_ff_object, a_ff_object_2:FLYING_FLOOR; a_player_object:PLAYER)
	-- Initialisation du sprite
	local
			l_string_list:LIST[STRING]
		do
			screen := a_screen
			player_object := a_player_object
			create {ARRAYED_LIST[STRING]} l_string_list.make (6)
			l_string_list.extend ("Ressources/yoma_wait_left.png")
			l_string_list.extend ("Ressources/yoma_wait_right.png")
			l_string_list.extend ("Ressources/yoma_go_left.png")
			l_string_list.extend ("Ressources/yoma_go_right.png")
			l_string_list.extend ("Ressources/yoma_jump_left.png")
			l_string_list.extend ("Ressources/yoma_jump_right.png")
			create_image_list (l_string_list)

			set_start(1112, 268)
			set_velocity(4, 3)
--			assigner_spawn
			init_flying_floors (a_ff_object, a_ff_object_2)
			init_mutex
			life := 100
		end

	create_image_list (a_path_list:LIST[STRING])
	-- Cree une liste d'images
		local
			l_i:INTEGER
		do
			create_img_ptr_list
			from
				l_i := 1
			until
				l_i > a_path_list.count
			loop
				create_img_ptr(a_path_list[l_i])
				l_i := l_i + 1
			end
			assigner_img_ptr (1)
		end

	assigner_spawn
	-- Assigne l'image de spawn
		do
			assigner_sprite(3)
		end

	apply_player
	-- Applique l'image à la fenêtre
		do
			apply_sprite_image_x_y(screen, 25)
		end

	collide_player
		do
			if is_collision (player_object) and wait_ctr = 0 then
				collision_sound
				wait_ctr := 127
				set_stop_left
				set_stop_right
				player_object.reduce_live
			end
		end

	apply_spawn
	-- Applique l'image de spawn à la fenêtre
		do
			apply_sprite_image_x_y(screen, 75)
		end

feature {GAME, AI_THREAD} -- AI Moving System

	i:INTEGER_8
	run_away:BOOLEAN

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

	change_wait_ctr (a_wait_ctr:INTEGER_8)
		do
			wait_ctr := a_wait_ctr
		end

feature {ANY} -- Life
	life:INTEGER

	reduce_life
		do
			if not is_dead then
				life := life - 5
			end

			if life <= 0 then
				life := life - life
			end
			ensure
				life_is_not_below_0: life >= 0
		end

	is_dead:BOOLEAN
		do
			if (life <= 0) then
				result := true
			else
				result := false
			end
		end
end
