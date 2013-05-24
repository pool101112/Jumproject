note
	description: "Summary description for {SOUNDS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND

create
	make

feature {ANY} -- Constructeur

	make (a_path:STRING)
	-- Initialise `Current' avec le fichier dans `a_path'
		require
			a_path_is_not_empty : not a_path.is_empty
		local
			l_chunk_path:C_STRING
		do
			create l_chunk_path.make (a_path)
			chunk := {SDL_WRAPPER}.Mix_LoadWAV(l_chunk_path.item)
			ensure
				chunk_is_not_null : not chunk.is_default_pointer
		end

feature {ANY} -- Opérations sonores

	play_sound
	-- Joue le son de `chunk'
		do
			if {SDL_WRAPPER}.Mix_PlayChannel(-1, chunk, 0) < 0 then
				print("Error: cannot play sound")
			end
			ensure
				chunk_is_not_null : not chunk.is_default_pointer
		end

feature {NONE} -- Variables de classe
	chunk:POINTER

end
