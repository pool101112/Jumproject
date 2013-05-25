note
	description: "Classe désignant les pouvoirs présent dans le jeu"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	POWER_UPS

inherit
	IMAGE
	COLLISION

create
	make

feature -- Access

	make (a_path_list:LIST[STRING]; a_screen:POINTER)
		do
			screen := a_screen
			create_image_list (a_path_list)
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
			x := 400
			y := 100
		end

	change_x (a_x:INTEGER_16)
		do
			x := a_x
		end

	change_y (a_y:INTEGER_16)
		do
			y := a_y
		end

	apply_to_screen
		do
			apply_img(screen, create {POINTER}, x, y)
		end

	box:TUPLE[left, right, top, bottom:INTEGER_16]
		do
			Result := [x, x + w, y, y + h]
		end

	reduce_respawn_ctr
		do
			respawn_ctr := respawn_ctr - 1
		end

	reset_respawn_ctr
		do
			respawn_ctr := 50
		end

	is_active:BOOLEAN
	respawn_ctr:INTEGER_16

end
