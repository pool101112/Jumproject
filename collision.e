note
	description: "Classe d�signant les collisions qui r�sultent d'�v�nements"
	author: "Marc-Andr� Douville Auger"
	date: "21 F�vrier 2013"
	revision: ""

deferred class
	COLLISION

feature {GAME, SPRITE} -- Collision

	is_collision (a_object, a_object_2:TUPLE[left, right, top, bottom:INTEGER_16]):BOOLEAN
	-- V�rifie si une collision survient entre 2 objets
		do
			if a_object.right < a_object_2.left then
				Result := false
			elseif a_object.left > a_object_2.right then
				Result := false
			elseif a_object.bottom < a_object_2.top then
				Result := false
			elseif a_object.top > a_object_2.bottom then
				Result := false
			else
				Result := true
			end
		end
end
