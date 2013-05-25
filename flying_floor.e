note
	description: "Classe désignant les parcelles de terre flotantes"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	FLYING_FLOOR

inherit
	IMAGE
	COLLISION

create
	make

feature {GAME} -- Make


	make(a_x, a_y:INTEGER_16)
	-- Initialisation
		local
			l_string_list:LIST[STRING]
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/Plaquette.png")
			create_image_list (l_string_list)
			set_start_pos(a_x, a_y)
		end

feature {GAME} -- Image

	----- Variables de classe -----
	flying_floor_ptr:POINTER
	-------------------------------

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

	apply_flying_floor(a_screen:POINTER)
	-- Applique l'image
		do
			apply_img(a_screen, create{POINTER}, x, y)
		end

feature {GAME} -- Coordonnées

	set_start_pos(a_x, a_y:INTEGER_16)
	-- Position de départ
		do
			x := a_x
			y := a_y
			w := get_img_w
			h := get_img_h
		end

	ff_x_pos:INTEGER_16
	-- Retourne x (Latitude)
		do
			Result := x
		end

	ff_y_pos:INTEGER_16
	-- Retourne x (Altitude)
		do
			Result := y
		end

feature {ANY}

	box:TUPLE[left, right, top, bottom:INTEGER_16]
		do
			Result := [x, x + w, y, y + h]
		end
end
