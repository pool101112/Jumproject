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
			path_list := a_path_list
			x := a_x
			y := a_y
			assigner_ptr_image
		end

	assigner_ptr_image
		local
			l_i:INTEGER_8
		do
			create_img_ptr_list
			from
				l_i := 1
			until
				l_i > path_list.count
			loop
				create_img_ptr_new (path_list[l_i])
				l_i := l_i + 1
			end
			assign_ptr (1)
		end

	assign_ptr (a_index:INTEGER_8)
		do
			assigner_img_ptr_from_array (a_index)
		end

feature {EASTER_EGG} -- Affichage

	apply_to_screen
		do
			apply_img (screen, create {POINTER}, x, y)
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
