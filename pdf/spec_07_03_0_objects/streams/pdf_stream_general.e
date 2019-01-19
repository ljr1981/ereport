note
	title: "Representation of a {PDF_STREAM_GENERAL}."
	EIS: "name=7.3.8 Stream Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=27&view=FitH", "override=true"
	description: "[
		A stream object, like a string object, is a sequence of bytes. Furthermore, a stream may be of unlimited length,
		whereas a string shall be subject to an implementation limit. For this reason, objects with potentially large
		amounts of data, such as images and page descriptions, shall be represented as streams.
		
		NOTE 1 This sub-clause describes only the syntax for writing a stream as a sequence of bytes. The context in which a
		stream is referenced determines what the sequence of bytes represent.
		
		A stream shall consist of a dictionary followed by zero or more bytes bracketed between the keywords stream
		(followed by newline) and endstream.
		]"

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
			create length.make ("Length", 0)
			dictionary.add_object (length)
		end

feature {NONE} -- Implementation: Access

	length: PDF_KEY_VALUE_INTEGER

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
			Result.adjust
		end

feature {NONE} -- Implementation: Access

	dictionary: PDF_DICTIONARY_GENERAL

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
