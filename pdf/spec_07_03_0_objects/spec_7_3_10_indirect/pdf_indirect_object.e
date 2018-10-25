note
	description: "Summary description for {PDF_INDIRECT_OBJECT}."

class
	PDF_INDIRECT_OBJECT

inherit
	PDF_OBJECT_CONTAINER
		redefine
			pdf_out
		end

feature -- Access

	object_number: INTEGER

	generation_number: INTEGER

	ref: PDF_OBJECT_REFERENCE
		once ("OBJECT")
			create Result.make_with_object (Current)
		end

	parent_ref: detachable PDF_OBJECT_REFERENCE

feature -- Settings

	set_object_number (n: like object_number)
			--
		do
			if object_number = 0 then
				object_number := n
			end
		ensure
			set: old object_number = 0 implies object_number = n
		end

	set_generation_number (n: like generation_number)
			--
		do
			if generation_number = 0 then
				generation_number := n
			end
		ensure
			set: old generation_number = 0 implies generation_number = n
		end

	set_parent_ref (a_ref: attached like parent_ref)
			--
		do
			parent_ref := a_ref
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			check has_obj_number: object_number > 0 end
			Result.append_string_general (object_number.out)
			Result.append_character (' ')
			Result.append_string_general (generation_number.out)
			Result.append_character (' ')
			Result.append_string_general (Precursor)
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING = "obj"
	closing_delimiter: STRING = "endobj"

invariant
	postitive_number: object_number >= 0
	positive_generation: generation_number >= 0

;note
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
