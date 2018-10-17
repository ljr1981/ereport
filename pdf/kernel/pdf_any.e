note
	description: "Summary description for {PDF_ANY}."
	specification: "ISO 32000-1, section 7.2"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

deferred class
	PDF_ANY

inherit
	PDF_CONSTANTS

feature -- Output

	pdf_out: STRING
			-- Output as PDF specification.
		deferred
		end

end
