note
	title: "Representation of a {PDF_NAME}."
	EIS: "name=7.3.5 Name Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=24&view=FitH", "override=true"
	description: "[
		Beginning with PDF 1.2 a name object is an atomic symbol uniquely defined by a sequence of any characters
		(8-bit values) except null (character code 0). Uniquely defined means that any two name objects made up of
		the same sequence of characters denote the same object. Atomic means that a name has no internal structure;
		although it is defined by a sequence of characters, those characters are not considered elements of the name.
		]"
	examples: "[
		Table 4 – Examples of literal names
		===================================
		Syntax for Literal name 			Resulting Name
		----------------------------------- ---------------------------------
		/Name1 								Name1
		/ASomewhatLongerName 				ASomewhatLongerName
		/A;Name_With-Various***Characters? 	A;Name_With-Various***Characters?
		/1.2 								1.2
		/$$ 								$$
		/@pattern 							@pattern
		/.notdef 							.notdef
		/lime#20Green 						Lime Green
		/paired#28#29parentheses 			paired()parentheses
		/The_Key_of_F#23_Minor 				The_Key_of_F#_Minor
		/A#42 								AB
		]"

class
	PDF_NAME

inherit
	PDF_OBJECT [STRING]
		rename
			value as text
		redefine
			pdf_out
		end

create
	make

feature {NONE} -- Intialization

	make (s: STRING)
			-- `make' Current with `s'
		require
			not_empty: not s.is_empty
		do
			text := s
		ensure
			attached text as al_text and then al_text.same_string (s)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			Result := Opening_delimiter.twin
			if attached text as al_text then
				across
					al_text as ic
				loop
					if ic.item = '#' then
						Result.append_string_general ("#23")
					elseif ic.item = ' ' then
						Result.append_string_general ("#20")
					elseif ic.item = '(' then
						Result.append_string_general ("#28")
					elseif ic.item = ')' then
						Result.append_string_general ("#29")
					else
						Result.append_character (ic.item)
					end
				end
				Result.append_string_general (Closing_delimiter)
				Result.adjust
			else
				create Result.make_empty
			end
			Result.adjust
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := Solidus.out end
	closing_delimiter: STRING once ("OBJECT") Result := Space.out end

end
