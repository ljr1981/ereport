note
	title: "Representation of a {PDF_INTEGER}."
	EIS: "name=7.3.3 Integer Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=22&view=FitH", "override=true"
	description: "[
		PDF provides two types of numeric objects: integer and real. Integer objects represent mathematical integers.
		Real objects represent mathematical real numbers. The range and precision of numbers may be limited by the
		internal representations used in the computer on which the conforming reader is running; Annex C gives these
		limits for typical implementations.
		
		An integer shall be written as one or more decimal digits optionally preceded by a sign. The value shall be
		interpreted as a signed decimal integer and shall be converted to an integer object.
		]"

class
	PDF_INTEGER

inherit
	PDF_NUMERIC [INTEGER]
		redefine
			pdf_out
		end

create
	default_create,
	make_with_string,
	make_with_integer,
	make_with_real

feature {NONE} -- Initialization

	make_with_string (a_integer_as_string: STRING)
			-- `make_with_string' with `a_integer_as_string'
		require
			a_integer_as_string.is_integer
		do
			value := a_integer_as_string.to_integer
		ensure
			created: attached value as al_value and then al_value.out.same_string (a_integer_as_string)
		end

	make_with_integer (i: INTEGER)
			-- `make_with_integer' of `i'
		do
			value := i
		ensure
			set: value = i
		end

	make_with_real (r: REAL)
			-- `make_with_real' of truncated `r'.
		do
			make_with_integer (r.truncated_to_integer)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			Result := value.out
			Result.adjust
		end

end
