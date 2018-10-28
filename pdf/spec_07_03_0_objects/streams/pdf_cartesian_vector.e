note
	description: "Summary description for {PDF_CARTESIAN_VECTOR}."

class
	PDF_CARTESIAN_VECTOR

inherit
	ANY
		redefine
			default_create
		end

create
	default_create
	
feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			x := 0
			y := 0
			Precursor
		end

feature -- Access

	x: INTEGER assign set_x

	y: INTEGER assign set_y

	set_x (v: like x)
		do
			x := v
		end

	set_y (v: like x)
		do
			y := v
		end

end
