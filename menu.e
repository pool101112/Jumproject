note
	description: "Summary description for {MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU

inherit
	IMAGE

feature {GAME} -- Affichage du menu

	assigner_ptr_image
		do
			create_img_ptr("Ressources/menu_screen.png")
		end

	apply_background(a_screen:POINTER)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_img(a_screen, create{POINTER}, 0, 0)
		end
end
