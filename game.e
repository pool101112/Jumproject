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
			l_screen, l_event_ptr:POINTER
			l_exit, l_play_game:BOOLEAN

			l_menu:MENU
		do
			-- Initialisation de l_screen
			create l_menu

			init_sdl
			l_screen := init_screen
			-- Initialisation de l'image de menu
			l_menu.assigner_ptr_image
			l_event_ptr := size_of_event_memory_allocation
			from
			until
				l_exit
			loop
				if l_play_game then
					playing(l_screen)
				end
				l_play_game := False
				from
				until
					{SDL_WRAPPER}.SDL_PollEvent(l_event_ptr) < 1
				loop
					if quit_request(l_event_ptr) then
						l_exit := True
					elseif start_game(l_event_ptr) then
						l_play_game := True
					end
				end
				l_menu.apply_background (l_screen)
				refresh(l_screen, 100)
			end
			quit_game
		end

	playing(a_screen:POINTER)
		local
			l_difficulty:NATURAL_32
			l_ctr:INTEGER_16
			--l_player_name:STRING
			l_ff_box, l_ff_box2, l_player_box:ARRAY[INTEGER]
			l_event_ptr:POINTER
			l_game_over, l_spawning, l_follow_player:BOOLEAN

			-- Instances de classe
			l_bg:BACKGROUND
			l_enemy:ENEMY
			l_flying_floor, l_ff_two:FLYING_FLOOR
			l_database:DATABASE
			l_player:PLAYER
		do
			create l_bg
			create l_player
			create l_enemy
			create l_flying_floor
			create l_ff_two
			create l_database

			-- Initialisation du background
			l_bg.assigner_ptr_image
			-- Initialisation du player
			l_player.init_player
			-- Initialisation de l'ennemy
			l_enemy.init_enemy
			-- Initialisation des flying_floors
			l_flying_floor.init_flying_floor (100, 175)
			l_ff_two.init_flying_floor (200, 100)
			-- Spawn
			l_spawning := true
			l_follow_player := true
			l_event_ptr := size_of_event_memory_allocation
			print ("Veuillez choisir votre niveau de difficulté (Entre 0 et 4) : ")
			io.read_natural_32
			l_difficulty := io.last_natural_32
			if l_difficulty > 0 then
				print ("Bon jeu!%NAppuyez sur une entrer pour continuer...")
			elseif l_difficulty = 0 then
				print ("Ooooh... Bonne chance...%NAppuyez sur une entrer pour continuer...")
			end
			io.read_line
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
				l_ff_box := l_flying_floor.ff_box_array
				l_ff_box2 := l_ff_two.ff_box_array
				l_player_box := l_player.fill_sprite_box
				if not l_spawning then
					l_player.move (l_ff_box, l_ff_box2)
					l_enemy.init_ff_boxes (l_ff_box, l_ff_box2)
					l_enemy.random_move (l_follow_player, l_player_box)
					l_enemy.move
				end
				l_bg.apply_background (a_screen)
				l_enemy.adjust_lives
				l_enemy.show_lives (a_screen)
				if l_spawning then
					l_player.apply_spawn (a_screen)
					l_enemy.apply_spawn (a_screen)
				else
					l_player.apply_player (a_screen)
					l_enemy.apply_player (a_screen)
				end
				l_flying_floor.apply_flying_floor(a_screen)
				l_ff_two.apply_flying_floor (a_screen)
				refresh (a_screen, l_difficulty)
				if l_ctr < 74 then
					l_ctr := l_ctr + 1
				elseif l_ctr = 74 then
					l_spawning := false
				end
				if l_enemy.no_live then
					l_game_over := True
				end
			end
		end
feature {NONE} -- Menu

	start_game(a_event_ptr:POINTER):BOOLEAN
		local
			l_event:NATURAL_8
			l_keyboard_event_ptr, l_keysym, l_sym:POINTER
		do
			Result := False
			l_keyboard_event_ptr := size_of_keysym_memory_allocation
			l_event := {SDL_WRAPPER}.get_SDL_Event_type(a_event_ptr)
			if l_event = {SDL_WRAPPER}.SDL_KEYDOWN then
				l_keyboard_event_ptr := keyboard_event (a_event_ptr)
				l_keysym := keysym (l_keyboard_event_ptr)
				l_sym := sym (l_keysym)
				if l_sym = {SDL_WRAPPER}.SDLK_RETURN then
					Result := True
				end
			end
		end

feature {NONE} -- Jeu

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
			l_keyboard_event_ptr, l_keysym, l_sym:POINTER
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
				elseif l_sym = {SDL_WRAPPER}.SDLK_SPACE then
					a_player.set_jump
--				elseif l_sym = {SDL_WRAPPER}.SDLK_BACKSPACE then
--					if follow_player then
--						follow_player := false
--					else
--						follow_player := true
--					end
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


feature {NONE} -- Procédures SDL

	init_sdl
	-- Initialisation de la librairie SDL
		local
			l_init:NATURAL_32
		do
			l_init := {SDL_WRAPPER}.SDL_INIT_VIDEO
			if
				{SDL_WRAPPER}.SDL_Init(l_init) < 0
			then
				io.put_string ("Erreur lors de l'Initialisation de la librairie SDL. %N(SDL_Init returned -1)")
			end
		end

	init_screen:POINTER
	-- Initialisation de la fenêtre
		do
			Result := {SDL_WRAPPER}.SDL_SetVideoMode(556, 268, 32, {SDL_WRAPPER}.SDL_SWSURFACE)
		end

	refresh(a_screen:POINTER; a_difficulty:NATURAL_32)
	-- Rafraichissment de l'écran
		do
			{SDL_WRAPPER}.SDL_Delay((5 * a_difficulty) + 1)
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

	sym(a_keysym:POINTER):POINTER
	-- Retourne un pointeur indiquant la touche ayant été appuyé
		do
			Result := {SDL_WRAPPER}.get_SDL_sym(a_keysym)
		end

end
