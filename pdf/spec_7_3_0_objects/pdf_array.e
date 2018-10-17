note
	description: "Summary description for {PDF_ARRAY}."

class
	PDF_ARRAY

inherit
	PDF_OBJECT [ARRAYED_LIST [PDF_OBJECT [detachable ANY]]]
		rename
			value as items
		redefine
			default_create
		end

create
	default_create,
	make_with_objects

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			make_with_objects (<<>>)
		end

	make_with_objects (a_objects: ARRAY [PDF_OBJECT [detachable ANY]])
			-- `make_with_objects' in list `a_objects'.
		do
			create items.make_from_array (a_objects)
		end

feature -- Output

	pdf_out: STRING
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := left_square_bracket.out end
	closing_delimiter: STRING once ("OBJECT") Result := right_square_bracket.out end

;note
	specification: "ISO 32000-1, section 7.3.6 Array Objects"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

end
