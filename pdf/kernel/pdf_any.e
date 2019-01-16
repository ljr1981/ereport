note
	description: "Root class {PDF_ANY}."
	specification: "ISO 32000-1, section 7.2"

deferred class
	PDF_ANY

inherit
	PDF_CONSTANTS

	PDF_DOCS -- General library documentation.

feature -- Output

	pdf_out: STRING
			-- Output as PDF specification.
		deferred
		end

;note
	design: "[
		All PDF_* classes are capable of being output for inclusion
		in a generated PDF file.
		]"

end
