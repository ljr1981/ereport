note
	description: "Summary description for {PDF_KEY_REF_VALUE}."

class
	PDF_KEY_REF_VALUE

inherit
	PDF_KEY_VALUE

create
	make

feature {NONE} -- Initialization

	make (a_key: STRING; a_obj_ref: PDF_OBJECT_REFERENCE)
			--
		do
			make_as_obj_ref (a_key, a_obj_ref)
		end

end
