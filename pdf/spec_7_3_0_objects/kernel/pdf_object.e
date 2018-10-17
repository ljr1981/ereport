note
	description: "Summary description for {PDF_OBJECT}."
	specification: "ISO 32000-1, section 7.3"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

deferred class
	PDF_OBJECT [G -> detachable ANY]

inherit
	PDF_ANY

feature -- Access

	opening_delimiter: STRING
			--
		deferred
		end

	value: detachable G
			-- The `value' (if any) of Current.

	closing_delimiter: STRING
			--
		deferred
		end

feature -- Settings

	set_value (a_value: attached like value)
			--
		do
			value := a_value
		end

feature -- Queries

	length: INTEGER
			-- `length' of Current as character count.
		do
			Result := pdf_out.count
		end

	length_hex: STRING
			-- Hex version of `length'.
		do
			Result := pdf_out.count.to_hex_string
		end

	string_to_hex (s: STRING): ARRAY [INTEGER]
			--
		local
			l_codes: ARRAYED_LIST [INTEGER]
		do
			create l_codes.make (s.count)
			across
				s as ic
			loop
				l_codes.force (ic.item.code)
			end
			Result := l_codes.to_array
		end

end
