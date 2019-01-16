note
	description: "Summary description for {PDF_RECTANGLE}."

class
	PDF_RECTANGLE

inherit
	PDF_ARRAY
		redefine
			pdf_out
		end

create
	make

feature {NONE} -- Initialization

	make (llx, lly, urx, ury: STRING)
			--
		do
			default_create
			set_lower_left_x (llx)
			set_lower_left_y (lly)
			set_upper_right_x (urx)
			set_upper_right_y (ury)
		end


feature -- Settings

	set_lower_left_x (s: STRING)
			--
		do
			if attached items as al_items then
				al_items.force (create {PDF_DECIMAL}.make_with_string (s))
			end
		end

	set_lower_left_y (s: STRING)
			--
		do
			if attached items as al_items then
				al_items.force (create {PDF_DECIMAL}.make_with_string (s))
			end
		end

	set_upper_right_x (s: STRING)
			--
		do
			if attached items as al_items then
				al_items.force (create {PDF_DECIMAL}.make_with_string (s))
			end
		end

	set_upper_right_y (s: STRING)
			--
		do
			if attached items as al_items then
				al_items.force (create {PDF_DECIMAL}.make_with_string (s))
			end
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			Result := Precursor
			Result.adjust
		end

;note
	main_spec: ""
	other_specs: ""

end
