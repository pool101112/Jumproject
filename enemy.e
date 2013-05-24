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

	make(a_screen:POINTER; a_ff_object, a_ff_object_2:FLYING_FLOOR)
	-- Initialisation du sprite
		do
			screen := a_screen
			file_paths
			create_img_ptr_list
			create_img_ptr_new(go_left_path)
			create_img_ptr_new(go_right_path)
			create_img_ptr_new(wait_left_path)
			create_img_ptr_new(wait_right_path)
			create_img_ptr_new(jump_left_path)
			create_img_ptr_new(jump_right_path)
			assigner_img_ptr_from_array (1)
			set_start(1112, 268)
			set_velocity(4, 3)
--			assigner_spawn
			init_flying_floors (a_ff_object, a_ff_object_2)
			init_mutex
			life := 100
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

	assigner_ptr_image
	-- Assigne l'image
		do
			assigner_sprite(2)
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

feature {ANY} -- Life
	life:INTEGER

	reduce_life
		do
			if not is_dead then
				life := life - 20
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
