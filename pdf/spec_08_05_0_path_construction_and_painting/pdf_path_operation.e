note
	description: "[
		Representation of a Path Construction Operation
		]"

class
	PDF_PATH_OPERATION

inherit
	PDF_STREAM_OBJECT_ITEM

feature -- Operations

	begin_new_path (x, y: INTEGER)
			-- Operands: x, y
			-- Operator: m
			-- Begin new subpath by moving the current point to
			-- coordinates (x,y), omitting any connecting line segment.
			-- If the previous path construction operator in the current
			-- path was also m, the new m overrides it; no vestige of
			-- the previous m operation remains in the path.
		local
			l_operation: STRING
		do
			create l_operation.make_empty
			l_operation.append_string_general (x.out)
			l_operation.append_character (' ')
			l_operation.append_string_general (y.out)
			l_operation.append_character (' ')
			l_operation.append_character ('m')
			l_operation.append_character (' ')
			operations.force (l_operation)
		end

	operations: ARRAYED_LIST [STRING]
			--
		attribute
			create Result.make (100)
		end

end
