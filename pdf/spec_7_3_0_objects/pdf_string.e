note
	description: "Summary description for {PDF_STRING}."

class
	PDF_STRING

inherit
	PDF_OBJECT [STRING]
		rename
			value as literal_text
		end

create
	make_as_literal,
	make_as_hex

feature {NONE} -- Intialization

	make_as_literal (s: STRING)
			--
		do
			literal_text := s
		ensure
			attached literal_text as al and then al.same_string (s)
		end

	make_as_hex (a_list: ARRAY [INTEGER])
			--
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
			--
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

	opening_delimiter: STRING once ("OBJECT") Result := left_parenthesis.out end
	closing_delimiter: STRING once ("OBJECT") Result := right_parenthesis.out end

;note
	specification: "ISO 32000-1, section 7.3.4.2 Literal Strings"
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
