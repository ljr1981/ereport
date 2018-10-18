note
	description: "Summary description for {PDF_STREAM_GENERAL}."

deferred class
	PDF_STREAM_GENERAL [G -> detachable ANY]

inherit
	PDF_OBJECT [G]
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			create dictionary
			create length.make_as_integer ("Length", 0)
			dictionary.add_object (length)
		end

feature {NONE} -- Implementation: Access

	length: PDF_KEY_VALUE

	content: G
		deferred
		end

feature -- Settings

	set_content (a_content: G)
			--
		deferred
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			if attached content as al_content then
				length.value.set_value (al_content.out.count)
			end
			Result.append_string_general (dictionary.pdf_out)
			Result.append_character ('%N')
			Result.append_string_general (opening_delimiter)
			Result.append_character ('%N')

				-- Contents
			if attached content as al_content then
				Result.append_string_general (al_content.out)
				Result.append_character ('%N')
			end

			Result.append_string_general (closing_delimiter)
			Result.append_character ('%N')
		end

feature {NONE} -- Implementation: Access

	dictionary: PDF_DICTIONARY

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := "stream" end
	closing_delimiter: STRING once ("OBJECT") Result := "endstream" end

;note
	ref: "7.3.8 Stream Objects"
	structure: "[
		<< dictionary >>
		stream
		...
		endstream
		]"

end
