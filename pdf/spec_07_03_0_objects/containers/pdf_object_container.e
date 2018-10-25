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
			-- `add_object' of `obj' to `objects' list.
		do
			check has_objects: attached objects as al_objects then
				al_objects.force (obj)
			end
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append_string_general (opening_delimiter)
			Result.append_character ('%N')

				-- Content
			check has_objects: attached objects as al_objects then
				across
					al_objects as ic
				loop
					Result.append_string_general (ic.item.pdf_out)
					Result.append_character (' ')
				end
			end
			Result.adjust
			Result.append_character ('%N')

			Result.append_string_general (closing_delimiter)
			Result.append_character ('%N')
		end

note
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
