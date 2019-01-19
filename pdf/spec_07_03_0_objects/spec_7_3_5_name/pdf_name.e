note
	description: "Summary description for {PDF_NAME}."
	EIS: "name=7.3.5 Name Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=24&view=FitH", "override=true"

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
			Result := Solidus.out
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
				Result.adjust
			else
				create Result.make_empty
			end
			Result.adjust
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := Solidus.out end
	closing_delimiter: STRING once ("OBJECT") Result := Space.out end

;note
	main_spec: "ISO 32000-1, section 7.3.4.2 Literal Strings"
	other_specs: ""

end
