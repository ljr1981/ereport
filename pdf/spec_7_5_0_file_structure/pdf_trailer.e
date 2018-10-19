note
	description: "Representation of a {PDF_TRAILER}."

class
	PDF_TRAILER

inherit
	PDF_DOC_ELEMENT

feature -- Access

	size: PDF_KEY_VALUE
			-- `Size' of Current
			-- spec 7.5.5 Table 15
		attribute
			create Result.make_as_integer (Size_key_name, 0)
		end

	root: PDF_KEY_VALUE
			-- `root' object.
		attribute
			create Result
		end

	byte_offset: INTEGER

feature -- Settings

	set_size (i: INTEGER)
			-- `set_size' to `i' + 1
			-- spec 7.5.5 Table 15
		do
			size.set_value ([create {PDF_NAME}.make (Size_key_name), create {PDF_INTEGER}.make_with_integer (i + 1)])
		end

	set_root (r: PDF_INDIRECT_OBJECT)
			--
		do
			root.set_value ([create {PDF_NAME}.make (Root_key_name), r.ref])
		end

	set_byte_offset (i: INTEGER)
			--
		do
			byte_offset := i
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append_string_general (Trailer_kw)
			Result.append_character ('%N')

			Result.append_string_general (Opening_dictionary_marker)
			Result.append_character ('%N')

			Result.append_string_general (size.pdf_out)
			Result.append_character ('%N')
			Result.append_string_general (root.pdf_out)
			Result.append_character ('%N')

			Result.append_string_general (Closing_dictionary_marker)
			Result.append_character ('%N')

			Result.append_string_general (Startxref_kw)
			Result.append_character ('%N')
			Result.append_string_general (byte_offset.out)
			Result.append_character ('%N')
			Result.append_string_general (EOF_marker)
		end

feature {NONE} -- Implementation: Constants

	Size_key_name: STRING = "Size"
	Root_key_name: STRING = "Root"

	Trailer_kw: STRING = "trailer"

	Opening_dictionary_marker: STRING = "<<"
	Closing_dictionary_marker: STRING = ">>"

	Startxref_kw: STRING = "startxref"

	EOF_marker: STRING
			-- End-of-file marker.
		once
			create Result.make_empty
			Result.append_character ('%%')
			Result.append_character ('%%')
			Result.append_string_general (EOF_kw)
		end

	EOF_kw: STRING = "EOF"

;note
	main_spec: "7.5.5 File Trailer"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=PDF32000_2008.pdf"

	basic_layout: "[
trailer
	<< key1 value1
		key2 value2
		key3 value3
		...
		keyn valuen
	>>
Byte_offset_of_last_cross_reference_section
%%EOF
]"

end
