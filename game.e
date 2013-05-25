note
	description: "Classe principale utilisant les autres classes pour faire fonctionner le jeu"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	GAME

create
	make

feature {NONE} -- Main

--	make
--		local
--			l_memoire:MEMORY
--		do
--			make1
--			l_memoire.full_collect
--			{SDL_WRAPPER}.SDL_Quitter()
--		end

	make
	-- Run application.
		local
			l_screen:POINTER
		do
			init_sdl_video
			l_screen := init_screen
			apply_title
			apply_icon
			init_sdl_audio
			start_music
			main_menu(l_screen)
		end

	main_menu(a_screen:POINTER)
		local
			l_event_ptr:POINTER
			l_exit, l_go_singleplayer_menu, l_go_multiplayer_menu, l_egg_is_hidden:BOOLEAN
			l_string_list:LIST[STRING]

			l_menu, l_singleplayer_button, l_multiplayer_button, l_quit_button, l_egg_pointer:MENU
			l_easter_egg:EASTER_EGG
		do
			-- Initialisation de l_screen
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/menu_screen4.png")
			create l_menu.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Single_Player2.png")
			create l_singleplayer_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Multiplayer2.png")
			create l_multiplayer_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Quit2.png")
			create l_quit_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/yoshi_egg.png")
			create l_egg_pointer.make (l_string_list)
			create l_easter_egg.make(a_screen)
			l_egg_pointer.change_x(160)
			l_event_ptr := size_of_event_memory_allocation

			from
			until
				l_exit
			loop
				if l_go_singleplayer_menu then
					singleplayer_menu(a_screen)
					l_go_singleplayer_menu := False
				elseif l_go_multiplayer_menu then
					multiplayer_menu(a_screen)
					l_go_multiplayer_menu := False
				end
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent (l_event_ptr) < 1
				loop
					l_egg_is_hidden := True
					if quit_request(l_event_ptr) then
						l_exit := True
					elseif over_button(l_event_ptr, l_singleplayer_button) then
						l_egg_pointer.change_y(l_singleplayer_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_go_singleplayer_menu := True
						end
					elseif over_button(l_event_ptr, l_multiplayer_button) then
						l_egg_pointer.change_y(l_multiplayer_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_go_multiplayer_menu := True
						end
					elseif over_button(l_event_ptr, l_quit_button) then
						l_egg_pointer.change_y (l_quit_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_exit := True
						end
					elseif over_element(l_event_ptr, l_easter_egg.y_part) then
						if click(l_event_ptr) then
							l_easter_egg.activate_y_part
						end
					elseif over_element(l_event_ptr, l_easter_egg.i_dot) then
						if click(l_event_ptr) then
							l_easter_egg.activate_i_dot
						end
					end
				end
				l_menu.apply_background (a_screen)
				l_easter_egg.apply_easter_egg_elements
				l_singleplayer_button.apply_element_with_coordinates (a_screen, 200, 80)
				l_multiplayer_button.apply_element_with_coordinates (a_screen, 200, (l_singleplayer_button.y + 45))
				l_quit_button.apply_element_with_coordinates (a_screen, 200, (l_multiplayer_button.y + 50))
				if not l_egg_is_hidden then
					l_egg_pointer.apply_element (a_screen)
				end
				refresh(a_screen, 35)
			end
			quit_game
		end

	singleplayer_menu(a_screen:POINTER)
		local
			l_event_ptr:POINTER
			l_exit, l_play_single, l_egg_is_hidden, l_player_name_not_changed, l_is_server:BOOLEAN
--			l_player_name, l_old_player_name:STRING
			l_string_list:LIST[STRING]

			l_menu, l_start_button, l_back_button, l_egg:MENU
			l_database:DATABASE
			l_player_name_entry:SCORE
		do
			-- Initialisation de l_screen
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/menu_screen3.png")
			create l_menu.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Start2.png")
			create l_start_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Back2.png")
			create l_back_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/yoshi_egg.png")
			create l_egg.make (l_string_list)
			l_egg.change_x(160)
--			create l_player_name_entry.make(20)
--			l_player_name := "Nom: "
--			l_player_name_entry.assigner_score (l_player_name)
--			l_player_name_entry.change_color (0, 175, 175)
			create l_database.make

--			l_player_name := "Nom: "
--			l_player_name_not_changed := True

			l_event_ptr := size_of_event_memory_allocation
			from
			until
				l_exit
			loop
				l_is_server := False
				if l_play_single then
					single_player (a_screen, l_database)
					l_play_single := False
				end
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent (l_event_ptr) < 1
				loop
					l_egg_is_hidden := True
					if quit_request(l_event_ptr) then
						l_exit := True
					elseif over_button(l_event_ptr, l_start_button) then
						l_egg.change_y(l_start_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_play_single := True
						end
					elseif over_button(l_event_ptr, l_back_button) then
						l_egg.change_y (l_back_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_exit := True
						end
					end
--					l_old_player_name := l_player_name
--					if l_player_name.count < 15 then
--						l_player_name := l_player_name + name_entry_letter (l_event_ptr)
--					end
--					if delete_character(l_event_ptr) then
--						if not l_player_name.is_equal ("Nom: ") then
--							l_player_name := l_player_name.substring (1, (l_player_name.count - 1))
--						end
--					end
--					if not l_player_name.is_equal (l_old_player_name) OR l_player_name_not_changed then
--						l_player_name_entry.assigner_score (l_player_name)
--						l_player_name_not_changed := False
--					end
				end
				l_menu.apply_background (a_screen)
				l_start_button.apply_element_with_coordinates (a_screen, 200, 80)
				l_back_button.apply_element_with_coordinates (a_screen, 200, (l_start_button.y + 50))
				if not l_egg_is_hidden then
					l_egg.apply_element (a_screen)
				end
--				l_player_name_entry.apply_text (a_screen, 190, (l_back_button.y + 50))
				refresh(a_screen, 35)
			end
		end

	multiplayer_menu(a_screen:POINTER)
		local
			l_event_ptr:POINTER
			l_exit, l_egg_is_hidden, l_is_server, l_ip_address_not_changed:BOOLEAN
			l_ip_address, l_old_ip_adress:STRING
			l_string_list:LIST[STRING]

			l_menu, l_host_button, l_connect_button, l_back_button, l_egg:MENU
			l_database:DATABASE
			l_ip_address_entry:SCORE
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/menu_screen3.png")
			create l_menu.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Host2.png")
			create l_host_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Connect2.png")
			create l_connect_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/Back2.png")
			create l_back_button.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/yoshi_egg.png")
			create l_egg.make (l_string_list)
			l_egg.change_x(160)
			create l_ip_address_entry.make(20)
			l_ip_address := "IP: "
			l_ip_address_entry.change_color (0, 175, 175)
			l_ip_address_entry.assigner_score (l_ip_address)
			create l_database.make

			l_ip_address_not_changed := True

			l_event_ptr := size_of_event_memory_allocation
			l_is_server := False
			from
			until
				l_exit
			loop
--				if l_play_multi then
--					if l_ip_address.is_equal ("Nom: server") then
--						l_is_server := True
--					end
--					multiplayer (a_screen, l_database, l_is_server)
--					l_play_multi := False
--				end
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent (l_event_ptr) < 1
				loop
					l_egg_is_hidden := True
					if quit_request(l_event_ptr) then
						l_exit := True
					elseif over_button(l_event_ptr, l_connect_button) then
						l_egg.change_y(l_connect_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_is_server := False
							multiplayer (a_screen, l_database, l_is_server, l_ip_address.substring (5, l_ip_address.count))
						end
					elseif over_button(l_event_ptr, l_host_button) then
						l_egg.change_y(l_host_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_is_server := True
							multiplayer (a_screen, l_database, l_is_server, "")
						end
					elseif over_button(l_event_ptr, l_back_button) then
						l_egg.change_y (l_back_button.y + 5)
						l_egg_is_hidden := False
						if click(l_event_ptr) then
							l_exit := True
						end
					end
					l_old_ip_adress := l_ip_address
					if l_ip_address.count < 19 then
						l_ip_address := l_ip_address + name_entry_letter (l_event_ptr)
					end
					if delete_character(l_event_ptr) then
						if not l_ip_address.is_equal ("Nom: ") then
							l_ip_address := l_ip_address.substring (1, (l_ip_address.count - 1))
						end
					end
					if not l_ip_address.is_equal (l_old_ip_adress) OR l_ip_address_not_changed then
						l_ip_address_entry.assigner_score (l_ip_address)
						l_ip_address_not_changed := False
					end
				end
				l_menu.apply_background (a_screen)
				l_host_button.apply_element_with_coordinates (a_screen, 200, 80)
				l_connect_button.apply_element_with_coordinates (a_screen, 200, (l_host_button.y + 50))
				l_back_button.apply_element_with_coordinates (a_screen, 200, (l_connect_button.y + 50))
				if not l_egg_is_hidden then
					l_egg.apply_element (a_screen)
				end
				l_ip_address_entry.apply_text (a_screen, 190, (l_back_button.y + 50))
				refresh(a_screen, 35)
			end
		end

	single_player(a_screen:POINTER; a_database:DATABASE)
		local
			l_ctr:INTEGER_16
			l_time_game_started, l_time_alive, l_time_ctr:INTEGER_32
			l_event_ptr:POINTER
			l_game_over, l_game_won, l_spawning, l_quit:BOOLEAN
			l_string_list:LIST[STRING]

			-- Instances de classe
			l_bg:BACKGROUND
			l_enemy:ENEMY
			l_flying_floor, l_ff_two:FLYING_FLOOR
			l_player:PLAYER
			l_timer, l_boss_life:SCORE
			l_egg_lives, l_enemy_health_bar:MENU
			l_live_up:POWER_UPS
			l_artificial_intelligence_thread:AI_THREAD
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/background2.png")
			create l_bg.make (l_string_list, a_screen)
			create l_flying_floor.make (100, 165)
			create l_ff_two.make (350, 155)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/yoshi_life_up.png")
			create l_live_up.make (l_string_list, a_screen)
			create l_player.make(0, a_screen, l_flying_floor, l_ff_two, l_live_up)
			create l_enemy.make (a_screen, l_flying_floor, l_ff_two, l_player)
			create l_artificial_intelligence_thread.make (l_player, l_enemy, l_flying_floor, l_ff_two)
			create l_timer.make (20)
			create l_boss_life.make (25)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/egg_lives.png")
			create l_egg_lives.make (l_string_list)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/health_bar.png")
			create l_enemy_health_bar.make (l_string_list)
			-- Spawn
			l_spawning := False

			l_event_ptr := size_of_event_memory_allocation
			l_time_game_started := timer
			l_boss_life.assigner_score ("Boss Life : ")
			l_artificial_intelligence_thread.launch
			from
			until
				l_game_over or l_game_won or l_quit
			loop
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent(l_event_ptr) < 1
				loop
					if quit_request(l_event_ptr) then
						l_quit := true
					elseif not l_spawning then
						ingame_keys(l_player, l_event_ptr)
					end
				end
				l_time_alive := ((timer - l_time_game_started) // 10)
				l_timer.assigner_score (((timer - l_time_game_started) // 1000).out + "." + ((((timer - l_time_game_started) \\ 1000) // 100).out) + " Seconds")
				l_bg.apply_background
				l_player.adjust_lives
--				l_enemy.show_lives (a_screen)
				if l_spawning then
					l_player.apply_spawn
					l_enemy.apply_spawn
				else
					l_time_ctr := l_time_ctr + 1
					l_player.move
					l_player.animate
					if not l_enemy.is_dead then
						l_enemy.move
						l_enemy.animate
						l_enemy.apply_player
						l_enemy.collide_player
					end
					l_player.apply_player
				end
				l_flying_floor.apply_flying_floor(a_screen)
				l_ff_two.apply_flying_floor (a_screen)
				if l_player.shooting then
					l_player.apply_proj (l_enemy)
				end
				l_timer.apply_text (a_screen, 5, 35)
				l_boss_life.apply_text (a_screen, 5, 5)
				if l_live_up.respawn_ctr = 0 then
					l_live_up.apply_to_screen
					if l_player.collide_bonus then
						l_live_up.reset_respawn_ctr
					end
				else
					l_live_up.reduce_respawn_ctr
				end
				show_lives (a_screen, l_player, l_egg_lives)
				show_boss_health (a_screen, l_enemy, l_enemy_health_bar)
				refresh (a_screen, 12)
				if l_ctr < 74 then
					l_ctr := l_ctr + 1
				elseif l_ctr = 74 then
					l_spawning := false
				end
				if l_player.no_live then
					l_artificial_intelligence_thread.stop
					l_artificial_intelligence_thread.join
					if a_database.player_exist ("Highscore") then
						if l_time_alive > a_database.get_time_played ("Highscore") then
							a_database.update_table ("Highscore", 0, l_time_alive)
						end
					else
						a_database.insert_table ("Highscore", l_time_alive)
					end
					l_game_over := True
--				elseif l_enemy.is_dead then
--					l_artificial_intelligence_thread.stop
--					l_artificial_intelligence_thread.join
--					if a_database.player_exist ("Highscore") then
--						if l_time_alive > a_database.get_time_played ("Highscore") then
--							a_database.update_table ("Highscore", 0, l_time_alive)
--						end
--					else
--						a_database.insert_table ("Highscore", l_time_alive)
--					end
--					l_game_won := true
				end
			end
			if l_game_over then
				game_over(a_screen)
			elseif l_game_won then
				game_won(a_screen)
			end
		end

	multiplayer(a_screen:POINTER; a_database:DATABASE; a_is_server:BOOLEAN; a_ip_address:STRING)
		local
			l_ctr:INTEGER_16
			l_time_game_started, l_time_alive, l_time_ctr:INTEGER_32
			l_event_ptr:POINTER
			l_game_over, l_spawning:BOOLEAN
			l_string_list:LIST[STRING]

			-- Instances de classe
			l_bg:BACKGROUND
			l_enemy:ENEMY
			l_flying_floor, l_ff_two:FLYING_FLOOR
			l_player:PLAYER
			l_timer, l_highscore, l_last_game:SCORE
			l_network_thread:NETWORK_THREAD
			l_live_up:POWER_UPS
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/background2.png")
			create l_bg.make (l_string_list, a_screen)
			create l_flying_floor.make (100, 165)
			create l_ff_two.make (350, 155)
			l_string_list.wipe_out
			l_string_list.extend ("Ressources/Images/yoshi_life_up.png")
			create l_live_up.make (l_string_list, a_screen)
			if a_is_server then
				create l_player.make(0, a_screen, l_flying_floor, l_ff_two, l_live_up)
			else
				create l_player.make(1, a_screen, l_flying_floor, l_ff_two, l_live_up)
			end
			create l_enemy.make (a_screen, l_flying_floor, l_ff_two, l_player)
			create l_timer.make (30)
			create l_network_thread.make(a_is_server, l_enemy, l_player, a_ip_address)
--			if not a_is_server then
--				l_player_old_x := l_player.x
--				l_player.change_x (l_enemy.x)
--				l_enemy.change_x (l_player_old_x)
--			end

			l_time_ctr := 0
			-- Spawn
			l_spawning := False
			l_event_ptr := size_of_event_memory_allocation
			l_time_game_started := timer
			l_network_thread.launch
			from
			until
				l_game_over
			loop
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent(l_event_ptr) < 1
				loop
					if quit_request(l_event_ptr) then
						l_game_over := true
					elseif not l_spawning then
						ingame_keys(l_player, l_event_ptr)
					end
				end
				if not l_spawning then
					l_player.move
					l_time_ctr := l_time_ctr + 1
--					l_player.animate
					l_enemy.animate
				end
				l_time_alive := ((timer - l_time_game_started) // 10)
				l_timer.assigner_score (((timer - l_time_game_started) // 1000).out + "." + ((((timer - l_time_game_started) \\ 1000) // 100).out) + " Seconds")
				l_bg.apply_background
				l_player.adjust_lives
--				l_enemy.show_lives (a_screen)
				if l_spawning then
					l_player.apply_spawn
					l_enemy.apply_spawn
				else
					l_player.apply_player
					l_enemy.apply_player
				end
				if l_live_up.respawn_ctr = 0 then
					l_live_up.apply_to_screen
					if l_player.collide_bonus then
						l_live_up.reset_respawn_ctr
					end
				else
					l_live_up.reduce_respawn_ctr
				end
				l_flying_floor.apply_flying_floor(a_screen)
				l_ff_two.apply_flying_floor (a_screen)
				l_timer.apply_text (a_screen, 5, 35)
				l_highscore.apply_text (a_screen, 5, 5)
				l_last_game.apply_text (a_screen, 5, 20)
				refresh (a_screen, 12)
				if l_ctr < 74 then
					l_ctr := l_ctr + 1
				elseif l_ctr = 74 then
					l_spawning := false
				end
				if l_player.no_live then
					if a_database.player_exist ("Highscore") then
						if l_time_alive > a_database.get_time_played ("Highscore") then
							a_database.update_table ("Highscore", 0, l_time_alive)
						end
					else
						a_database.insert_table ("Highscore", l_time_alive)
					end
					if a_database.player_exist ("LastGame") then
						a_database.update_table ("LastGame", 0, l_time_alive)
					else
						a_database.insert_table ("LastGame", l_time_alive)
					end
					l_game_over := True
				end
			end
			l_network_thread.stop
			l_network_thread.join
		end

feature {NONE} -- Menu

	over_button(a_event_ptr:POINTER; a_button:MENU):BOOLEAN
		local
			l_mouse_x, l_mouse_y:INTEGER_16
		do
			Result := False
			l_mouse_x := {SDL_WRAPPER}.get_SDL_MouseButtonEvent_x(a_event_ptr)
			l_mouse_y := {SDL_WRAPPER}.get_SDL_MouseButtonEvent_y(a_event_ptr)
			if (l_mouse_x >= a_button.x AND l_mouse_x <= (a_button.x + a_button.w)) AND (l_mouse_y >= a_button.y AND l_mouse_y <= (a_button.y + a_button.h)) then
				Result := True
			end
		end

	over_element(a_event_ptr:POINTER; a_element:EASTER_EGG_ELEMENT):BOOLEAN
		local
			l_mouse_x, l_mouse_y:INTEGER_16
		do
			Result := False
			l_mouse_x := {SDL_WRAPPER}.get_SDL_MouseButtonEvent_x(a_event_ptr)
			l_mouse_y := {SDL_WRAPPER}.get_SDL_MouseButtonEvent_y(a_event_ptr)
			if (l_mouse_x >= a_element.x AND l_mouse_x <= (a_element.x + a_element.w)) AND (l_mouse_y >= a_element.y AND l_mouse_y <= (a_element.y + a_element.h)) then
				Result := True
			end
		end

	click(a_event_ptr:POINTER):BOOLEAN
		local
			l_event:NATURAL_8
			l_mouse_button_ptr:NATURAL_8
		do
			Result := False
			l_event := {SDL_WRAPPER}.get_SDL_Event_type(a_event_ptr)
			if l_event = {SDL_WRAPPER}.SDL_MOUSEBUTTONDOWN then
				l_mouse_button_ptr := {SDL_WRAPPER}.get_SDL_MouseButtonEvent_button(a_event_ptr)
				if l_mouse_button_ptr = {SDL_WRAPPER}.SDL_BUTTON_LEFT then
					Result := True
				end
			end
		end

	delete_character(a_event_ptr:POINTER):BOOLEAN
		local
				l_event:NATURAL_8
				l_keyboard_event_ptr, l_keysym:POINTER
				l_sym:INTEGER
			do
				Result := False
				l_keyboard_event_ptr := size_of_keysym_memory_allocation
				l_event := {SDL_WRAPPER}.get_SDL_Event_type(a_event_ptr)
				if l_event = {SDL_WRAPPER}.SDL_KEYDOWN then
					l_keyboard_event_ptr := keyboard_event (a_event_ptr)
					l_keysym := keysym (l_keyboard_event_ptr)
					l_sym := sym (l_keysym)
					if l_sym = {SDL_WRAPPER}.SDLK_BACKSPACE then
						Result := True
					end
				end
			end

	name_entry_letter(a_event_ptr:POINTER):STRING_8
		local
			l_event:NATURAL_8
			l_keyboard_event_ptr, l_keysym:POINTER
			l_sym:INTEGER
			l_keyname:C_STRING
			l_keyname_str:STRING
		do
			Result := ""
			l_keyboard_event_ptr := size_of_keysym_memory_allocation
			l_event := {SDL_WRAPPER}.get_SDL_Event_type(a_event_ptr)
			if l_event = {SDL_WRAPPER}.SDL_KEYDOWN then
				l_keyboard_event_ptr := keyboard_event (a_event_ptr)
				l_keysym := keysym (l_keyboard_event_ptr)
				l_sym := sym (l_keysym)
				create l_keyname.make_by_pointer ({SDL_WRAPPER}.SDL_GetKeyName(l_sym))
				l_keyname_str := l_keyname.string
				if l_keyname_str.count = 1 then
					--if (l_keyname_str[1] >= 'a' AND l_keyname_str[1] <= 'z') OR (l_keyname_str[1] >= '0' AND l_keyname_str[1] <= '9') then
					if ((l_keyname_str[1] >= '0' and l_keyname_str[1] <= '9') or l_keyname_str[1] = '.') then
						Result := l_keyname_str
					end
				end
			end
		end

	start_music
		do
--			if {SDL_WRAPPER}.Mix_Init(0) < 0 then
--				print("Error at sound")
--			end
			open_audio
			load_music
		end

	close_audio
		do
			{SDL_WRAPPER}.Mix_CloseAudio
		end

	open_audio
		local
			l_default_format:NATURAL_16
		do
			l_default_format := {SDL_WRAPPER}.MIX_DEFAULT_FORMAT
			if {SDL_WRAPPER}.Mix_OpenAudio(44100, l_default_format, 2, 4096) < 0 then
				print("Error OpenAudio")
			end
		end

	load_music
		local
			l_music_path:C_STRING
			l_music:POINTER
		do
			create l_music_path.make ("Ressources/test.ogg")
			l_music := {SDL_WRAPPER}.Mix_LoadMUS(l_music_path.item)
			if {SDL_WRAPPER}.Mix_PlayMusic(l_music, 1) < 0 then
				print("Error PlayMusic")
			end
		end

	apply_title
		local
			l_title:C_STRING
		do
			create l_title.make ("Jumproject")
			{SDL_WRAPPER}.SDL_WM_SetCaption(l_title.item, create{POINTER})
		end

	apply_icon
		local
			l_icon:C_STRING
			l_icon_ptr:POINTER
		do
			create l_icon.make ("Ressources/Images/icon.png")
			l_icon_ptr := {SDL_WRAPPER}.SDL_IMG_Load(l_icon.item)
			{SDL_WRAPPER}.SDL_WM_SetIcon(l_icon_ptr, create{POINTER})
		end

	show_lives(a_screen:POINTER; a_player:PLAYER; a_egg_lives:MENU)
		local
			l_score:SCORE
		do
			a_egg_lives.apply_element_with_coordinates (a_screen, 450, 5)
			l_score := a_player.score
			l_score.apply_text (a_screen, a_egg_lives.x + 30 , 5)
		end

	show_boss_health(a_screen:POINTER; a_enemy:ENEMY; a_enemy_health_bar:MENU)
		local
			l_image_target, l_memory_manager:POINTER
		do
			l_image_target := l_memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Rect)

			{SDL_WRAPPER}.set_target_area_x(l_image_target, 0)
			{SDL_WRAPPER}.set_target_area_y(l_image_target, 0)
			{SDL_WRAPPER}.set_target_area_w(l_image_target, a_enemy.life * 2)
			{SDL_WRAPPER}.set_target_area_h(l_image_target, a_enemy_health_bar.h)

			a_enemy_health_bar.set_image_rect (l_image_target)

			a_enemy_health_bar.apply_element_with_coordinates (a_screen, 175, 10)
		end

feature {NONE} -- Jeu

	game_over (a_screen:POINTER)
		local
			l_game_over_sound:SOUND
			l_bg:BACKGROUND
			l_game_over_time:INTEGER_32
			l_event_ptr:POINTER
			l_quit:BOOLEAN
			l_string_list:LIST[STRING]
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/game_over2.png")
			create l_bg.make (l_string_list, a_screen)
			create l_game_over_sound.make ("Ressources/Sounds/98874__robinhood76__01850-cartoon-dissapoint.wav")
			l_event_ptr := size_of_event_memory_allocation
			{SDL_WRAPPER}.Mix_PauseMusic
			l_game_over_sound.play_sound
			l_bg.apply_background
			refresh (a_screen, 12)
			l_game_over_time := timer
			from
			until
				timer - l_game_over_time > 5000 OR l_quit
			loop
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent(l_event_ptr) < 1
				loop
					if quit_request(l_event_ptr) then
						l_quit := true
					end
				end
			end
			-- {SDL_WRAPPER}.Mix_StopChannel()
			{SDL_WRAPPER}.Mix_ResumeMusic
		end

	game_won (a_screen:POINTER)
		local
--			l_game_won_sound:SOUND
			l_bg:BACKGROUND
			l_game_won_time:INTEGER_32
			l_event_ptr:POINTER
			l_quit:BOOLEAN
			l_string_list:LIST[STRING]
		do
			create {ARRAYED_LIST[STRING]} l_string_list.make (1)
			l_string_list.extend ("Ressources/Images/Game_ending/Win1.png")
			create l_bg.make (l_string_list, a_screen)
			l_bg.apply_background
--			create l_game_won_sound.make ("Ressources/Sounds/98874__robinhood76__01850-cartoon-dissapoint.wav")
			l_event_ptr := size_of_event_memory_allocation
			{SDL_WRAPPER}.Mix_PauseMusic
--			l_game_won_sound.play_sound
			refresh (a_screen, 12)
			l_game_won_time := timer
			from
			until
				timer - l_game_won_time > 5000 OR l_quit
			loop
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent(l_event_ptr) < 1
				loop
					if quit_request(l_event_ptr) then
						l_quit := true
					end
				end
			end
			{SDL_WRAPPER}.Mix_ResumeMusic
		end

	print_help
	-- https://translate.google.ca/?q=print+help&oe=utf-8&aq=t&rls=org.mozilla:fr:official&client=firefox-a&um=1&ie=UTF-8&hl=fr&sa=N&tab=wT
		do
			print ("Hotkeys:%N")
			print ("========%N")
			print ("H: Help%N")
			print ("Down Arrow: Save player score & playtime%N")
			print ("Up Arrow: Show player score & playtime%N")
			print ("Return(Enter): Show all players scores & playtimes%N")
			print ("Backspace: WARNING! Deletes ALL players with their scores & playtimes%N")
			print ("%N%N%N")
		end

	ingame_keys(a_player:PLAYER; a_event_ptr:POINTER)
	-- Gestion des touches lors d'une partie
		local
			l_event:NATURAL_8
			l_keyboard_event_ptr, l_keysym:POINTER
			l_sym:INTEGER
		do
			l_keyboard_event_ptr := size_of_keysym_memory_allocation
			l_event := {SDL_WRAPPER}.get_SDL_Event_type(a_event_ptr)
			if l_event = {SDL_WRAPPER}.SDL_KEYDOWN then
				l_keyboard_event_ptr := keyboard_event (a_event_ptr)
				l_keysym := keysym (l_keyboard_event_ptr)
				l_sym := sym (l_keysym)
				if l_sym = {SDL_WRAPPER}.SDLK_LEFT then
					a_player.set_move_left
				elseif l_sym = {SDL_WRAPPER}.SDLK_RIGHT then
					a_player.set_move_right
				elseif l_sym = {SDL_WRAPPER}.SDLK_UP then
					a_player.set_jump
				elseif l_sym = {SDL_WRAPPER}.SDLK_SPACE then
					a_player.shoot
				elseif l_sym = {SDL_WRAPPER}.SDLK_h then
					print_help
				end

			elseif l_event = {SDL_WRAPPER}.SDL_KEYUP then
				l_keyboard_event_ptr := keyboard_event (a_event_ptr)
				l_keysym := keysym (l_keyboard_event_ptr)
				l_sym := sym (l_keysym)
				if l_sym = {SDL_WRAPPER}.SDLK_LEFT then
					a_player.set_stop_left
				elseif l_sym = {SDL_WRAPPER}.SDLK_RIGHT then
					a_player.set_stop_right
				end
			end
		end

	quit_request(a_event_ptr:POINTER):BOOLEAN
	-- Vérifie si l'usager a demandé de quitter
		local
			l_event:NATURAL_8
		do
			l_event := {SDL_WRAPPER}.get_SDL_Event_type(a_event_ptr)
			if l_event = {SDL_WRAPPER}.SDL_QUIT then
				Result := True
			else
				Result := False
			end
		end

	quit_game
	-- Ferme le jeu
		do
			{SDL_WRAPPER}.SDL_Quitter
		end

	timer:INTEGER
		do
			Result := ({SDL_WRAPPER}.get_SDL_ticks).as_integer_32
		end

feature {NONE} -- Procédures SDL

	init_sdl_video
	-- Initialisation du contenu vidéo de la librairie SDL
		local
			l_video_init:NATURAL_32
		do
			l_video_init := {SDL_WRAPPER}.SDL_INIT_VIDEO
			if
				{SDL_WRAPPER}.SDL_Init(l_video_init) < 0
			then
				io.put_string ("Erreur lors de l'Initialisation de la librairie SDL. %N(SDL_Init returned -1)")
			end
		end

	init_sdl_audio
	-- Initialisation du contenu audio de la librairie SDL
		local
			l_audio_init:NATURAL_32
		do
			l_audio_init := {SDL_WRAPPER}.SDL_INIT_AUDIO
			if
				{SDL_WRAPPER}.SDL_Init(l_audio_init) < 0
			then
				io.put_string ("Erreur lors de l'Initialisation de la librairie SDL. %N(SDL_Init returned -1)")
			end
		end

	init_screen:POINTER
	-- Initialisation de la fenêtre
		do
			Result := {SDL_WRAPPER}.SDL_SetVideoMode(556, 268, 32, {SDL_WRAPPER}.SDL_SWSURFACE)
		end

	refresh(a_screen:POINTER; a_refresh_rate:NATURAL_32)
	-- Rafraichissment de l'écran
		do
			{SDL_WRAPPER}.SDL_Delay(a_refresh_rate)
			if
				{SDL_WRAPPER}.SDL_Flip(a_screen) < 0
			then
				io.put_string ("Erreur lors du rafraîchissment de l'image. %N(SDL_Flip returned -1)")
			end
		end

	size_of_event_memory_allocation:POINTER
	-- Espace nécessaire pour l'allocation de mémoire d'un SDL_Event
		local
			l_memory_manager:POINTER
		do
			Result := l_memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Event)
		end

	size_of_keysym_memory_allocation:POINTER
	-- Espace nécessaire pour l'allocation de mémoire d'un keysym
		local
			l_memory_manager:POINTER
		do
			Result := l_memory_manager.memory_alloc ({SDL_WRAPPER}.sizeof_SDL_keysym)
		end

	keyboard_event(a_event_ptr:POINTER):POINTER
	-- Retourne le type d'évènement du clavier
		do
			Result := {SDL_WRAPPER}.set_SDL_KeyboardEvent_from_Event(a_event_ptr)
		end

	keysym(a_keyboard_event_ptr:POINTER):POINTER
	-- Retourne le keysym permettant d'identifier le sym
		do
			Result := {SDL_WRAPPER}.set_SDL_keysym_from_KeyboardEvent(a_keyboard_event_ptr)
		end

	sym(a_keysym:POINTER):INTEGER
	-- Retourne un pointeur indiquant la touche ayant été appuyé
		do
			Result := {SDL_WRAPPER}.get_SDL_sym(a_keysym)
		end

end
