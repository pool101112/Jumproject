note
	description: "Summary description for {MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU

inherit
	IMAGE

create
	make

feature {GAME} -- Affichage du menu

	menu_img_path:STRING
	x, y, w, h:INTEGER_16

	make (a_path:STRING)
		do
			menu_img_path := a_path
			assigner_ptr_image
		end

	assigner_ptr_image
		do
			create_img_ptr (menu_img_path)
		end

	assign_img_path (a_path:STRING_8)
		do
			menu_img_path := a_path
		end

	apply_background(a_screen:POINTER)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_img(a_screen, create{POINTER}, 0, 0)
		end

	apply_element_with_coordinates(a_screen:POINTER; a_x, a_y:INTEGER_16)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			x := a_x
			y := a_y
			w := get_img_w
			h := get_img_h
			apply_img(a_screen, create{POINTER}, a_x, a_y)
		end

	apply_element(a_screen:POINTER)
		do
			apply_img(a_screen, create{POINTER}, x, y)
		end

	change_x(a_x:INTEGER_16)
		do
			x := a_x
		end

	change_y(a_y:INTEGER_16)
		do
			y := a_y
		end
end
