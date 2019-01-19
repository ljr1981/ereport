note
	title: "Abstract notion of a {PDF_OBJECT}."
	EIS: "name=7.1 General Syntax", "protocol=URI",
			"src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=19&view=FitH", "override=true"
	EIS: "name=7.3 Objects", "protocol=URI",
			"src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=21&view=FitH", "override=true"
	description: "[
		Objects. A PDF document is a data structure composed from a small set of basic types of data objects.
			Sub-clause 7.2, "Lexical Conventions," describes the character set used to write objects and other
			syntactic elements. Sub-clause 7.3, "Objects," describes the syntax and essential properties of the objects.
			Sub-clause 7.3.8, "Stream Objects," provides complete details of the most complex data type, the stream
			object.
		]"

deferred class
	PDF_OBJECT [G -> detachable ANY]

inherit
	PDF_ANY
		redefine
			pdf_out
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			if object_number > 0 then
				Result.append_string_general (object_number.out)
				Result.append_character (' ')
				Result.append_string_general (generation_number.out)
				Result.append_character (' ')
			end
		end

feature -- Access

	opening_delimiter: STRING
			-- Delimiter to open current, if any (i.e. empty string).
		deferred
		end

	value: detachable G
			-- The `value' (if any) of Current.

	closing_delimiter: STRING
			-- Delimiter to close current, if any (i.e. empty string).
		deferred
		end

	comment: detachable PDF_COMMENT
			-- A `comment' for Current (if any).

feature -- Access

	object_number: INTEGER

	generation_number: INTEGER

	ref: PDF_OBJECT_REFERENCE
		once ("OBJECT")
			create Result.make_with_object (Current)
		end

	parent_ref: detachable PDF_OBJECT_REFERENCE

feature -- Settings

	set_parent_ref (a_ref: attached like parent_ref)
			--
		do
			parent_ref := a_ref
		end

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

feature -- Settings

	set_value (a_value: attached like value)
			-- `set_value' of `a_value' into `value'.
		do
			value := a_value
		ensure
			set: value ~ a_value
		end

	set_comment (a_comment: STRING)
			-- `set_comment' of `a_comment' into `comment'.
		do
			create comment.make_with_text (a_comment)
		ensure
			set: attached comment as al_comment
		end

feature -- Queries

	pdf_out_count: INTEGER
			-- `pdf_out_count' of Current as character count.
		do
			Result := pdf_out.count
		end

	length_hex: STRING
			-- Hex version of `pdf_out_count'.
		do
			Result := pdf_out.count.to_hex_string
		end

	string_to_hex (s: STRING): ARRAY [INTEGER]
			-- Convert `string_to_hex' values for `s' as an integer array.
		local
			l_codes: ARRAYED_LIST [INTEGER]
		do
			create l_codes.make (s.count)
			across
				s as ic
			loop
				l_codes.force (ic.item.code)
			end
			Result := l_codes.to_array
		end

invariant
	postitive_number: object_number >= 0
	positive_generation: generation_number >= 0

end
