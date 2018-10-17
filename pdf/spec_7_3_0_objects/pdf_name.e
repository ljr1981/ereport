note
	description: "Summary description for {PDF_NAME}."

class
	PDF_NAME

inherit
	PDF_OBJECT [STRING]
		rename
			value as text
		end

create
	make

feature {NONE} -- Intialization

	make (s: STRING)
			--
		do
			text := s
		ensure
			attached text as al_text and then al_text.same_string (s)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			if attached text as al_text then
				create Result.make (al_text.count + 1)
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
			else
				create Result.make_empty
			end
			Result.prepend_character (Solidus)
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := Solidus.out end
	closing_delimiter: STRING once ("OBJECT") Result := Space.out end

;note
	specification: "ISO 32000-1, section 7.3.4.2 Literal Strings"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

end
