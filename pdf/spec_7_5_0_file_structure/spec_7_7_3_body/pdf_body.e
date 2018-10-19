note
	description: "Summary description for {PDF_BODY}."

class
	PDF_BODY

inherit
	PDF_DOC_GENERAL

feature -- Access

	last_id: INTEGER
			-- `last_id' used when `add_object' called.
		do
			Result := id
		end

	root: PDF_INDIRECT_OBJECT
			--
		do
			check has_root: attached objects.item (1) as al_root then
				Result := al_root
			end
		end

	byte_offset: INTEGER
			--

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

	objects: HASH_TABLE [PDF_INDIRECT_OBJECT, INTEGER]
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
			l_offset,
			l_total: INTEGER
			l_line: PDF_XREF_IND_OBJ_LINE
		do
			create Result.make_empty
			across
				objects as ic
			from
				l_total := 0
			loop
				l_obj_string := ic.item.pdf_out
				l_start := Result.count
				l_end := l_start + l_obj_string.count
				l_offset := l_end - l_start

				Result.append_string_general (l_obj_string)

				check mismatched_offset: l_offset = (Result.count - l_start) end
				l_total := l_total + l_offset
				-- for each
				-- create a PDF_XREF_IND_OBJ_LINE
				create l_line
				l_line.set_in_use
				l_line.set_line_offset (l_total)
				l_line.set_generation_value (0)
				-- add the xref line to the xref table
				xref_table.lines.force (l_line)
			end
			-- check: ought to have a filled up xref table incl. first-line
			-- generate the xref table and add it to the "Result"
			byte_offset := Result.count
			Result.append_string_general (xref_table.pdf_out)
			-- generate the trailer obj to finish it off
			-- done!
		end

;note
	main_spec: "7.7.3"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
