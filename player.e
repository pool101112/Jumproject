note
	description: "Classe désignant les personnages joueurs"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	PLAYER

inherit
	SPRITE

create
	make

feature -- Images


	make
	-- Initialisation du sprite
		do
			animation_files_path
			assigner_ptr_image
			set_start(556, 279)
			set_velocity(4, 3)
			assigner_spawn
		end

	animation_files_path
	-- Association des ressources aux variables
		do
			spawn_left_path := "Ressources/yoma_spawn_left.png"
			wait_left_path := "Ressources/yoma_wait_left.png"
			wait_right_path := "Ressources/yoma_wait_right.png"
			go_left_path := "Ressources/yoma_go_left.png"
			go_right_path := "Ressources/yoma_go_right.png"
			jump_left_path := "Ressources/yoma_jump_left.png"
			jump_right_path := "Ressources/yoma_jump_right.png"
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

feature -- Moves

	set_velocity(a_x, a_y:INTEGER_16)
	-- Applique la vélocité de X et Y
		require
			a_x_is_above_0 : a_x > 0
			a_y_is_above_1 : a_y > 0
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
			if not is_in_air then
				assigner_sprite(go_left_path)
			end
		end

	set_move_right
	-- Indication de bouger vers la droite
		do
			if is_moving_left = true then
				is_moving_left := false
			end
			looking_right := true
			is_moving_right := true
			if not is_in_air then
				assigner_sprite(go_right_path)
			end
		end

	set_stop_left
	-- Indication d'arrêter de bouger vers la gauche
		do
			is_moving_left := false
			if not is_in_air and not is_moving_right then
				assigner_sprite(wait_left_path)
			end
		end

	set_stop_right
	-- Indication d'arrêter de bouger vers la droite
		do
			is_moving_right := false
			if not is_in_air and not is_moving_left then
				assigner_sprite(wait_right_path)
			end
		end

	set_jump
	-- Indication de sauter
		do
			if not is_in_air then
				is_jumping := true
			end
		end

	move(a_object_box, a_object_box2:ARRAY[INTEGER])
	-- Effectue les mouvements et vérifie les collisions
		require
			a_object_box_is_not_empty : not a_object_box.is_empty
			a_object_box2_is_not_empty : not a_object_box2.is_empty
		do
			if is_moving_left then
				move_left(a_object_box, a_object_box2)
			elseif is_moving_right then
				move_right(a_object_box, a_object_box2)
			end
			if is_jumping then
				jump(a_object_box, a_object_box2)
			end
			if is_in_air then
				if looking_right then
					assigner_sprite(jump_right_path)
				else
					assigner_sprite(jump_left_path)
				end
			end
			gravity(a_object_box, a_object_box2)
		end
end
