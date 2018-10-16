note
	description: "Summary description for {PDF_OBJECT}."
	specification: "ISO 32000-1, section 7.3"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

deferred class
	PDF_OBJECT [G -> detachable ANY]

inherit
	PDF_TOKEN

feature -- Access

	value: detachable G
			-- The `value' (if any) of Current.

feature -- Queries

	length: INTEGER
			-- `length' of Current as character count.
		do
			Result := pdf_out.count
		end

	length_hex: STRING
			-- Hex version of `length'.
		do
			Result := pdf_out.count.to_hex_string
		end

feature -- Output

	pdf_out: STRING
			-- Output as PDF specification.
		deferred
		end

end
