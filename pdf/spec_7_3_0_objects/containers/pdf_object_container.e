note
	description: "Summary description for {PDF_OBJECT_CONTAINER}."

deferred class
	PDF_OBJECT_CONTAINER

inherit
	PDF_OBJECT [ARRAYED_LIST [PDF_OBJECT [detachable ANY]]]
		rename
			value as objects
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			create objects.make (10)
		end

feature -- Settings

	add_object (obj: PDF_OBJECT [detachable ANY])
		do
			objects_attached.force (obj)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append_string_general (opening_delimiter)
			Result.append_character ('%N')

				-- Content
			across
				objects_attached as ic
			loop
				Result.append_string_general (ic.item.pdf_out)
				Result.append_character (' ')
			end

			Result.append_character ('%N')
			Result.append_string_general (closing_delimiter)
			Result.append_character ('%N')
		end

feature {NONE} -- Implementation

	objects_attached: attached like objects
		do
			check attached objects as al then Result := al end
		end

end
