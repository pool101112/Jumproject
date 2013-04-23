note
	description: "Classe gérant le score à l'aide des différentes collisions"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	SCORE

create
	make

feature -- TTF
	color, font, text:POINTER
	size:INTEGER

	make(a_size:INTEGER)
		do
			init_ttf
			font_size(a_size)
			create_font
			change_color(122, 0, 0)
		end

	init_ttf
		do
			if {SDL_WRAPPER}.TTF_Init < 0 then
				print("Error")
			end
		end

	font_size(a_size:INTEGER)
		do
			size := a_size
		end

	create_font
		local
			l_c_font:C_STRING
		do
			create l_c_font.make("Ressources/visitor1.ttf")
			font := {SDL_WRAPPER}.TTF_OpenFont(l_c_font.item, size)
		end

	change_color(a_r, a_g, a_b:NATURAL_8)
		local
			l_memory_manager:POINTER
		do
			color := l_memory_manager.memory_alloc ({SDL_WRAPPER}.sizeof_SDL_Color)
			{SDL_WRAPPER}.set_SDL_Color_r (color, a_r)
			{SDL_WRAPPER}.set_SDL_Color_g (color, a_g)
			{SDL_WRAPPER}.set_SDL_Color_b (color, a_b)
		end

	assigner_score(a_score:STRING)
		local
			l_c_text:C_STRING
		do
			create l_c_text.make (a_score)
			text := {SDL_WRAPPER}.TTF_RenderText_Solid(font, l_c_text.item, color)
		end

	apply_score(a_screen:POINTER)
		local
			l_target_area, l_memory_manager:POINTER
		do
			l_target_area := l_memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Rect)

			{SDL_WRAPPER}.set_target_area_x(l_target_area, 250)
			{SDL_WRAPPER}.set_target_area_y(l_target_area, 30)
			{SDL_WRAPPER}.set_target_area_w(l_target_area, 100)
			{SDL_WRAPPER}.set_target_area_h(l_target_area, 100)

			if
				{SDL_WRAPPER}.SDL_BlitSurface(text, create{POINTER}, a_screen, l_target_area) < 0
			then
				io.put_string ("Erreur lors de l'application du TTF. %N(SDL_BlitSurface returned -1) at apply_img")
			end

			l_target_area.memory_free
		end

	apply_text(a_screen:POINTER; a_x, a_y:INTEGER_16)
		local
			l_target_area, l_memory_manager:POINTER
		do
			l_target_area := l_memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Rect)

			{SDL_WRAPPER}.set_target_area_x(l_target_area, a_x)
			{SDL_WRAPPER}.set_target_area_y(l_target_area, a_y)
			{SDL_WRAPPER}.set_target_area_w(l_target_area, 100)
			{SDL_WRAPPER}.set_target_area_h(l_target_area, 100)

			if
				{SDL_WRAPPER}.SDL_BlitSurface(text, create{POINTER}, a_screen, l_target_area) < 0
			then
				io.put_string ("Erreur lors de l'application du TTF. %N(SDL_BlitSurface returned -1) at apply_img")
			end
			l_target_area.memory_free
			l_memory_manager.memory_free
		end

end
