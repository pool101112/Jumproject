note
	description: "Classe désignant l'image de fond"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	BACKGROUND

inherit
	IMAGE

create
	make

feature {GAME} -- Image

	make
		do
			assigner_ptr_image
		end

	assigner_ptr_image
		do
			create_img_ptr("Ressources/background.bmp")
		end

	assigner_game_over
		do
			create_img_ptr("Ressources/Images/game_over2.png")
		end

	apply_background(a_screen:POINTER)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_img(a_screen, create{POINTER}, 0, 0)
		end

	fill_background(a_screen:POINTER; a_color:NATURAL_32)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_fill(a_screen, a_color)
		end
end
