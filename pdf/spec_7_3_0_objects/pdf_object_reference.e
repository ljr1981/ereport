note
	description: "Summary description for {PDF_OBJECT_REFERENCE}."

class
	PDF_OBJECT_REFERENCE

inherit
	PDF_OBJECT [detachable ANY]

create
	make_with_object

feature {NONE} -- Initialization

	make_with_object (obj: like object)
			--
		do
			object := obj
		end

feature -- Access

	object: PDF_INDIRECT_OBJECT

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append_string_general (object.object_number.out)
			Result.append_character (' ')
			Result.append_string_general (object.generation_number.out)
			Result.append_character (' ')
			Result.append_string_general ("R")
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := "" end
	closing_delimiter: STRING once ("OBJECT") Result := "" end

;end
