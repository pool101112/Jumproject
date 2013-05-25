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
	image_rect:POINTER

	make (a_path_list:LIST[STRING])
		do
			create_image_list (a_path_list)
			image_rect := create{POINTER}
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
		end

	apply_background(a_screen:POINTER)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			apply_img(a_screen, image_rect, 0, 0)
		end

	apply_element_with_coordinates(a_screen:POINTER; a_x, a_y:INTEGER_16)
		require
			a_screen_is_not_null : not a_screen.is_default_pointer
		do
			x := a_x
			y := a_y
			w := get_img_w
			h := get_img_h
			apply_img(a_screen, image_rect, a_x, a_y)
		end

	apply_element(a_screen:POINTER)
		do
			apply_img(a_screen, image_rect, x, y)
		end

	set_image_rect(a_image_rect:POINTER)
		do
			image_rect := a_image_rect
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
