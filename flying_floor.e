note
	description: "Classe d�signant les parcelles de terre flotantes"
	author: "Marc-Andr� Douville Auger"
	date: "21 F�vrier 2013"
	revision: ""

class
	FLYING_FLOOR

inherit
	IMAGE

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
			create_img_ptr("Ressources/flying_floor.png")
		end

	apply_flying_floor(a_screen:POINTER)
	-- Applique l'image
		do
			apply_img(a_screen, create{POINTER}, image_x, image_y)
		end

feature {GAME} -- Coordonn�es

	set_start_pos(a_x, a_y:INTEGER_16)
	-- Position de d�part
		do
			image_x := a_x
			image_y := a_y
			image_w := get_img_w
			image_h := get_img_h
		end

	ff_x_pos:INTEGER_16
	-- Retourne x (Latitude)
		do
			Result := image_x
		end

	ff_y_pos:INTEGER_16
	-- Retourne x (Altitude)
		do
			Result := image_y
		end

feature {ANY}

	ff_box:TUPLE[INTEGER_16, INTEGER_16, INTEGER_16, INTEGER_16]
		do
			Result := [image_x, image_x + image_w, image_y, image_y + image_h]
		end
end
