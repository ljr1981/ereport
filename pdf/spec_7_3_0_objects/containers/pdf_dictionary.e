note
	description: "Summary description for {PDF_DICTIONARY}."

class
	PDF_DICTIONARY

inherit
	PDF_OBJECT [ARRAYED_LIST [PDF_KEY_VALUE]]
		rename
			value as objects
		redefine
			default_create
		end

create
	default_create,
	make,
	make_with_outlines

feature {NONE} -- Initialization

	make (a_type_value: STRING; a_pages_ref: PDF_OBJECT_REFERENCE)
			--
		do
			default_create
			make_with_type (a_type_value)
			create pages.make_as_obj_ref ("Pages", a_pages_ref)

			check has_pages: attached pages as al_pages then
				add_object (al_pages)
			end
		end

	make_with_type (a_type_value: STRING)
			--
		do
			default_create
			create type.make_as_name ("Type", a_type_value)

			add_object (type)
		end

	make_with_outlines (a_type_value: STRING; a_pages_ref, a_outlines_ref: PDF_OBJECT_REFERENCE)
			--
		do
			make (a_type_value, a_pages_ref)
			create outlines.make_as_obj_ref ("Outlines", a_outlines_ref)

			check has_outlines: attached outlines as al_outlines then
				add_object (al_outlines)
			end
		end

	default_create
			-- <Precursor>
		do
			create objects.make (10)
		end

feature -- Access

	type: PDF_KEY_VALUE
			-- The `type' of PDF object this dictionary describes.
			-- Shall be "Catalog" for the catalog dictionary.
		attribute
			create Result.make_as_name ("Type", "Unknown")
		end

	pages: detachable PDF_KEY_VALUE

	outlines: detachable PDF_KEY_VALUE

feature -- Settings

	add_object (obj: PDF_KEY_VALUE)
		do
			objects_attached.force (obj)
		end

	add_keyed_array (a_key: STRING; a_obj: PDF_ARRAY)
		do
			objects_attached.force (create {PDF_KEY_VALUE}.make_as_array (a_key, a_obj))
		end

	add_keyed_array_of_refs (a_key: STRING; a_obj: PDF_ARRAY)
		do
			objects_attached.force (create {PDF_KEY_VALUE}.make_as_array_of_refs (a_key, a_obj))
		end

	set_pages (a_obj_ref: PDF_OBJECT_REFERENCE)
		do
			create pages.make_as_obj_ref ("Pages", a_obj_ref)
		end

	set_outlines (a_obj_ref: PDF_OBJECT_REFERENCE)
		do
			create outlines.make_as_obj_ref ("Outlines", a_obj_ref)
		end

	set_from_array (a_objects: ARRAY [PDF_KEY_VALUE])
		do
			check has_objects: attached objects as al_objects then
				across
					a_objects as ic
				loop
					al_objects.force (ic.item)
				end
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
			across
				objects_attached as ic
			loop
				Result.append_string_general (ic.item.key.pdf_out)
				Result.append_character (' ')
				Result.append_string_general (ic.item.value.pdf_out)
				Result.append_character ('%N')
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

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING = "<<"
	closing_delimiter: STRING = ">>"

invariant
	type_set: type.key.pdf_out.same_string_general ("/Type")
	pages_set: attached pages as al_pages implies al_pages.key.pdf_out.same_string_general ("/Pages")
	outlines_set: attached outlines as al_outlines implies al_outlines.key.pdf_out.same_string_general ("/Outlines")

end
