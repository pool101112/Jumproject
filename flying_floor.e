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
		do
			assigner_ptr_image
			set_start_pos(a_x, a_y)
		end

feature {GAME} -- Image

	----- Variables de classe -----
	flying_floor_ptr:POINTER
	-------------------------------

	assigner_ptr_image
	-- Assigne l'image
		do
			create_img_ptr("Ressources/Images/Plaquette.png")
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
