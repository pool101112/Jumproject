 note
	description: "Classe désignant les personnages"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

deferred class
	SPRITE

inherit
	IMAGE

	COLLISION

feature {GAME, NETWORK_THREAD, AI_THREAD} -- Images
	wait_ctr:INTEGER_8
	sprite_ctr, jump_ctr:INTEGER_16
	is_moving_left, is_moving_right, is_jumping, is_in_air, looking_right:BOOLEAN
	spawn_left_path, wait_left_path, wait_right_path, go_left_path, go_right_path, jump_left_path, jump_right_path:STRING

	assigner_sprite(a_pos:INTEGER)
	-- Assigne l'image
		do
			assigner_img_ptr (a_pos)
		end

	apply_sprite_image_x_y(a_screen:POINTER; a_ctr_limit:INTEGER_16)
	-- Applique la région de l'image à sélectionner
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		local
			l_image_rect_x:INTEGER_16
		do
			l_image_rect_x := (sprite_ctr // 5) * 50

			sprite_ctr := sprite_ctr + 1
			if sprite_ctr = a_ctr_limit then
				sprite_ctr := 0
			end

			apply_sprite(a_screen, x, y, l_image_rect_x, 0)

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


feature {GAME, NETWORK_THREAD, AI_THREAD, PLAYER} -- Moves
	sprite_w, sprite_h, x_vel, y_vel:INTEGER_16
	ff1_box, ff2_box, yoshi_box:TUPLE[left, right, top, bottom:INTEGER_16]
	ff_object, ff_object_2, bonus_object:COLLISION

	box:TUPLE[left, right, top, bottom:INTEGER_16]
		do
			Result := yoshi_box
		end

	move_mutex:MUTEX

	init_mutex
		do
			create move_mutex.make
		end


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
				assigner_img_ptr(1)
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
				assigner_img_ptr(2)
			end
		end

	set_stop_left
	-- Indication d'arrêter de bouger vers la gauche
		do
			is_moving_left := false
			if not is_in_air and not is_moving_right then
				assigner_img_ptr(3)
			end
		end

	set_stop_right
	-- Indication d'arrêter de bouger vers la droite
		do
			is_moving_right := false
			if not is_in_air and not is_moving_left then
				assigner_img_ptr(4)
			end
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
				move_left
			elseif is_moving_right then
				move_right
			end
			if is_jumping then
				jump
			end
			if is_in_air then
				if looking_right then
					assigner_img_ptr(6)
				else
					assigner_img_ptr(5)
				end
			end
			gravity
		end

	move_left
		do
			old_x := x
			x := x - x_vel
			yoshi_box := [Current.x, Current.x + Current.w // 8, Current.y, Current.y + Current.h]
			if x < 0 then
				undo_move(x_vel)
			elseif is_collision (ff_object) then
				undo_move(x_vel)
			elseif is_collision (ff_object_2) then
				undo_move(x_vel)
			end
		end

	move_right
	-- Effectue un mouvement à droite
		require
			x_vel_is_higher_than_0 : x_vel > 0
		do
			old_x := x
			x := x + x_vel
			yoshi_box := [Current.x, Current.x + Current.w // 8, Current.y, Current.y + Current.h]
			if (x + (w // 8)) > 556 then
				undo_move(-x_vel)
			elseif is_collision (ff_object) then
				undo_move(-x_vel)
			elseif is_collision (ff_object_2) then
				undo_move(-x_vel)
			end
		end

	init_flying_floors (a_ff_object, a_ff_object_2:FLYING_FLOOR)
		do
			ff_object:=a_ff_object
			ff_object_2:=a_ff_object_2
			ff1_box := [a_ff_object.x, a_ff_object.x + a_ff_object.w, a_ff_object.y, a_ff_object.y + a_ff_object.h]
			ff2_box := [a_ff_object_2.x, a_ff_object_2.x + a_ff_object_2.w, a_ff_object_2.y, a_ff_object_2.y + a_ff_object_2.h]
		end

	init_bonus (a_bonus_object:POWER_UPS)
		do
			bonus_object := a_bonus_object
		end

	set_start(screen_w, screen_h:INTEGER_16)
	-- Initialise la position de départ
		require
			screen_w_is_above_0 : screen_w > 0
			screen_h_is_above_0 : screen_h > 0
		do
			sprite_w := get_img_w
			sprite_h := get_img_h
			x := (screen_w // 2) - (sprite_w // 2)
			y := screen_h - sprite_h - 45
			ensure
				sprite_w_is_higher_than_0 : sprite_w > 0
				sprite_h_is_higher_than_0 : sprite_h > 0
		end

	jump
	-- Effectue un jump
		do
			if jump_ctr <= 30 then
				old_y := y
				y := y - (y_vel * 2)
				jump_ctr := jump_ctr + 1
				yoshi_box := [Current.x, Current.x + Current.w // 8, Current.y, Current.y + Current.h]
				if is_collision (ff_object) then
					undo_jump_gravity(y_vel)
					jump_ctr := 31
				elseif is_collision (ff_object_2) then
					undo_jump_gravity(y_vel)
					jump_ctr := 31
				end
			else
				jump_ctr := 0
				is_jumping := False
			end
		end

	gravity
	-- Applique la gravité
		do
			old_y := y
			y := y + y_vel
			yoshi_box := [Current.x, Current.x + Current.w // 8, Current.y, Current.y + Current.h]
			is_in_air := true
			if (Current.y + Current.h) > 238 then
				undo_jump_gravity(y_vel - y_vel - y_vel)
				is_in_air := false
				if not is_moving_right and not is_moving_left then
					if looking_right then
						assigner_img_ptr(4)
					else
						assigner_img_ptr(3)
					end
				elseif is_moving_right then
					assigner_img_ptr(2)
				elseif is_moving_left then
					assigner_img_ptr(1)
				end
			elseif is_collision (ff_object) then
				undo_jump_gravity(y_vel - y_vel - y_vel)
				is_in_air := false
				if not is_moving_right and not is_moving_left then
					if looking_right then
						assigner_img_ptr(4)
					else
						assigner_img_ptr(3)
					end
				elseif is_moving_right then
					assigner_img_ptr(2)
				elseif is_moving_left then
					assigner_img_ptr(1)
				end
			elseif is_collision (ff_object_2) then
				undo_jump_gravity(y_vel - y_vel - y_vel)
				is_in_air := false
				if not is_moving_right and not is_moving_left then
					if looking_right then
						assigner_img_ptr(4)
					else
						assigner_img_ptr(3)
					end
				elseif is_moving_right then
					assigner_img_ptr(2)
				elseif is_moving_left then
					assigner_img_ptr(1)
				end
			end
			yoshi_box := [Current.x, Current.x + Current.w // 8, Current.y, Current.y + Current.h]
		end

	undo_move(a_x_vel:INTEGER_16)
	-- Défait un mouvement (Gauche/Droite)
		do
			x := x + a_x_vel
		end

	undo_jump_gravity(a_y_vel:INTEGER_16)
	-- Défait un mouvement (Haut/Bas)
		do
			y := y + a_y_vel
		end

feature {ANY} -- Animations

	animate
		do
			if old_x < x then
				looking_right := True
				if old_y /= y then
					assigner_img_ptr (6)
				elseif old_y = y then
					assigner_img_ptr (2)
				end
			elseif old_x > x then
				looking_right := False
				if old_y /= y then
					assigner_img_ptr (5)
				elseif old_y = y then
					assigner_img_ptr (1)
				end
			else
				if looking_right then
					assigner_img_ptr (4)
				else
					assigner_img_ptr (3)
				end
			end
		end

feature {ANY} -- Coordonnées du sprite

	sprite_x:INTEGER_16
	-- Valeur de `x'
		do
			Result := x
			ensure
				Result_x_is_not_below_0 : Result >= 0
		end

	sprite_y:INTEGER_16
	-- Valeur de `y'
		do
			Result := y
			ensure
				Result_y_is_not_below_0 : Result >= 0
		end

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

	change_x (a_x:INTEGER_16)
		do
			old_x := x
			x := a_x
		end


	change_y (a_y:INTEGER_16)
		do
			old_y := y
			y := a_y
		end

end
