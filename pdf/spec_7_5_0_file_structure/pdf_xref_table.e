note
	description: "Summary description for {PDF_XREF_TABLE}."

class
	PDF_XREF_TABLE

inherit
	PDF_DOC_ELEMENT

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
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
