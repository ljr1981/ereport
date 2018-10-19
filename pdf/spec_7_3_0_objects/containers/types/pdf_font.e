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
			-- `make' with `a_name' /Name /Value key-value.
		do
			default_create

			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

			create name.make_as_name ("Name", a_name)
			dictionary.add_object (name)
		end

	make_with_font_info (a_name: STRING; a_subtype, a_base_font, a_encoding: STRING)
			-- `make_with_font_info' through `make', with added font-info.
		do
			make (a_name)
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("Subtype", a_subtype))
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("BaseFont", a_base_font))
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("Encoding", a_encoding))
		end

feature -- Access

	name: PDF_KEY_VALUE
			-- /Name /[Value]

feature {NONE} -- Implementation: Access

	type: PDF_KEY_VALUE
			-- /Type /Font
		attribute
			create Result.make_as_name ("Type", "Font")
		end

	dictionary: PDF_DICTIONARY

feature -- Queries

	name_value: STRING
			-- Value of `name' (/Name /[Value]).
		do
			check has_name: attached {STRING} name.value_in_value as al_text then
				Result := al_text
			end
		end

;note
	main_spec: "9.2 Organization and Use of Fonts"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
