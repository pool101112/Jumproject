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


	make(a_player_number:INTEGER_8; a_screen:POINTER; a_ff_object, a_ff_object_2:FLYING_FLOOR)
	-- Initialisation du sprite
		do
			screen := a_screen
			animation_files_path
			create_img_ptr_list
			create_img_ptr_new(go_left_path)
			create_img_ptr_new(go_right_path)
			create_img_ptr_new(wait_left_path)
			create_img_ptr_new(wait_right_path)
			create_img_ptr_new(jump_left_path)
			create_img_ptr_new(jump_right_path)
			assigner_img_ptr_from_array (1)
			if (a_player_number = 0) then
				set_start(556, 279)
			else
				set_start(1000, 279)
			end
			set_velocity(4, 3)
			init_score
			init_flying_floors (a_ff_object, a_ff_object_2)
			--assigner_spawn
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

	assigner_ptr_image
	-- Assigne l'image
		do
			create_img_ptr_new("Ressources/yoma_spawn_left.png")
		end

	assign_ptr
		do
			img_ptr := img_ptr_list[1]
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

	apply_spawn
	-- Applique l'image de spawn à la fenêtre
		do
			apply_sprite_image_x_y(screen, 75)
		end

feature -- Moves

	player_box:TUPLE[INTEGER_16, INTEGER_16, INTEGER_16, INTEGER_16]
		do
			Result := [image_x, image_x + image_w // 8, image_y, image_y + image_h]
		end

feature {ANY} -- Actions
	projectile:PROJECTILE
	shooting:BOOLEAN

	shoot
		do
			create projectile.make (looking_right, current)
			shooting := true
		end

	apply_proj (a_enemy:ENEMY)
		do
			if projectile.shooting then
				projectile.change_image_x (projectile.image_x + projectile.x_vel)
				projectile.apply_proj (a_enemy)
			else
				shooting := false
			end
		end

feature {ANY} -- Lives
	lives:INTEGER_8
	score:SCORE

	init_score
		do
			create score.make (25)
			lives := 10
		end

	remaining_lives (a_lives:INTEGER_8)
		do
			lives := a_lives
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
