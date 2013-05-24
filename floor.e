note
	description: "Classe désignant les parcelles de terre au début du niveau, là où le/les joueurs commencent."
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	PROJECTILE

inherit
	SPRITE

create
	make

feature {ANY} -- Main
	proj_ctr:INTEGER_8
	shooting:BOOLEAN

	make (a_shoot_to_right:BOOLEAN; a_player:PLAYER)
		do
			proj_ctr := 0
			x := a_player.x + a_player.w // 8
			y := a_player.y + 10
			screen := a_player.screen
			assigner_ptr_image
			if a_shoot_to_right then
				x_vel := 10
			else
				x_vel := -10
			end
			shooting := true
		end

	assigner_ptr_image
	-- Assigne l'image
		do
			create_img_ptr_list
			create_img_ptr_new("Ressources/Images/egg_proj.png")
			create_img_ptr_new("Ressources/Images/egg_proj_cracked.png")
			create_img_ptr_new("Ressources/Images/egg_proj_broken.png")
			assigner_img_ptr_from_array(1)
		end

	apply_proj (a_enemy:ENEMY)
		local
			l_egg_broke:SOUND
		do
			if x + w >= 556 or x <= 0 then
				if proj_ctr = 0 then
					x_vel := 0
					assigner_img_ptr_from_array(2)
				elseif proj_ctr = 3 then
					assigner_img_ptr_from_array(3)
					shooting := false
					create l_egg_broke.make ("Ressources/Sounds/egg_crack_1.wav")
				end
				proj_ctr := proj_ctr + 1
			elseif not (x + w < a_enemy.x or x > a_enemy.x + a_enemy.w // 8 or y + h < a_enemy.y or y > a_enemy.y + a_enemy.h) then
				if proj_ctr = 0 then
					x_vel := 0
					assigner_img_ptr_from_array(2)
					a_enemy.reduce_life
				elseif proj_ctr = 3 then
					assigner_img_ptr_from_array(3)
					shooting := false
					create l_egg_broke.make ("Ressources/Sounds/egg_crack_1.wav")
				end
				proj_ctr := proj_ctr + 1
			end
			apply_img(screen, create {POINTER}, x, y)
		end

end
