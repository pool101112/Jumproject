 note
	description: "Classe désignant les personnages"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

deferred class
	SPRITE

inherit
	IMAGE

	GROUND

feature {GAME} -- Images
	sprite_ctr, jump_ctr:INTEGER_16
	is_moving_left, is_moving_right, is_jumping, is_in_air, looking_right:BOOLEAN
	spawn_left_path, wait_left_path, wait_right_path, go_left_path, go_right_path, jump_left_path, jump_right_path:STRING

	assigner_sprite(a_sprite_file:STRING)
	-- Assigne l'image
		do
			create_img_ptr(a_sprite_file)
		end

	apply_sprite_image_x_y(a_screen:POINTER; a_ctr_limit:INTEGER_16)
	-- Applique la région de l'image à sélectionner
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		local
			l_image_rect_x:INTEGER_16
		do
			l_image_rect_x := (sprite_ctr.as_integer_16 // 5) * 50

			sprite_ctr := sprite_ctr + 1
			if sprite_ctr = a_ctr_limit then
				sprite_ctr := 0
			end

			apply_sprite(a_screen, sprite_x, sprite_y, l_image_rect_x, 0)

		ensure
				sprite_ctr_is_not_above_25 : sprite_ctr <= a_ctr_limit
		end

	apply_sprite(a_screen:POINTER; a_x, a_y, a_image_rect_x, a_image_rect_y:INTEGER_16)
	-- Applique l'image à la fenêtre
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		local
			l_image_rect, l_memory_manager:POINTER
		do
			l_image_rect := l_memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Rect)

			{SDL_WRAPPER}.set_target_area_x(l_image_rect, a_image_rect_x)
			{SDL_WRAPPER}.set_target_area_y(l_image_rect, a_image_rect_y)
			{SDL_WRAPPER}.set_target_area_w(l_image_rect, 50)
			{SDL_WRAPPER}.set_target_area_h(l_image_rect, 40)

			apply_img(a_screen, l_image_rect, a_x, a_y)
		end


feature {GAME} -- Moves
	sprite_x, sprite_y, sprite_w, sprite_h, x_vel, y_vel:INTEGER_16

	set_x_vel(a_velocity:INTEGER_16)
	-- Ajuste la vélocité du déplacement latéral
		require
			a_velocity_is_higher_than_0 : a_velocity > 0
		do
			x_vel := a_velocity
		end

	set_y_vel(a_velocity:INTEGER_16)
	-- Ajuste la vélocité du jump et de la gravité
		require
			a_velocity_is_higher_than_0 : a_velocity > 0
		do
			y_vel := a_velocity
		end

	move_left(a_object_box, a_object_box_two:ARRAY[INTEGER])
	-- Effectue un mouvement à gauche
		require
			a_object_box_is_not_null : a_object_box /= Void
			a_object_box_two_is_not_null : a_object_box /= Void
			x_vel_is_higher_than_0 : x_vel > 0
		local
			l_sprite_box:ARRAY[INTEGER]
			l_coll:COLLISION
		do
			create l_coll
			sprite_x := sprite_x - x_vel
			l_sprite_box := fill_sprite_box
			if sprite_x < 0 then
				undo_move(x_vel)
			elseif l_coll.is_collision (a_object_box, l_sprite_box) then
				undo_move(x_vel)
			elseif l_coll.is_collision (a_object_box_two, l_sprite_box) then
				undo_move(x_vel)
			end
		end

	move_right(a_object_box, a_object_box_two:ARRAY[INTEGER])
	-- Effectue un mouvement à droite
		require
			a_object_box_is_not_null : not a_object_box.is_empty
			a_object_box_two_is_not_null : not a_object_box.is_empty
			x_vel_is_higher_than_0 : x_vel > 0
		local
			l_sprite_box:ARRAY[INTEGER]
			l_coll:COLLISION
		do
			create l_coll
			sprite_x := sprite_x + x_vel
			l_sprite_box := fill_sprite_box
			if (sprite_x + (sprite_w // 7)) > 556 then
				undo_move(x_vel - x_vel - x_vel)
			elseif l_coll.is_collision (a_object_box, l_sprite_box) then
				undo_move(x_vel - x_vel - x_vel)
			elseif l_coll.is_collision (a_object_box_two, l_sprite_box) then
				undo_move(x_vel - x_vel - x_vel)
			end
		end

	fill_sprite_box:ARRAY[INTEGER]
	-- Créé un array pour y stocker les dimensions et l'emplacement
		local
			l_sprite_box:ARRAY[INTEGER]
		do
			create l_sprite_box.make_filled (0, 1, 4)
			l_sprite_box[1] := sprite_x
			l_sprite_box[2] := sprite_y
			l_sprite_box[3] := sprite_w  // 7
			l_sprite_box[4] := sprite_h
			Result := l_sprite_box
		end

	set_start(screen_w, screen_h:INTEGER_16)
	-- Initialise la position de départ
		require
			screen_w_is_above_0 : screen_w > 0
			screen_h_is_above_0 : screen_h > 0
		do
			sprite_w := get_img_w
			sprite_h := get_img_h
			sprite_x := (screen_w // 2) - (sprite_w // 2)
			sprite_y := screen_h - sprite_h - 30
			ensure
				sprite_w_is_higher_than_0 : sprite_w > 0
				sprite_h_is_higher_than_0 : sprite_h > 0
		end

	jump(a_object_box, a_object_box_two:ARRAY[INTEGER])
	-- Effectue un jump
		require
			jump_ctr_is_below_32 : jump_ctr < 32
			a_object_box_is_not_null : not a_object_box.is_empty
			a_object_box_two_is_not_null : not a_object_box.is_empty
		local
			l_sprite_box:ARRAY[INTEGER]
			l_coll:COLLISION
		do
			if jump_ctr <= 30 then
				create l_coll
				sprite_y := sprite_y - (y_vel*2)
				jump_ctr := jump_ctr + 1
				l_sprite_box := fill_sprite_box
				if l_coll.is_collision (a_object_box, l_sprite_box) then
					undo_jump_gravity(y_vel)
					jump_ctr := 31
				elseif l_coll.is_collision (a_object_box_two, l_sprite_box) then
					undo_jump_gravity(y_vel)
					jump_ctr := 31
				end
			else
				jump_ctr := 0
				is_jumping := False
			end
		end

	gravity(a_object_box, a_object_box_two:ARRAY[INTEGER])
	-- Applique la gravité
		local
			l_sprite_box:ARRAY[INTEGER]
			l_coll:COLLISION
		do
			create l_coll
			sprite_y := sprite_y + y_vel
			l_sprite_box := fill_sprite_box
			is_in_air := true
			if (l_sprite_box[2]+l_sprite_box[4]) > 248 then
				undo_jump_gravity(y_vel - y_vel - y_vel)
				is_in_air := false
				if not is_moving_right and not is_moving_left then
					if looking_right then
						assigner_sprite(wait_right_path)
					else
						assigner_sprite(wait_left_path)
					end
				elseif is_moving_right then
					assigner_sprite(go_right_path)
				elseif is_moving_left then
					assigner_sprite(go_left_path)
				end
			elseif l_coll.is_collision (a_object_box, l_sprite_box) then
				undo_jump_gravity(y_vel - y_vel - y_vel)
				is_in_air := false
				if not is_moving_right and not is_moving_left then
					if looking_right then
						assigner_sprite(wait_right_path)
					else
						assigner_sprite(wait_left_path)
					end
				elseif is_moving_right then
					assigner_sprite(go_right_path)
				elseif is_moving_left then
					assigner_sprite(go_left_path)
				end
			elseif l_coll.is_collision (a_object_box_two, l_sprite_box) then
				undo_jump_gravity(y_vel - y_vel - y_vel)
				is_in_air := false
				if not is_moving_right and not is_moving_left then
					if looking_right then
						assigner_sprite(wait_right_path)
					else
						assigner_sprite(wait_left_path)
					end
				elseif is_moving_right then
					assigner_sprite(go_right_path)
				elseif is_moving_left then
					assigner_sprite(go_left_path)
				end
			end
		end

	undo_move(a_x_vel:INTEGER_16)
	-- Défait un mouvement (Gauche/Droite)
		do
			sprite_x := sprite_x + a_x_vel
		end

	undo_jump_gravity(a_y_vel:INTEGER_16)
	-- Défait un mouvement (Haut/Bas)
		do
			sprite_y := sprite_y + a_y_vel
		end

end
