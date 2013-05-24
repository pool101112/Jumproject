note
	description: "Summary description for {EASTER_EGG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EASTER_EGG

create
	make

feature {GAME} -- Constructeur

	make(a_screen:POINTER)
		require
			a_screen_is_not_null: not a_screen.is_default_pointer
		do
			screen := a_screen
			easter_part_1_activated := false
			easter_part_2_activated := false
			egg_hits := 1
			easter_ctr := 1
			create_y_part
			create_egg
			create_i_dot
			create egg_crack_sound.make ("Ressources/Sounds/egg_crack_1.wav")
			ensure
				screen_is_not_null: not screen.is_default_pointer
		end


feature {NONE} -- Creation des éléments

	create_y_part
		local
			l_string_list:LIST[STRING]
			l_i:INTEGER_8
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (5)
			l_string_list.extend ("Ressources/Images/Easter_egg/y_part_1.png")
			from
				l_i := 1
			until
				l_i > 4
			loop
				l_string_list.extend ("Ressources/Images/Easter_egg/y_part_f_" + l_i.out + ".png")
				l_i := l_i + 1
			end
			create y_part.make (l_string_list, screen, 246, 18)
		end

	create_egg
		local
			l_string_list:LIST[STRING]
			l_i:INTEGER_8
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (3)
			from
				l_i := 1
			until
				l_i > 3
			loop
				l_string_list.extend ("Ressources/Images/Easter_egg/menu_egg_f_" + l_i.out + ".png")
				l_i := l_i + 1
			end
			create egg.make (l_string_list, screen, 248, 34)
		end

	create_i_dot
		local
			l_string_list:LIST[STRING]
			l_i:INTEGER_8
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (21)
			l_string_list.extend ("Ressources/Images/Easter_egg/i_dot.png")
			from
				l_i := 1
			until
				l_i > 20
			loop
				l_string_list.extend ("Ressources/Images/Easter_egg/i_dot_" + l_i.out + ".png")
				l_i := l_i + 1
			end
			create i_dot.make (l_string_list, screen, 314, 27)
		end

feature {GAME} -- Activation des éléments

	activate_y_part
		do
			easter_part_1_activated := true
		end

	y_part_activation
		do
			if easter_part_1_activated and not part_1_done then
				if easter_ctr <= 3 then
					y_part.assign_ptr (easter_ctr + 2)
					y_part.change_y (y_part.y - 2)
					easter_ctr := easter_ctr + 1
					if easter_ctr = 4 then
						y_part.change_x (y_part.x - 3)
						crack_egg
						easter_ctr := 1
						part_1_done := true
					end
				end
			end
		end

	activate_i_dot
		do
			easter_part_2_activated := true
		end

	i_dot_activation
		do
			if easter_part_2_activated and not part_2_done then
				if easter_ctr <= 7 then
					i_dot.change_y (i_dot.y - 4)
					i_dot.change_x (i_dot.x + 2)
					i_dot.assign_ptr (easter_ctr + 1)
				elseif easter_ctr <= 19 then
					i_dot.change_x (i_dot.x + 8)
				elseif easter_ctr <= 24 then
					i_dot.change_y (i_dot.y + 4)
					i_dot.change_x (i_dot.x + 4)
					i_dot.assign_ptr (easter_ctr - 12)
				elseif easter_ctr <= 31 then
					i_dot.change_y (i_dot.y + 6)
				elseif easter_ctr <= 36 then
					i_dot.change_y (i_dot.y + 2)
					i_dot.change_x (i_dot.x - 2)
					i_dot.assign_ptr (easter_ctr - 19)
				elseif easter_ctr <= 50 then
					i_dot.change_x (i_dot.x - 12)
				elseif easter_ctr <= 55 then
					i_dot.change_y (i_dot.y - 2)
					i_dot.change_x (i_dot.x - 2)
					i_dot.assign_ptr (easter_ctr - 34)
				end
				easter_ctr := easter_ctr + 1
				if easter_ctr > 56 then
					i_dot.assign_ptr (1)
					crack_egg
					easter_ctr := 1
					part_2_done := true
				end
			end
		end

	crack_egg
		do
			egg_hits := egg_hits + 1
			egg_crack_sound.play_sound
			egg.assign_ptr (egg_hits)
		end



feature {GAME} -- Affichage

	apply_easter_egg_elements
		do
			y_part_activation
			y_part.apply_to_screen
			i_dot_activation
			i_dot.apply_to_screen
			egg.apply_to_screen
		end

feature {GAME} -- Variables de classe public
	y_part, i_dot, egg:EASTER_EGG_ELEMENT
	egg_hits:INTEGER_8

feature {NONE} -- Variables de classe privées
	screen:POINTER
	easter_ctr:INTEGER_8
	easter_part_1_activated, easter_part_2_activated:BOOLEAN
	part_1_done, part_2_done:BOOLEAN
	egg_crack_sound:SOUND

end
