note
	description: "Summary description for {PDF_NUMERIC}."

deferred class
	PDF_NUMERIC [G -> NUMERIC]

inherit
	PDF_OBJECT [G]

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := Space.out end
	closing_delimiter: STRING once ("OBJECT") Result := Space.out end

;note
	specification: "ISO 32000-1, section 7.3.3 Numeric Objects"
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
