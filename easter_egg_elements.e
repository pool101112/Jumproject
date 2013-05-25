note
	description: "Summary description for {EASTER_EGG_ELEMENTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EASTER_EGG_ELEMENT

inherit
	IMAGE

create
	make

feature {EASTER_EGG} -- Constructeur

	make (a_path_list:LIST[STRING]; a_screen:POINTER; a_x, a_y:INTEGER_16)
		do
			screen := a_screen
			x := a_x
			y := a_y
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
		end

	assign_ptr (a_index:INTEGER_8)
		do
			assigner_img_ptr (a_index)
		end

feature {EASTER_EGG} -- Affichage

	apply_to_screen(a_image_rect:POINTER)
		do
			apply_img (screen, a_image_rect, x, y)
		end


	change_x (a_x:INTEGER_16)
		do
			x := a_x
		end

	change_y (a_y:INTEGER_16)
		do
			y := a_y
		end

feature {NONE} -- Variables de classe

	path_list:LIST[STRING]

end
