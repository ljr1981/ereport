note
	description: "Summary description for {PDF_STRING}."
	EIS: "name=7.3.4 String Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=22&view=FitH", "override=true"

class
	PDF_STRING

inherit
	PDF_OBJECT [STRING]
		rename
			value as literal_text
		redefine
			default_create
		end

create
	default_create,
	make_as_literal,
	make_as_hex_from_literal,
	make_as_hex

feature {NONE} -- Intialization

	default_create
			-- <Precursor>
			-- `default_create' with empty `literal_text' and no `hex_data'
		do
			Precursor
			create literal_text.make_empty
		ensure then
			set: attached literal_text as al_literal_text and then al_literal_text.is_empty and then not attached hex_data
		end

	make_as_literal (s: STRING)
			-- `make_as_literal' of `s'
		do
			literal_text := s
		ensure
			attached literal_text as al and then al.same_string (s)
		end

	make_as_hex_from_literal (s: STRING)
			-- `make_as_hex_from_literal' in `s'.
		local
			l_list: ARRAY [INTEGER]
		do
			create l_list.make_filled (0, 1, s.count)
			across
				s as ic
			loop
				l_list.put (ic.item.code, ic.cursor_index)
			end
			make_as_hex (l_list)
		end

	make_as_hex (a_list: ARRAY [INTEGER])
			-- `make_as_hex' from `a_list'
		do
			create hex_data.make (a_list.count)
			across
				a_list as ic
			loop
				hex_data.force (ic.item)
			end
		end

feature -- Access

	hex_data: ARRAYED_LIST [INTEGER]
			-- `hex_data' as a List.
		attribute
			create Result.make (0)
		end

feature -- Queries

	literal_from_hex: attached like literal_text
			--
		do
			create Result.make (hex_data.count)
			across
				hex_data as ic
			loop
				Result.append_string_general (ic.item.out)
			end
		end

	hex_from_literal: like hex_data
			-- `hex_from_literal'
		do
			if attached literal_text as al then
				create Result.make (al.count)
			else
				create Result.make (0)
			end
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			if attached literal_text then
				Result := literal_text_out
			else
				Result := hex_out
			end
			Result.adjust
		end

	literal_text_out: STRING
			--
		do
			Result := opening_delimiter.twin
			if attached literal_text as al then
				across
					al as ic_char
				loop
					if ic_char.item = line_feed then
						Result.append_character ('\')
						Result.append_character ('n')
					elseif ic_char.item = carriage_return then
						Result.append_character ('\')
						Result.append_character ('r')
					elseif ic_char.item = horizontal_tab then
						Result.append_character ('\')
						Result.append_character ('t')
					elseif ic_char.item = backspace then
						Result.append_character ('\')
						Result.append_character ('b')
					elseif ic_char.item = form_feed then
						Result.append_character ('\')
						Result.append_character ('f')
					elseif ic_char.item = '(' then
						Result.append_character ('\')
						Result.append_character ('(')
					elseif ic_char.item = ')' then
						Result.append_character ('\')
						Result.append_character (')')
					elseif ic_char.item = reverse_solidus then
						Result.append_character ('\')
						Result.append_character ('\')
					else
						Result.append_character (ic_char.item)
					end
				end
			end
			Result.append_string_general (closing_delimiter)
		end

	hex_out: STRING
		local
			l_hex: STRING
		do
			Result := "<"
			across
				hex_data as ic
			loop
				l_hex := ic.item.to_hex_string
				l_hex.remove_head (ic.item // 16)
				Result.append_string_general (l_hex)
			end
			Result.append_character ('>')
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING
			-- <Precursor>
		once ("OBJECT")
			if attached literal_text and hex_data.is_empty then
				Result := left_parenthesis.out
			else
				Result := left_angle_bracket.out
			end
		end

	closing_delimiter: STRING
			-- <Precursor>
		once ("OBJECT")
			if attached literal_text and hex_data.is_empty then
				Result := right_parenthesis.out
			else
				Result := right_angle_bracket.out
			end
		end

end
