note
	description: "Classe désignant la base de données"
	author: "Marc-André Douville Auger"
	date: "21 Février 2013"
	revision: ""

class
	DATABASE

feature {GAME} -- Création et Destruction

	db:SQLITE_DATABASE

	create_database
	-- Création de la Database
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
			create db.make_create_read_write ("Database/pointage.sqlite")
			create l_query.make ("SELECT name FROM sqlite_master ORDER BY name;", db)
			across l_query.execute_new as l_cursor loop
				print (" - table: " + l_cursor.item.string_value (1) + "%N")
			end
		end

	create_table
	-- Création de la table
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make ("CREATE TABLE IF NOT EXISTS `Scores` (`Joueur` TEXT PRIMARY KEY, `Pointage` INTEGER, `Time` DOUBLE);", db)
			l_modify.execute
		end

	drop_table
	-- Destruction de la table
		local
			l_modify: SQLITE_MODIFY_STATEMENT
		do
			create l_modify.make ("DROP TABLE IF EXISTS Scores;", db)
			l_modify.execute
		end

	close_database
	-- Fermeture de la Database
		do
			db.close
		end

feature {GAME} -- Modifications

	insert_table(a_player_name:STRING)
	-- Insertion d'un nouveau joueur dans la Database
		local
			l_insert: SQLITE_INSERT_STATEMENT
		do
			create l_insert.make ("INSERT INTO Scores (Joueur, Pointage, Time) VALUES (?1, :SCORE, :TIME_PLAYED);", db)
			check l_insert_is_compiled: l_insert.is_compiled end

			db.begin_transaction (False)


			l_insert.execute_with_arguments ([a_player_name, create {SQLITE_DOUBLE_ARG}.make (":SCORE", 0), create {SQLITE_DOUBLE_ARG}.make (":TIME_PLAYED",0)])

			db.commit
		end

	update_table(a_player_name:STRING; a_score:INTEGER; a_time_played:DOUBLE)
	-- Mise à jour d'un joueur dans la Database
		local
			l_update: SQLITE_MODIFY_STATEMENT
		do
			create l_update.make ("UPDATE `Scores` SET `Pointage`=:SCORE, `Time`=:TIME_PLAYED WHERE `Joueur`=?3;", db)
			check l_update_is_compiled: l_update.is_compiled end

			db.begin_transaction (False)

			l_update.execute_with_arguments ([create {SQLITE_DOUBLE_ARG}.make (":SCORE", a_score), create {SQLITE_DOUBLE_ARG}.make (":TIME_PLAYED", a_time_played), a_player_name])
			db.commit
		end

feature {GAME} -- Affichage

	show_database
	-- Affiche la Database
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
			create l_query.make ("SELECT * FROM Scores;", db)
			l_query.execute (agent (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					j, j_count: NATURAL
				do
					from
						j := 1
						j_count := ia_row.count
					until
						j > j_count
					loop
						if j = 1 then
							print (ia_row.string_value (j) + ": %N     ")
						elseif j = 2 then
							print (ia_row.string_value (j) + " PTS | Time Played: ")
						elseif j = 3 then
							print (ia_row.string_value (j) + " Seconds")
						end
						j := j + 1
					end
					print ("%N")
				end)
				print ("%N")
		end

	show_player_score(a_player_name:STRING)
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
			create l_query.make ("SELECT * FROM Scores WHERE Joueur=?1 ;", db)
			l_query.execute_with_arguments (agent (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					j, j_count: NATURAL
				do
					from
						j := 1
						j_count := ia_row.count
					until
						j > j_count
					loop
						if j = 1 then
							print (ia_row.string_value (j) + ": ")
						elseif j = 2 then
							print (ia_row.string_value (j) + " PTS | Time Played: ")
						elseif j = 3 then
							print (ia_row.string_value (j) + " Seconds")
						end
						j := j + 1
					end
					print ("%N")
				end, [a_player_name])
		end

feature {GAME} -- Données

	player_exist(a_player_name:STRING):BOOLEAN
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
			Result := False
			create l_query.make ("SELECT Joueur FROM Scores;", db)
			across l_query.execute_new as l_cursor loop
				if a_player_name.is_equal(l_cursor.item.string_value (1)) then
					Result := True
				end
			end
		end



	get_score(a_player_name:STRING):INTEGER
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
			create l_query.make ("SELECT * FROM `Scores` WHERE `Joueur`=?1 ;", db)
			across l_query.execute_new_with_arguments([a_player_name]) as l_cursor loop
				Result := (l_cursor.item.integer_value (2))
			end
		end

	get_time_played(a_player_name:STRING):INTEGER
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
			create l_query.make ("SELECT * FROM Scores WHERE Joueur=?1 ;", db)
			across l_query.execute_new_with_arguments([a_player_name]) as l_cursor loop
				Result := (l_cursor.item.integer_value (3))
			end
		end
end
