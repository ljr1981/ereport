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

end
