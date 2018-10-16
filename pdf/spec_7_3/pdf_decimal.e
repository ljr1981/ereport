note
	description: "Summary description for {PDF_DECIMAL}."

class
	PDF_DECIMAL

inherit
	PDF_NUMERIC [DECIMAL]
		redefine
			default_create
		end

create
	default_create,
	make_with_string,
	make_with_integer,
	make_with_real

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			create value.make_zero
		end

	make_with_string (s: STRING)
		do
			create value.make_from_string (s)
		end

	make_with_integer (i: INTEGER)
		do
			create value.make_from_integer (i)
		end

	make_with_real (r: REAL)
		do
			create value.make_from_string (r.out)
		end

feature -- Output

	pdf_out: STRING
		do
			if attached value as al_value then
				Result := al_value.out
			else
				create Result.make_empty
			end
		end

note
	specification: "ISO 32000-1, section 7.3.3 Numeric Objects"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

end
