note
	description: "Summary description for {PDF_TRAILER}."

class
	PDF_TRAILER

inherit
	PDF_DOC_ELEMENT

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
		end

;note
	main_spec: "7.5.5 File Trailer"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

	basic_layout: "[
trailer
	<< key1 value1
		key2 value2
		key3 value3
		...
		keyn valuen
	>>
Byte_offset_of_last_cross-reference_section
%%EOF
]"

end
