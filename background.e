note
	description: "Classe d�signant l'image de fond"
	author: "Marc-Andr� Douville Auger"
	date: "21 F�vrier 2013"
	revision: ""

class
	BACKGROUND

inherit
	IMAGE

feature {GAME} -- Image
	assigner_ptr_image
		do
			create_img_ptr("Ressources/background.bmp")
		end

	apply_background(a_screen:POINTER)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_img(a_screen, create{POINTER}, 0, 0)
		end
end
