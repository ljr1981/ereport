note
	description: "Summary description for {PDF_FONT}."
	example: "[
4 0 obj
<</Type /Font
/Subtype /Type1
/Name /F1
/BaseFont /Helvetica
/Encoding /MacRomanEncoding
>>
endobj
]"

class
	PDF_FONT

inherit
	PDF_INDIRECT_OBJECT

create
	make,
	make_with_font_info

feature {NONE} -- Initialization

	make (a_name: STRING)
			--
		do
			default_create

			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

			create name.make_as_name ("Name", a_name)
			dictionary.add_object (name)
		end

	make_with_font_info (a_name: STRING; a_subtype, a_base_font, a_encoding: STRING)
			-- 
		do
			make (a_name)
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("Subtype", a_subtype))
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("BaseFont", a_base_font))
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("Encoding", a_encoding))
		end

feature {NONE} -- Implementation: Access

	type: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_name ("Type", "Font")
		end

	dictionary: PDF_DICTIONARY

	name: PDF_KEY_VALUE

end
