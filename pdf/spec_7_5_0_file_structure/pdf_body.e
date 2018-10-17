note
	description: "Summary description for {PDF_BODY}."

class
	PDF_BODY

inherit
	PDF_DOC_ELEMENT

feature -- Access

	last_id: INTEGER
			-- `last_id' used when `add_object' called.
		do
			Result := id
		end

feature -- Settings

	add_object (o: PDF_INDIRECT_OBJECT)
			--
		do
			id := id + 1
			o.set_object_number (id)
			objects.force (o, id)
		ensure
			incremented: old id = (last_id - 1)
		end

feature {NONE} -- Implementation: Access

	id: INTEGER

	objects: HASH_TABLE [PDF_OBJECT [detachable ANY], INTEGER]
			-- `objects' of Current.
		attribute
			create Result.make (100)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			across
				objects as ic
			loop
				Result.append_string_general (ic.item.pdf_out)
			end
		end

end
