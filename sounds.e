note
	description: "Summary description for {SOUNDS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND

create
	make

feature {ANY} -- Main

	make (a_path:STRING)
		local
			l_chunk_path:C_STRING
		do
			create l_chunk_path.make (a_path)
			chunk := {SDL_WRAPPER}.Mix_LoadWAV(l_chunk_path.item)
		end

	play_sound
		do
			if {SDL_WRAPPER}.Mix_PlayChannel(-1, chunk, 0) < 0 then
				print("Error PlayChannel")
			end
		end

feature {NONE} -- Variables de classe
	chunk:POINTER

end
