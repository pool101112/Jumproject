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

	make (a_path_list:LIST[STRING]; a_screen:POINTER)
		do
			screen := a_screen
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

	apply_background
		do
			apply_img(screen, create{POINTER}, 0, 0)
		end

	fill_background(a_color:NATURAL_32)
		do
			apply_fill(screen, a_color)
		end
end
