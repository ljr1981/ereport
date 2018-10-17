note
	description: "Summary description for {PDF_RECTANGLE}."

class
	PDF_RECTANGLE

inherit
	PDF_TOKEN
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			create lower_left_x.make_zero
			create lower_left_y.make_zero
			create upper_right_x.make_zero
			create upper_right_y.make_zero
		end

feature -- Access

	lower_left_x,
	lower_left_y,
	upper_right_x,
	upper_right_y: DECIMAL

feature -- Settings

	set_lower_left_x (s: STRING)
			--
		do
			create lower_left_x.make_from_string (s)
		end

	set_lower_left_y (s: STRING)
			--
		do
			create lower_left_y.make_from_string (s)
		end

	set_upper_right_x (s: STRING)
			--
		do
			create upper_right_x.make_from_string (s)
		end

	set_upper_right_y (s: STRING)
			--
		do
			create upper_right_y.make_from_string (s)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
		end

end
