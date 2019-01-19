note
	title: "Representation of a {PDF_DICTIONARY_GENERAL}."
	EIS: "name=7.3.7 Dictionary Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=26&view=FitH", "override=true"
	description: "[
		A dictionary object is an associative table containing pairs of objects, known as the dictionary’s entries. The first
		element of each entry is the key and the second element is the value. The key shall be a name (unlike
		dictionary keys in PostScript, which may be objects of any type). The value may be any kind of object, including
		another dictionary. A dictionary entry whose value is null (see 7.3.9, "Null Object") shall be treated the same as
		if the entry does not exist. (This differs from PostScript, where null behaves like any other object as the value
		of a dictionary entry.) The number of entries in a dictionary shall be subject to an implementation limit; see
		Annex C. A dictionary may have zero entries.
		]"

class
	PDF_DICTIONARY_GENERAL

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
	make_with_pages,
	make_with_type,
	make_with_outlines

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			create objects.make (10)
		end

	make
			-- Creates Current with no `type', `pages', or `outlines'.
		do
			default_create
		end

	make_with_pages (a_type_value: STRING; a_pages_ref: PDF_OBJECT_REFERENCE)
			-- Creates current with `type' and `pages', but no `outlines'.
		do
			default_create
			make_with_type (a_type_value)
			create pages.make_as_obj_ref ("Pages", a_pages_ref)

			check has_pages: attached pages as al_pages then
				add_object (al_pages)
			end
		end

	make_with_type (a_type_value: STRING)
			-- Creates current with only `type' defined, but no `pages' or `outlines'.
		do
			default_create
			create type.make ("Type", a_type_value)

			add_object (type)
		end

	make_with_outlines (a_type_value: STRING; a_pages_ref, a_outlines_ref: PDF_OBJECT_REFERENCE)
			-- `make_with_outlines' with `a_type_value', `a_pages_ref', and `a_outlines_ref'.
			-- Creates current with `type', `pages', and `outlines' fully defined.
		do
			make_with_pages (a_type_value, a_pages_ref)
			create outlines.make_as_obj_ref ("Outlines", a_outlines_ref)

			check has_outlines: attached outlines as al_outlines then
				add_object (al_outlines)
			end
		end

feature -- Access

	type: PDF_KEY_VALUE_NAME
			-- The `type' of PDF object this dictionary describes.
			-- Defaulted to "Catalog" for the catalog dictionary.
		attribute
			create Result.make ("Type", "Unknown")
		end

	pages: detachable PDF_KEY_VALUE
			-- The `pages' key-value pair of Current.

	outlines: detachable PDF_KEY_VALUE
			-- The `outlines' key-value pair of Current.

feature -- Settings

	add_object (obj: PDF_KEY_VALUE)
			-- `add_object' in `obj' to `objects' of Current.
		do
			objects_attached.force (obj)
		end

	add_keyed_array (a_key: STRING; a_obj: PDF_ARRAY)
			-- `add_keyed_array' with `a_key' for `a_obj' to `objects' of Current.
		do
			objects_attached.force (create {PDF_KEY_VALUE}.make_as_array (a_key, a_obj))
		end

	add_keyed_array_of_refs (a_key: STRING; a_obj: PDF_ARRAY)
			-- `add_keyed_array_of_refs' with `a_key' for `a_obj' to `objects' of Current.
		do
			objects_attached.force (create {PDF_KEY_VALUE}.make_as_array_of_refs (a_key, a_obj))
		end

	set_pages (a_obj_ref: PDF_OBJECT_REFERENCE)
			-- `set_pages' from `a_obj_ref' as `pages'.
		do
			create pages.make_as_obj_ref ("Pages", a_obj_ref)
		end

	set_outlines (a_obj_ref: PDF_OBJECT_REFERENCE)
			-- `set_outlines' from `a_obj_ref' as `outlines'.
		do
			create outlines.make_as_obj_ref ("Outlines", a_obj_ref)
		end

	set_from_array (a_objects: ARRAY [PDF_KEY_VALUE])
			-- `set_from_array' of objects in `a_object' into `objects'.
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
			Result.append_string_general (Opening_delimiter)
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
			Result.adjust

			Result.append_character ('%N')
			Result.append_string_general (Closing_delimiter)
			Result.append_character ('%N')
			Result.adjust
		end

feature {NONE} -- Implementation

	objects_attached: attached like objects
			-- Attached version of `objects'.
		do
			check attached objects as al then Result := al end
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := Double_opening_angle_brackets end -- "<<"
	closing_delimiter: STRING once ("OBJECT") Result := Double_closing_angle_brackets end -- ">>"

invariant
	type_set: type.key.pdf_out.same_string_general (Type_name)
	pages_set: attached pages as al_pages implies al_pages.key.pdf_out.same_string_general (Pages_name)
	outlines_set: attached outlines as al_outlines implies al_outlines.key.pdf_out.same_string_general (Outlines_name)

end
