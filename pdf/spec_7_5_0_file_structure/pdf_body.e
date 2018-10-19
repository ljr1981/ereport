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

feature -- Basic Operations

	xref_table: PDF_XREF_TABLE
			--
		attribute
			create Result
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
		local
			l_obj_string: STRING
			l_start,
			l_end,
			l_offset: INTEGER
		do
			create Result.make_empty
			across
				objects as ic
			loop
				l_obj_string := ic.item.pdf_out
				l_start := Result.count
				l_end := l_start + l_obj_string.count
				l_offset := l_end - l_start
				Result.append_string_general (l_obj_string)
				check mismatched_offset: l_offset = (Result.count - l_start) end
			end
		end

;note
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
