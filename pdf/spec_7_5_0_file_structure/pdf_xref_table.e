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
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
