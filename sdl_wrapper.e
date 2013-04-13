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

	frozen set_SDL_Color_r (SDL_Color:POINTER; value:INTEGER_8)
	-- Insère la valeur de r dans une variable de type SDL_Color
		external
			"C [struct <SDL.h>] (struct SDL_Color, Uint8)"
		alias
			"r"
		end

	frozen set_SDL_Color_g (SDL_Color:POINTER; value:INTEGER_8)
	-- Insère la valeur de g dans une variable de type SDL_Color
		external
			"C [struct <SDL.h>] (struct SDL_Color, Uint8)"
		alias
			"g"
		end

	frozen set_SDL_Color_b (SDL_Color:POINTER; value:INTEGER_8)
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

	frozen get_SDL_sym (SDL_keysym:POINTER):POINTER
	-- Retourne le sym (Type de keysym) d'un événement de type SDL_KEYUP / SDL_KEYDOWN
		external
			"C [struct <SDL.h>] (SDL_keysym):struct SDLKey *"
		alias
			"sym"
		end

--	frozen get_SDL_MouseMotionEvent_xrel (SDL_MouseMotionEvent:POINTER):INTEGER_16
--		external
--			"C [struct <SDL.h>] (SDL_MouseMotionEvent):Sint16 *"
--		alias
--			"xrel"
--		end

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

	frozen SDLK_LEFT:POINTER
	-- Valeur associé à la touche « Flèche de gauche » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_LEFT"
		end

	frozen SDLK_RIGHT:POINTER
	-- Valeur associé à la touche « Flèche de droite » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_RIGHT"
		end

	frozen SDLK_UP:POINTER
	-- Valeur associé à la touche « Flèche de haut » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_UP"
		end

	frozen SDLK_DOWN:POINTER
	-- Valeur associé à la touche « Flèche de bas » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_DOWN"
		end

	frozen SDLK_SPACE:POINTER
	-- Valeur associé à la touche « Espace » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_SPACE"
		end

	frozen SDLK_BACKSPACE:POINTER
	-- Valeur associé à la touche « Effacer » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_BACKSPACE"
		end

	frozen SDLK_RETURN:POINTER
	-- Valeur associé à la touche « Entrée » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_RETURN"
		end

	frozen SDLK_h:POINTER
	-- Valeur associé à la touche « H » pour le sym
		external
			"C inline use <SDL.h>"
		alias
			"SDLK_h"
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

end
