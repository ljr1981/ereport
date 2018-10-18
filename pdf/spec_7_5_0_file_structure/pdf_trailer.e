note
	description: "Summary description for {PDF_TRAILER}."

class
	PDF_TRAILER

inherit
	PDF_DOC_ELEMENT

feature -- Access

--	catalog: PDF_DOC_CATALOG
--			-- `catalog' per Spec 7.7.2
--		attribute
--			create Result
--		end

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
