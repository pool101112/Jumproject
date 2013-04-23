note
	description: "Classe désignant les parcelles de terre flotantes"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	FLYING_FLOOR

inherit
	GROUND

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
			apply_img(a_screen, create{POINTER}, ff_x, ff_y)
		end

feature {GAME} -- Coordonnées

	----- Variables de classe -----
	ff_x, ff_y, ff_w, ff_h:INTEGER_16
	-------------------------------

	set_start_pos(a_x, a_y:INTEGER_16)
	-- Position de départ
		do
			ff_x := a_x
			ff_y := a_y
			ff_w := get_img_w
			ff_h := get_img_h
		end

	ff_x_pos:INTEGER_16
	-- Retourne x (Latitude)
		do
			Result := ff_x
		end

	ff_y_pos:INTEGER_16
	-- Retourne x (Altitude)
		do
			Result := ff_y
		end

	ff_box_array:ARRAY[INTEGER]
	-- Retourne un array contenant les coordonnées
		local
			l_ff_box:ARRAY[INTEGER]
		do
			create l_ff_box.make_filled (0, 1, 4)
			l_ff_box[1] := ff_x
			l_ff_box[2] := ff_y
			l_ff_box[3] := ff_w
			l_ff_box[4] := ff_h
			Result := l_ff_box
		end
end
