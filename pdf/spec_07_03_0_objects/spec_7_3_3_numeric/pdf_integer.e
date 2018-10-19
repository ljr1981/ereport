note
	description: "Summary description for {PDF_INTEGER}."

class
	PDF_INTEGER

inherit
	PDF_NUMERIC [INTEGER]

create
	default_create,
	make_with_string,
	make_with_integer,
	make_with_real

feature {NONE} -- Initialization

	make_with_string (s: STRING)
		require
			s.is_integer
		do
			value := s.to_integer
		end

	make_with_integer (i: INTEGER)
		do
			value := i
		end

	make_with_real (r: REAL)
		do
			value := r.truncated_to_integer
		end

feature -- Output

	pdf_out: STRING
		do
			Result := value.out
			Result.adjust
		end

note
	main_spec: "ISO 32000-1, section 7.3.3 Numeric Objects"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end