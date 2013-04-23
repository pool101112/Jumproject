note
	description: "Classe de type Wrapper pour le langage C qui utilise les fonctions de la librairie SDL."
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	SDL_WRAPPER

feature {ANY} -- Fonctions de gestion de fenêtre et d'image de la libraire SDL 1.2

	frozen SDL_Init(flags:NATURAL_32):INTEGER
	-- The SDL_Init function initializes the Simple Directmedia Library and the subsystems specified by flags.
	-- It should be called before all other SDL functions.
		external
			"C (Uint32):int | <SDL.h>"
		alias
			"SDL_Init"
		end

	frozen SDL_IMG_Load(file:POINTER):POINTER
	-- Load file for use as an image in a new surface
		external
			"C (const char *):struct SDL_Surface * | <SDL_image.h>"
		alias
			"IMG_Load"
		end

	frozen SDL_SetVideoMode(width, height, bitsperpixel:INTEGER; flags:NATURAL_32):POINTER
	-- Set up a video mode with the specified width, height and bitsperpixel.
		external
			"C (int, int, int, Uint32):struct SDL_Surface * | <SDL.h>"
		alias
			"SDL_SetVideoMode"
		end

	frozen SDL_BlitSurface(src, srcrect, dst, dstrect:POINTER):INTEGER
	-- This performs a fast blit from the source surface to the destination surface.
		external
			"C (struct SDL_Surface *, struct SDL_Rect *, struct SDL_Surface *, struct SDL_Rect *):int | <SDL.h>"
		alias
			"SDL_BlitSurface"
		end

	frozen SDL_FillRect(dst, dstrect:POINTER; color:NATURAL_32):INTEGER
		external
			"C (struct SDL_Surface *, struct SDL_Rect *, Uint32):int | <SDL.h>"
		alias
			"SDL_FillRect"
		end

	frozen SDL_Flip(screen:POINTER):INTEGER
	-- On hardware that supports double-buffering, this function sets up a flip and returns.
		external
			"C (struct SDL_Surface *):int | <SDL.h>"
		alias
			"SDL_Flip"
		end

	frozen SDL_Delay(time:NATURAL_32)
	-- This function waits a specified number of milliseconds before returning.
	-- It waits at least the specified time, but possible longer due to OS scheduling
		external
			"C (Uint32) | <SDL.h>"
		alias
			"SDL_Delay"
		end

	frozen SDL_WM_SetCaption(title, icon:POINTER)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_WM_SetCaption((char *)$title, (char *)$icon)"
		end

	frozen SDL_WM_SetIcon(icon:POINTER; mask:POINTER)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_WM_SetIcon((SDL_Surface *)$icon, (Uint8 *)$mask)"
		end

feature {GAME} -- Fonction de gestion d'événements de la librairie SDL 1.2

	frozen SDL_PollEvent(event:POINTER):INTEGER
	-- Polls for currently pending events.
	-- If event is not NULL, the next event is removed from the queue and stored in the SDL_Event structure
	-- pointed to by event.
		external
			"C (SDL_Event *):int | <SDL.h>"
		alias
			"SDL_PollEvent"
		end

	frozen SDL_Quitter()
	-- SDL_Quit ferme tous les sous-système de la SDL et libère les ressources allouées à ceux-ci.
		external
			"C | <SDL.h>"
		alias
			"SDL_Quit"
		end

feature {ANY} -- Setter de la libraire SDL 1.2

	frozen set_target_area_x (SDL_Rect:POINTER; value:INTEGER_16)
	-- Insère x (Latitude) dans une variable de type SDL_Rect
		external
			"C [struct <SDL.h>] (struct SDL_Rect, Sint16)"
		alias
			"x"
		end

	frozen set_target_area_y (SDL_Rect:POINTER; value:INTEGER_16)
	-- Insère y (Altitude) dans une variable de type SDL_Rect
		external
			"C [struct <SDL.h>] (struct SDL_Rect, Sint16)"
		alias
			"y"
		end

	frozen set_target_area_w (SDL_Rect:POINTER; value:INTEGER)
	-- Insère w (Largeur) dans une variable de type SDL_Rect
		external
			"C [struct <SDL.h>] (struct SDL_Rect, Uint16)"
		alias
			"w"
		end

	frozen set_target_area_h (SDL_Rect:POINTER; value:INTEGER)
	-- Insère h (Hauteur) dans une variable de type SDL_Rect
		external
			"C [struct <SDL.h>] (struct SDL_Rect, Uint16)"
		alias
			"h"
		end

	frozen set_SDL_Color_r (SDL_Color:POINTER; value:NATURAL_8)
	-- Insère la valeur de r dans une variable de type SDL_Color
		external
			"C [struct <SDL.h>] (struct SDL_Color, Uint8)"
		alias
			"r"
		end

	frozen set_SDL_Color_g (SDL_Color:POINTER; value:NATURAL_8)
	-- Insère la valeur de g dans une variable de type SDL_Color
		external
			"C [struct <SDL.h>] (struct SDL_Color, Uint8)"
		alias
			"g"
		end

	frozen set_SDL_Color_b (SDL_Color:POINTER; value:NATURAL_8)
	-- Insère la valeur de b dans une variable de type SDL_Color
		external
			"C [struct <SDL.h>] (struct SDL_Color, Uint8)"
		alias
			"b"
		end

	frozen set_SDL_KeyboardEvent_from_Event(event:POINTER):POINTER
	-- SDL_KeyboardEvent is a member of the SDL_Event union and is used when an event
	-- of type SDL_KEYDOWN or SDL_KEYUP is reported.
		external
			"C inline use <SDL.h>"
		alias
			"&(((SDL_Event *)$event)->key)"
		end

	frozen set_SDL_keysym_from_KeyboardEvent(keyboard_event:POINTER):POINTER
	-- The SDL_keysym structure is used to report key presses and releases. It is part of the SDL_KeyboardEvent.
		external
			"C inline use <SDL.h>"
		alias
			"&(((SDL_KeyboardEvent *)$keyboard_event)->keysym)"
		end

	frozen get_SDL_sym (SDL_keysym:POINTER):INTEGER
	-- Retourne le sym (Type de keysym) d'un événement de type SDL_KEYUP / SDL_KEYDOWN
		external
			"C [struct <SDL.h>] (SDL_keysym):SDLKey"
		alias
			"sym"
		end

	frozen SDL_GetKeyName(sym:INTEGER):POINTER
		external
			"C (SDLKey):char * | <SDL.h>"
		alias
			"SDL_GetKeyName"
		end

feature {GAME, IMAGE}-- Getter de la librairie SDL 1.2

	frozen get_bmp_w (SDL_Surface:POINTER):INTEGER
	-- Retourne w (Largeur) d'une variable de type SDL_Surface (Image)
		external
			"C [struct <SDL.h>] (struct SDL_Surface):int"
		alias
			"w"
		end

	frozen get_bmp_h (SDL_Surface:POINTER):INTEGER
	-- Retourne h (Hauteur) d'une variable de type SDL_Surface (Image)
		external
			"C [struct <SDL.h>] (struct SDL_Surface):int"
		alias
			"h"
		end

	frozen get_SDL_Event_type (SDL_Event:POINTER):NATURAL_8
	-- The SDL_Event union is the core to all event handling in SDL;
	-- it's probably the most important structure after SDL_Surface.
		external
			"C [struct <SDL.h>] (SDL_Event):Uint8"
		alias
			"type"
		end

	frozen get_SDL_ticks:NATURAL_32
		external
			"C:Uint32 | <SDL.h>"
		alias
			"SDL_GetTicks"
		end

--	frozen get_SDL_MouseMotionEvent_xrel (SDL_MouseMotionEvent:POINTER):INTEGER_16
--		external
--			"C [struct <SDL.h>] (SDL_MouseMotionEvent):Sint16 *"
--		alias
--			"xrel"
--		end

	frozen get_SDL_MouseButtonEvent_button (SDL_MouseButtonEvent:POINTER):NATURAL_8
		external
			"C [struct <SDL.h>] (SDL_MouseButtonEvent):Uint8 *"
		alias
			"button"
		end

	frozen get_SDL_MouseButtonEvent_x (SDL_MouseButtonEvent:POINTER):INTEGER_16
		external
			"C [struct <SDL.h>] (SDL_MouseButtonEvent):Uint16 *"
		alias
			"x"
		end

	frozen get_SDL_MouseButtonEvent_y (SDL_MouseButtonEvent:POINTER):INTEGER_16
		external
			"C [struct <SDL.h>] (SDL_MouseButtonEvent):Uint16 *"
		alias
			"y"
		end

feature {ANY} -- Sizeof de la librairie SDL 1.2

	frozen sizeof_SDL_Rect:INTEGER
	-- Alloue l'espace nécessaire pour une variable de type SDL_Rect
		external
			"C inline use <SDL.h>"
		alias
			"sizeof(struct SDL_Rect)"
		end

	frozen sizeof_SDL_Event:INTEGER
	-- Alloue l'espace nécessaire pour une variable de type SDL_Event
		external
			"C inline use <SDL.h>"
		alias
			"sizeof(SDL_Event)"
		end

	frozen sizeof_SDL_keysym:INTEGER
	-- Alloue l'espace nécessaire pour une variable de type SDL_keysym
		external
			"C inline use <SDL.h>"
		alias
			"sizeof(SDL_keysym)"
		end

	frozen sizeof_SDL_Color:INTEGER
	-- Alloue l'espace nécessaire pour une variable de type SDL_Color
		external
			"C inline use <SDL_ttf.h>"
		alias
			"sizeof(SDL_Color)"
		end

feature {GAME} -- Constantes de la librairie SDL 1.2

	frozen SDL_INIT_VIDEO:NATURAL_16
	-- Valeur du sous-système vidéo de la librairie SDL
		external
			"C inline use <SDL.h>"
		alias
			"SDL_INIT_VIDEO"
		end

	frozen SDL_INIT_AUDIO:NATURAL_16
	-- Valeur du sous-système audio de la librairie SDL
		external
			"C inline use <SDL.h>"
		alias
			"SDL_INIT_AUDIO"
		end

	frozen MIX_INIT_MP3:NATURAL_16
	-- Valeur du INIT_MP3 de la librairie SDL_mixer
		external
			"C inline use <SDL.h>"
		alias
			"MIX_INIT_MP3"
		end

	frozen SDL_SWSURFACE:NATURAL_32
	-- Stored in the system memory. SDL_SWSURFACE is not actually a flag (it is defined as 0).
		external
			"C inline use <SDL.h>"
		alias
			"SDL_SWSURFACE"
		end

	frozen SDL_QUIT:NATURAL_8
	-- Valeur de l'événement de SDL_QUIT
		external
			"C inline use <SDL.h>"
		alias
			"SDL_QUIT"
		end

	frozen SDL_MOUSEMOTION:NATURAL_8
	-- Valeur de l'événement MOUSEMOTION (Mouvement de la souris)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_MOUSEMOTION"
		end

	frozen SDL_MOUSEBUTTONDOWN:NATURAL_8
	-- Valeur de l'événement MOUSEBUTTONDOWN (Bouton pesé)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_MOUSEBUTTONDOWN"
		end

	frozen SDL_BUTTON_LEFT:NATURAL_8
	-- Valeur de l'événement BUTTON_LEFT (Bouton de gauche)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_BUTTON_LEFT"
		end

	frozen SDL_KEYDOWN:NATURAL_8
	-- Valeur de l'événement KEYDOWN (Touche appuyée)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_KEYDOWN"
		end

	frozen SDL_KEYUP:NATURAL_8
	-- Valeur de l'événement KEYUP (Touche relâchée)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_KEYUP"
		end

	frozen SDLK_LEFT:INTEGER
	-- Valeur associé à la touche « Flèche de gauche » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_LEFT"
		end

	frozen SDLK_RIGHT:INTEGER
	-- Valeur associé à la touche « Flèche de droite » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_RIGHT"
		end

	frozen SDLK_UP:INTEGER
	-- Valeur associé à la touche « Flèche de haut » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_UP"
		end

	frozen SDLK_DOWN:INTEGER
	-- Valeur associé à la touche « Flèche de bas » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_DOWN"
		end

	frozen SDLK_SPACE:INTEGER
	-- Valeur associé à la touche « Espace » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_SPACE"
		end

	frozen SDLK_BACKSPACE:INTEGER
	-- Valeur associé à la touche « Effacer » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_BACKSPACE"
		end

	frozen SDLK_RETURN:INTEGER
	-- Valeur associé à la touche « Entrée » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_RETURN"
		end

	frozen SDLK_a:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_a"
		end

	frozen SDLK_b:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_b"
		end

	frozen SDLK_c:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_c"
		end

	frozen SDLK_d:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_d"
		end

	frozen SDLK_e:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_e"
		end

	frozen SDLK_f:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_f"
		end


	frozen SDLK_g:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_g"
		end

	frozen SDLK_h:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_h"
		end

	frozen SDLK_i:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_i"
		end

	frozen SDLK_j:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_j"
		end

	frozen SDLK_k:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_k"
		end

	frozen SDLK_l:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_l"
		end

	frozen SDLK_m:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_m"
		end

	frozen SDLK_n:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_n"
		end

	frozen SDLK_o:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_o"
		end

	frozen SDLK_p:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_p"
		end

	frozen SDLK_q:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_q"
		end

	frozen SDLK_r:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_r"
		end

	frozen SDLK_s:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_s"
		end

	frozen SDLK_t:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_t"
		end

	frozen SDLK_u:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_u"
		end

	frozen SDLK_v:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_v"
		end

	frozen SDLK_w:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_w"
		end

	frozen SDLK_x:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_x"
		end

	frozen SDLK_y:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_y"
		end

	frozen SDLK_z:INTEGER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_z"
		end

feature {SCORE} -- TTF

	frozen TTF_Init:INTEGER
	-- Initialisation de la librairie SDL_TTF
		external
			"C:int | <SDL_ttf.h>"
		alias
			"TTF_Init"
		end

	frozen TTF_QUIT
	-- Quitte le système TTF
		external
			"C | <SDL_ttf.h>"
		alias
			"TTF_Quit"
		end

	frozen TTF_RenderText_Solid(font, text, color:POINTER):POINTER
		external
			"C inline use <SDL_ttf.h>"
		alias
			"TTF_RenderText_Solid((TTF_Font *)$font, (char *)$text, *(SDL_Color *)$color)"
		end

	frozen TTF_OpenFont(file:POINTER; size:INTEGER):POINTER
		external
			"C (const char *, Uint32):TTF_Font * | <SDL_ttf.h>"
		alias
			"TTF_OpenFont"
		end

feature {GAME, ENEMY} -- Sounds

	frozen Mix_Init(flags:INTEGER):INTEGER
		external
			"C (int):int | <SDL_mixer.h>"
		alias
			"Mix_Init"
		end

	frozen Mix_Quit
		external
			"C | <SDL_mixer.h>"
		alias
			"Mix_Quit"
		end

	frozen Mix_OpenAudio (frequency:INTEGER; format:NATURAL_16; channels:INTEGER; chunksize:INTEGER):INTEGER
		external
			"C (int, Uint16, int, int):int | <SDL_mixer.h>"
		alias
			"Mix_OpenAudio"
		end

	frozen Mix_CloseAudio
		external
			"C | <SDL_mixer.h>"
		alias
			"Mix_CloseAudio"
		end

	frozen Mix_LoadMUS (file:POINTER):POINTER
		external
			"C (const char *):Mix_Music * | <SDL_mixer.h>"
		alias
			"Mix_LoadMUS"
		end

	frozen Mix_LoadWAV (file:POINTER):POINTER
		external
			"C (const char *):Mix_Chunk * | <SDL_mixer.h>"
		alias
			"Mix_LoadWAV"
		end

	frozen MIX_DEFAULT_FORMAT:NATURAL_16
	-- Valeur de ??
		external
			"C inline use <SDL_mixer.h>"
		alias
			"MIX_DEFAULT_FORMAT"
		end

	frozen Mix_PlayMusic(music:POINTER; loops:INTEGER):INTEGER
		external
			"C inline use <SDL_mixer.h>"
		alias
			"Mix_PlayMusic((Mix_Music *)$music, (int)$loops)"
		end

	frozen Mix_FadeInMusic(music:POINTER; loops, ms:INTEGER):INTEGER
		external
			"C inline use <SDL_mixer.h>"
		alias
			"Mix_FadeInMusic((Mix_Music *)$music, (int)$loops, (int)$ms)"
		end

	 frozen Mix_HaltMusic
	 	external
	 		"C inline use <SDL_mixer.h>"
	 	alias
	 		"Mix_HaltMusic"
	 	end

	 frozen Mix_PauseMusic
	 	external
	 		"C inline use <SDL_mixer.h>"
	 	alias
	 		"Mix_PauseMusic"
	 	end

	  frozen Mix_PausedMusic:INTEGER
	 	external
	 		"C:int | <SDL_mixer.h>"
	 	alias
	 		"Mix_PausedMusic"
	 	end

	 frozen Mix_ResumeMusic
	 	external
	 		"C inline use <SDL_mixer.h>"
	 	alias
	 		"Mix_ResumeMusic"
	 	end

	 frozen Mix_GetError:POINTER
	 	external
	 		"C:char* | <SDL_mixer.h>"
	 	alias
	 		"Mix_GetError"
	 	end

	frozen Mix_PlayChannel(channel:INTEGER; chunk:POINTER; loops:INTEGER):INTEGER
		external
			"C inline use <SDL_mixer.h>"
		alias
			"Mix_PlayChannel((int)$channel, (Mix_Chunk *)$chunk, (int)$loops)"
		end

end
