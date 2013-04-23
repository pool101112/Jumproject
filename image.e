note
	description: "Classe gérant les images"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

deferred class
	IMAGE

inherit
	DISPOSABLE

feature {NONE} -- Assignation Pointeur

	assigner_ptr_image
		deferred
		end

feature {SPRITE, GROUND, BACKGROUND}-- Gestion des images

	-- Variables de classe --
	img_ptr, screen, memory_manager:POINTER
	image_w, image_h:INTEGER
	-------------------------

	create_img_ptr(a_image_file:STRING)
	-- Créé un pointeur vers l'image
		local
			l_c_img:C_STRING
		do
			create l_c_img.make(a_image_file)
			img_ptr := {SDL_WRAPPER}.SDL_IMG_Load(l_c_img.item)
		end

	apply_img(a_screen, a_image_rect:POINTER; image_x, image_y:INTEGER_16)
	-- Applique l'image à la fenêtre
		local
			l_target_area:POINTER
		do
			l_target_area := memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Rect)

			image_w := {SDL_WRAPPER}.get_bmp_w(img_ptr)
			image_h := {SDL_WRAPPER}.get_bmp_h(img_ptr)

			{SDL_WRAPPER}.set_target_area_x(l_target_area, image_x)
			{SDL_WRAPPER}.set_target_area_y(l_target_area, image_y)
			{SDL_WRAPPER}.set_target_area_w(l_target_area, image_w)
			{SDL_WRAPPER}.set_target_area_h(l_target_area, image_h)

			if
				{SDL_WRAPPER}.SDL_BlitSurface(img_ptr, a_image_rect, a_screen, l_target_area) < 0
			then
				io.put_string ("Erreur lors de l'application du background. %N(SDL_BlitSurface returned -1) at apply_img")
			end

			l_target_area.memory_free
		end

	apply_fill(a_screen:POINTER; a_color:NATURAL_32)
	-- Applique une couleur unie à la fenêtre
		do
			if
				{SDL_WRAPPER}.SDL_FillRect(a_screen, create{POINTER}, a_color) < 0
			then
				io.put_string ("Erreur lors de l'application du background. %N(SDL_FillRect returned -1) at apply_img")
			end
		end

	get_img_w:INTEGER_16
	-- Retourne la largeur
		do
			Result := {SDL_WRAPPER}.get_bmp_w(img_ptr).as_integer_16
		end

	get_img_h:INTEGER_16
	-- Retourne la hauteur
		do
			Result := {SDL_WRAPPER}.get_bmp_h(img_ptr).as_integer_16
		end

feature -- Dispose

	dispose
		do
--			{SDL_WRAPPER}.SDL_FreeSurface(ptr)
		end
end
