note
	title: "Representation of a {PDF_DECIMAL}."
	EIS: "name=7.3.4 Real Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=22&view=FitH", "override=true"
	description: "[
		A real value shall be written as one or more decimal digits with an optional sign and a leading, trailing, or
		embedded PERIOD (2Eh) (decimal point). The value shall be interpreted as a real number and shall be
		converted to a real object.
		]"

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

	make_with_string (a_real_as_string: STRING)
			-- `make_with_string' with `a_real_as_string'.
		require
			valid_conversion: a_real_as_string.is_real
		do
			create value.make_from_string (a_real_as_string)
		ensure
			set: attached value as al_value and then al_value.out.same_string (a_real_as_string)
		end

	make_with_integer (i: INTEGER)
			-- `make_with_integer' of `i'
		do
			create value.make_from_integer (i)
		ensure
			set: attached value as al_value and then al_value.out.same_string (i.out)
		end

	make_with_real (r: REAL)
			-- `make_with_real' of `r'
		do
			create value.make_from_string (r.out)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			if attached value as al_value then
				Result := al_value.out
			else
				create Result.make_empty
			end
			Result.adjust
		end

end
