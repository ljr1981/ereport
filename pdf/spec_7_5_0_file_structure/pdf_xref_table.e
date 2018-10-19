note
	description: "Summary description for {PDF_XREF_TABLE}."

class
	PDF_XREF_TABLE

inherit
	PDF_DOC_ELEMENT

feature -- Access

	Size: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_integer ("Size", 0)
		end

	Root: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_dictionary ("Root", Root_dictionary)
		end

	Root_dictionary: PDF_DICTIONARY
			--
		attribute
			create Result
		end

	lines: ARRAYED_LIST [PDF_XREF_IND_OBJ_LINE]
			-- List of `lines'
		attribute
			create Result.make (10)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		local
			l_line: PDF_XREF_IND_OBJ_LINE
		do
			create l_line
			create Result.make_empty
			Result.append_string_general ("xref")
			Result.append_character ('%N')
			Result.append_character ('0') -- obj# of first object in subsection (0000000000)
			Result.append_character (' ')
			Result.append_string_general (lines.count.out) -- count of obj's in subsection (7.5.4 NOTE 2 EXAMPLE 1)
			Result.append_character ('%N')
			Result.append_string_general (l_line.first_line)
			across
				lines as ic
			loop
				Result.append_string_general (ic.item.line)
			end
		end

;note
	main_spec: "7.5.4 Cross-Reference Table"
	other_specs: "EXAMPLEs 1, 2, and 3"
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

	example: "[
xref
0 6
0000000003 65535 f
0000000017 00000 n
0000000081 00000 n
0000000000 00007 f
0000000331 00000 n
0000000409 00000 n
]"

end
