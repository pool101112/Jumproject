note
	description: "Classe désignant les personnages joueurs"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	PLAYER

inherit
	SPRITE
	redefine
		box
	end

create
	make

feature -- Images


	make(a_player_number:INTEGER_8; a_screen:POINTER; a_ff_object, a_ff_object_2:FLYING_FLOOR; a_life_power_up:POWER_UPS)
	-- Initialisation du sprite
		local
			l_string_list:LIST[STRING]
		do
			screen := a_screen
			create {ARRAYED_LIST[STRING]} l_string_list.make (6)
			l_string_list.extend ("Ressources/yoma_wait_left.png")
			l_string_list.extend ("Ressources/yoma_wait_right.png")
			l_string_list.extend ("Ressources/yoma_go_left.png")
			l_string_list.extend ("Ressources/yoma_go_right.png")
			l_string_list.extend ("Ressources/yoma_jump_left.png")
			l_string_list.extend ("Ressources/yoma_jump_right.png")
			create_image_list (l_string_list)
			wait_ctr := 0

			if (a_player_number = 0) then
				set_start(556, 268)
			else
				set_start(1000, 268)
			end
			set_velocity(4, 3)
			init_score
			init_flying_floors (a_ff_object, a_ff_object_2)
			init_bonus (a_life_power_up)
			--assigner_spawn
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

	assign_ptr
		do
			assigner_img_ptr (1)
		end

--	assigner_spawn
--	-- Assigne l'image de spawn
--		do
--			assigner_sprite(spawn_left_path)
--		end

	apply_player
	-- Applique l'image à la fenêtre
		do
			apply_sprite_image_x_y(screen, 25)
		end

	collide_bonus:BOOLEAN
		do
			result := false
			if is_collision(bonus_object) then
				lives := lives + 1
				result := true
			end
		end

	apply_spawn
	-- Applique l'image de spawn à la fenêtre
		do
			apply_sprite_image_x_y(screen, 75)
		end

feature -- Moves

	box:TUPLE[left, right, top, bottom:INTEGER_16]
		do
			Result := [x, x + w // 8, y, y + h]
		end

feature {ANY} -- Actions
	projectile:PROJECTILE
	shooting:BOOLEAN

	shoot
		do
			if not shooting then
				create projectile.make (looking_right, current)
				shooting := true
			end
		end

	apply_proj (a_enemy:ENEMY)
		do
			if projectile.shooting then
				projectile.change_x (projectile.x + projectile.x_vel)
				projectile.apply_proj (a_enemy)
			else
				shooting := false
			end
		end

feature {ANY} -- Lives
	lives:INTEGER_8
	score:SCORE
	life_power_up:POWER_UPS

	init_score
		do
			create score.make (25)
			lives := 3
		end

	remaining_lives (a_lives:INTEGER_8)
		do
			lives := a_lives
		end

	reduce_live
		do
			lives := lives - 1
		end

	adjust_lives
		do
				score.assigner_score ("x"+lives.out)
		end

	no_live:BOOLEAN
		do
			if lives < 1 then
				Result := True
			else
				Result := False
			end
		end

end
