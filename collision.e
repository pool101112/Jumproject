note
	description: "Classe d�signant les collisions qui r�sultent d'�v�nements"
	author: "Marc-Andr� Douville Auger"
	date: "21 F�vrier 2013"
	revision: ""

class
	COLLISION

feature {GAME, SPRITE} -- Collision
	box1_left, box1_right, box1_bottom, box1_top, box2_left, box2_right, box2_bottom, box2_top:INTEGER

	is_collision(box1, box2:ARRAY[INTEGER]):BOOLEAN
	-- V�rifie si une collision survient entre 2 objets
		do
			box1_left := box1[1]
			box1_right := box1[1] + box1[3]
			box1_bottom := box1[2] + box1[4]
			box1_top := box1[2]

			box2_left := box2[1]
			box2_right := box2[1] + box2[3]
			box2_bottom := box2[2] + box2[4]
			box2_top := box2[2]

			if box1_right < box2_left then
				Result := false
			elseif box1_left > box2_right then
				Result := false
			elseif box1_bottom < box2_top then
				Result := false
			elseif box1_top > box2_bottom then
				Result := false
			else
				Result := true
			end
		end
end
